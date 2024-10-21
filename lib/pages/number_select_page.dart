import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/components/ai_draw_bottom_sheet.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/signiture_font.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/user_service/user_provider.dart';
import '../models/user_game_model/user_game.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

// 중요한 부분 유저가 번호를 어찌어찌 선택해서 저장버튼을 누르면, FB에 저장되고, 캐시에 저장된후
// userGame 객체를 이전화면인 DrawPage로 보내는 화면이다.
class NumberSelectionScreen extends ConsumerStatefulWidget {
  final int roundNo;
  final String playerUid;

  

  const NumberSelectionScreen(
      {super.key, required this.roundNo, required this.playerUid});

  @override
  NumberSelectionScreenState createState() => NumberSelectionScreenState();
}

class NumberSelectionScreenState extends ConsumerState<NumberSelectionScreen> {
  List<int> selectedNos = [];
  bool isSaveButtonEnabled = false;
  bool isGenerating = false;
  final List<int> allNumbers = List.generate(45, (index) => index + 1);
  late List<int> remainingNumbers;
  Timer? autoSelectTimer;

  
  // 1017 여기서부터 도전 - 미출현번호 캐시
  // 한번 봐바라
  List<int> unseenNumbers = [];
  final String cacheKey = 'unseen_numbers';


  @override
  void initState() {
    super.initState();
    _loadUnseenNumbers();
  }


  Future<void> _loadUnseenNumbers() async {
    try {
      final file = await DefaultCacheManager().getFileFromCache(cacheKey);

      if (file != null) {
        final data = await file.file.readAsString();
        final cachedData = json.decode(data);
        final expiryDate = DateTime.parse(cachedData['expiry']);

        if (DateTime.now().isBefore(expiryDate)) {
          setState(() {
            unseenNumbers = List<int>.from(cachedData['numbers']);
          });
          return;
        }
      }
      // 캐시가 없거나 만료되었으면 새로 fetch
      unseenNumbers = await fetchUnseenNumbers();
      cacheUnseenNumbers(unseenNumbers);
      setState(() {});
    } catch (e) {
      print('Error loading unseen numbers: $e');
    }
  }

  Future<void> cacheUnseenNumbers(List<int> numbers) async {
    final now = DateTime.now();
    final nextSaturday = now.add(Duration(days: (6 - now.weekday + 7) % 7));
    final expiryDate = DateTime(nextSaturday.year, nextSaturday.month, nextSaturday.day, 20, 45);

    final data = {
      'numbers': numbers,
      'expiry': expiryDate.toIso8601String(),
    };

    final cacheData = utf8.encode(json.encode(data));
    await DefaultCacheManager().putFile(
      cacheKey,
      cacheData,
      maxAge: expiryDate.difference(now),
      fileExtension: 'json',
    );
  }

  Future<List<int>> fetchUnseenNumbers() async {
    final response = await http.get(Uri.parse('https://m.dhlottery.co.kr/gameResult.do?method=noViewNumber'));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var spans = document.getElementsByClassName('ball_645 sml');

      List<int> unseenNumbers = spans
          .map((span) => int.tryParse(span.text))
          .where((number) => number != null)
          .cast<int>()
          .toList();

      return unseenNumbers;
    } else {
      throw Exception('Failed to load unseen numbers');
    }
  }
