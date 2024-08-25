import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';

import '../components/direct_number_selector.dart';
import '../components/my_btn_container.dart';
import '../components/no_lotto_noti.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/lotto_service/get_cashed_date.dart';
import '../features/user_service/user_provider.dart';
import '../models/lotto_result_model/lotto_result.dart';
import '../models/user_game_model/user_game.dart';

class DrawPage extends ConsumerStatefulWidget {
  const DrawPage({super.key});

  @override
  ConsumerState<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends ConsumerState<DrawPage> {
  LottoResult? _nextLottoResult;
  List<UserGame> cachedUserGames = [];

  // 최대 허용 게임 수 정의 (기본: 5, 인앱 결제 후 변경 가능)
  int maxGames = 5;

  @override
  void initState() {
    super.initState();
    _loadNextLottoResult();
  }

  Future<void> _loadNextLottoResult() async {
    LottoResult? result = await getCachedLottoResult();
    if (result != null) {
      setState(() {
        _nextLottoResult = result;
      });
      _loadCachedUserGames(); // LottoResult 로드 후 캐시된 게임도 로드
    }
  }

  Future<void> _loadCachedUserGames() async {
    final cacheManager = DefaultCacheManager();
    final user = ref.read(authServiceProvider);
    if (user != null && _nextLottoResult != null) {
      final cacheKey = 'user_game_${user.uid}_${_nextLottoResult!.roundNumber + 1}';
      try {
        final fileInfo = await cacheManager.getFileFromCache(cacheKey);
        if (fileInfo != null) {
          final jsonString = await fileInfo.file.readAsString();
          final List<dynamic> jsonData = jsonDecode(jsonString);
          final List<UserGame> userGames =
          jsonData.map((gameJson) => UserGame.fromJson(gameJson)).toList();
          setState(() {
            cachedUserGames = userGames;
          });
        }
      } catch (e) {
        print('Error reading cached user games: $e');
      }
    }
  }

  Future<void> _saveGamesToCache(List<UserGame> games) async {
    final cacheManager = DefaultCacheManager();
    final user = ref.read(authServiceProvider);
    if (user != null && _nextLottoResult != null) {
      final cacheKey = 'user_game_${user.uid}_${_nextLottoResult!.roundNumber + 1}';
      try {
        final jsonString = jsonEncode(games.map((game) => game.toJson()).toList());
        await cacheManager.putFile(cacheKey, utf8.encode(jsonString));
      } catch (e) {
        print('Error saving games to cache: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelNotifierProvider);
    final user = ref.watch(authServiceProvider);
    final userModelClass = ref.watch(userModelNotifierProvider.notifier);

    // 현재 저장된 게임 수가 최대 허용 수에 도달했는지 여부 확인
    bool isMaxGamesReached = cachedUserGames.length >= maxGames;

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                Text(
                  '추첨하기',
                  style: appBarTitleTextStyleWithStroke,
                ),
                Text(
                  '추첨하기',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Image.asset(
            'assets/images/lotto_more.png',
            width: 32,
          ),
          const SizedBox(width: 16)
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                FutureBuilder<LottoResult?>(
                  future: getCachedLottoResult(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(height: 70);
                    } else if (snapshot.hasError) {
                      return Center(child: Text('에러 발생: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      _nextLottoResult = snapshot.data!;
                      print(
                          '이 화면에서 쓰이는 공통회차 _nextLottoResult!.roundNumber +1 : ${_nextLottoResult!.roundNumber + 1}');
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '회차 : ${_nextLottoResult!.roundNumber + 1}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '추첨일 : ${_nextLottoResult!.nextWeekDrawDate}',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: Text('Failed Lotto Result loading.'));
                    }
                  },
                ),
                _nextLottoResult != null
                    ? Expanded(
                  child: cachedUserGames.isNotEmpty
                      ? ListView.builder(
                    itemCount: cachedUserGames.length,
                    itemBuilder: (context, index) {
                      final game = cachedUserGames[index];
                      final sortedNumbers = game.selectedDrwNos.toList()..sort();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: sortedNumbers.map((number) {
                              return CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  number.toString(),
                                  style: ballTextStyle,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )
                      : const NoLottoNoti(),
                )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: isMaxGamesReached
          // maxGame수에 도달했으면 아무것도 안하게끔.. 여기에 나중에 결제관련 내용이 들어갈 것 null부분에...
          // ###################
              ? null
          // ###################
              : () async {
            if (_nextLottoResult != null && user != null) {
              final UserGame? newGame = await showDialog<UserGame>(
                context: context,
                builder: (BuildContext context) {
                  return NumberSelectionScreen(
                    playerUid: user.uid,
                    roundNo: _nextLottoResult!.roundNumber + 1,
                  );
                },
              );

              if (newGame != null) {
                setState(() {
                  cachedUserGames.add(newGame);
                });
                await _saveGamesToCache(cachedUserGames);
              }
            } else {
              print('Lotto result or user is not available');
            }
          },
          child: MyBtnContainer(
            color: isMaxGamesReached ? Colors.grey : specialBlue,
            child: const Center(
              child: Text(
                '뽑기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}