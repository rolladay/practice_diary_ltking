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
import '../features/lotto_service/lotto_result_manager.dart';
import '../features/lotto_service/usergame_manager.dart';
import '../features/user_service/user_provider.dart';
import '../models/lotto_result_model/lotto_result.dart';
import '../models/user_game_model/user_game.dart';

class DrawPage extends ConsumerStatefulWidget {
  const DrawPage({super.key});

  @override
  ConsumerState<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends ConsumerState<DrawPage> {
  // 다음로또회차(+1) 하기위한 현재(결과가 나온) 로또리절트 객체
  LottoResult? _nextLottoResult;
  List<UserGame> loadedUserGames = [];

  bool _isLoading = true; // 로딩 상태를 추적하는 변수
  String? _errorMessage; // 에러 메시지를 저장하는 변수

  @override
  void initState() {
    super.initState();
    _initializeData(); // 데이터를 초기화하는 함수 호출
  }

  // 이게 비동기가 initState로 못들어가니까 따로 빼서 진행
  Future<void> _initializeData() async {
    await _loadNextLottoResult(); // 비동기적으로 LottoResult 로드 후에 아래꺼 진행
    await _loadCachedUserGames(); // LottoResult 로드 후 유저 게임 로드
  }

  // 최근(마지막추첨한) 로또리절트를 가져오고, 캐시에 저장된 유저게임리스트 불러온다.
  Future<void> _loadNextLottoResult() async {
    try {
      LottoResult? result = await getCachedLottoResult();
      if (result != null) {
        setState(() {
          _nextLottoResult = result;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed Lotto Result loading.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading Lotto Result: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태를 false로 설정
      });
    }
  }

  // 언제 userGames가 캐시에 저장되는 지 체크해두자.
  // cachedUserGames 에 캐시에 있던 유저게임리스트 불러와서 저장
  Future<void> _loadCachedUserGames() async {
    if (_nextLottoResult != null) {
      final userGames =
          await loadUserGames(ref, _nextLottoResult!.roundNumber + 1);
      print('드로우페이제에서의 roundNo+1 = ${_nextLottoResult!.roundNumber + 1}');
      setState(() {
        loadedUserGames = userGames;
      });
    }
  }

  // 유저게임리스트로 캐시에 저장하는 함수. 파베에 저장하는건 number selector에서 진행
  // 이게 좋은게... userGames는 좀 많아서 굳이 isar에 둘것 도 없고... 나중에 특정회차 userGames 보고싶다면 파베
  // 그레아니고 쭉 쓸거는 그냥 캐시에 리스트로 저장해두고 쓰면 되는게 이득!
  Future<void> _saveGamesToCache(List<UserGame> games) async {
    final cacheManager = DefaultCacheManager();
    final user = ref.read(userModelNotifierProvider);
    if (user != null && _nextLottoResult != null) {
      final cacheKey =
          'user_game_${user.uid}_${_nextLottoResult!.roundNumber + 1}';
      try {
        final jsonString =
            jsonEncode(games.map((game) => game.toJson()).toList());
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

    int maxGames = userModel!.maxGames;
    print('유저모델의 맥스게임은? : $maxGames');
    bool isMaxGamesReached = loadedUserGames.length >= maxGames;

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Text('추첨하기', style: appBarTitleTextStyleWithStroke),
                Text('추첨하기', style: appBarTitleTextStyle),
              ],
            ),
          ],
        ),
        actions: [
          Image.asset('assets/images/draw_camera.png', width: 32),
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
      body: _isLoading
          ? const Text('') // 로딩 인디케이터 표시
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!)) // 에러 메시지 표시
              : Column(
                  children: [
                    if (_nextLottoResult != null)
                      Padding(
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '추첨일 : ${_nextLottoResult!.nextWeekDrawDate}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: loadedUserGames.isNotEmpty
                          ? ListView.builder(
                              itemCount: loadedUserGames.length,
                              itemBuilder: (context, index) {
                                final game = loadedUserGames[index];
                                final sortedNumbers =
                                    game.selectedDrwNos.toList()..sort();
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: sortedNumbers.map((number) {
                                        return CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.grey,
                                          child: Text(
                                            number.toString(),
                                            style: ballTextStyleDrawPage,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const NoLottoNoti(),
                    ),
                  ],
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: isMaxGamesReached
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          '회차별 5게임 초과 도전은 업그레이드를 통해 가능하며, 업그레이드 시 알찬 혜택이 주렁주렁 딸려옵니다'),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: '확인',
                        onPressed: () {
                          // 액션 버튼을 눌렀을 때의 동작
                        },
                      ),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              : () async {
                  if (_nextLottoResult != null && user != null) {
                    final UserGame? newGame = await showDialog<UserGame>(
                      context: context,
                      builder: (BuildContext context) {
                        // **** 라운드넘버에서 1빼고 저장하면 이전꺼 생긴다 디버그 ****
                        return NumberSelectionScreen(
                          playerUid: user.uid,
                          roundNo: _nextLottoResult!.roundNumber + 1,
                        );
                      },
                    );

                    if (newGame != null) {
                      setState(() {
                        // 캐시에 있던 게임리스트 불러와서 추가
                        loadedUserGames.add(newGame);
                      });
                      // 그리고 다시 캐시에 추가
                      await _saveGamesToCache(loadedUserGames);
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