// 여기까지 도전 1017 미출현넘버 작업




  // 번호선택 함수
  void toggleNumberSelection(int number) {
    setState(() {
      if (selectedNos.contains(number)) {
        selectedNos.remove(number);
      } else if (selectedNos.length < 6) {
        selectedNos.add(number);
      }
      isSaveButtonEnabled = selectedNos.length == 6;
    });
  }

  // 자동생성 함수
  void generateRandomNumbers() {
    if (selectedNos.length >= 6 || isGenerating) return;

    setState(() {
      isGenerating = true;
    });

    final numbersToSelect = 6 - selectedNos.length;
    remainingNumbers = allNumbers.where((selectedNum) => !selectedNos.contains(selectedNum)).toList();

    if (remainingNumbers.length < numbersToSelect) {
      setState(() {
        isGenerating = false;
      });
      return;
    }

    autoSelectTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (selectedNos.length >= 6) {
        timer.cancel();
        setState(() {
          isGenerating = false;
        });
        return;
      }

      if (remainingNumbers.isNotEmpty) {
        final random = Random();
        final number = remainingNumbers.removeAt(random.nextInt(remainingNumbers.length));
        setState(() {
          selectedNos.add(number);
          isSaveButtonEnabled = selectedNos.length == 6;
        });
      }
    });
  }



  // 내가 선택한 6개의 번호를 파베 및 캐시에 저장 후 pop 하면서 이전 화면으로 전달하는 함수
  Future<void> saveSelectedNumberToFB() async {
    if (isSaveButtonEnabled) {
      final userGameCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.playerUid)
          .collection('userGames');

      QuerySnapshot existingGames = await userGameCollection
          .where('roundNo', isEqualTo: widget.roundNo)
          .get();

      final gameCount = existingGames.size + 1;
      // 현재 타임스탬프 생성
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // gameId에 타임스탬프 추가
      final gameId = '${widget.playerUid}_${widget.roundNo}_${gameCount.toString().padLeft(3, '0')}_$timestamp';

      UserGame userGame = UserGame(
        gameId: gameId,
        roundNo: widget.roundNo,
        selectedDrwNos: selectedNos,
        playerUid: widget.playerUid,
      );

      await ref.read(userModelNotifierProvider.notifier).addGameToUser(userGame, widget.playerUid);

      if (mounted) {
        Navigator.pop(context, userGame);
      }
    }
  }

  @override
  void dispose() {
    autoSelectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset('assets/images/common_back.png', width: 32),
            onPressed: () {
              Navigator.pop(context);
            }),
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
                  '번호뽑기',
                  style: appBarTitleTextStyleWithStroke,
                ),
                Text(
                  '번호뽑기',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: backGroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.0),
                  ),
                ),
                context: context,
                builder: (context) => const AIDrawBottomSheet(),
              );
            },
            child: Image.asset(
              'assets/images/draw_flash.png',
              width: 32,
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 선택된 숫자 표시 영역
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.5, color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: selectedNos.map((number) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black, width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryYellow,
                        child: SignutureFont(
                          title: number.toString(),
                          textStyle: ballTextStyle,
                          strokeTextStyle: ballTextStyleWithStroke,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: 45,
                    itemBuilder: (context, index) {
                      int number = index + 1;
                      bool isSelected = selectedNos.contains(number);
                      bool isUnseen = unseenNumbers.contains(number);
                      return GestureDetector(
                        onTap: isGenerating ? null : () => toggleNumberSelection(number),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                          child: CircleAvatar(
                            backgroundColor: isSelected ? specialBlue : isUnseen
                            ? const Color.fromARGB(255, 200, 200, 217) // 미출현 번호의 색상
                            : Colors.grey,
                            child: Text(
                              '$number',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 8),
            // Text('[5주간 미출현 번호]', style: TextStyle(color: specialBlue, fontWeight: FontWeight.w600, fontSize: 12),),
            // Center(child: Text('${unseenNumbers.join("  ")}', style: TextStyle(color: Colors.black54),)),
            const SizedBox(height: 16),

            // 나머지는 랜덤! 버튼
            GestureDetector(
              onTap: isGenerating || selectedNos.length >= 6 ? null : generateRandomNumbers,
              child: MyBtnContainer(
                color: isGenerating || selectedNos.length >= 6 ? Colors.grey : Colors.blue,
                child: const Center(
                    child: Text(
                      '나머지는 랜덤!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ),
            const SizedBox(height: 16),

            // 저장 버튼
            GestureDetector(
              onTap: isSaveButtonEnabled ? saveSelectedNumberToFB : null,
              child: MyBtnContainer(
                color: isSaveButtonEnabled ? specialBlue : Colors.black26,
                child: const Center(
                    child: Text(
                      '저장하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}