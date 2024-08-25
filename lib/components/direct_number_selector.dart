import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/signiture_font.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/user_service/user_provider.dart';
import '../models/user_game_model/user_game.dart';

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

  Future<void> saveSelection() async {
    if (isSaveButtonEnabled) {
      // 현재 사용자의 해당 roundNo에 저장된 게임 개수를 가져옴
      final userGameCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.playerUid)
          .collection('userGames');

      QuerySnapshot existingGames = await userGameCollection
          .where('roundNo', isEqualTo: widget.roundNo)
          .get();

      // 게임 개수를 기준으로 gameId 생성 (001, 002, 003 ...)
      final gameCount = existingGames.size + 1;
      final gameId = '${widget.playerUid}_${widget.roundNo}_${gameCount.toString().padLeft(3, '0')}';

      // 새로운 UserGame 객체 생성
      UserGame userGame = UserGame(
        gameId: gameId,  // 고유한 gameId
        roundNo: widget.roundNo,
        selectedDrwNos: selectedNos,
        playerUid: widget.playerUid,
      );

      // Firestore에 저장
      await ref.read(userModelNotifierProvider.notifier).addGameToUser(userGame, widget.playerUid);



      // 간단한 캐시 저장 - ############## 이 부분이 신규 ################ 잘못되면 이거부터 지워라!!!
      final cacheManager = DefaultCacheManager();
      final cacheKey = 'user_game_${widget.playerUid}_${widget.roundNo}';
      final jsonData = jsonEncode(userGame.toJson()); // UserGame 객체를 JSON으로 변환
      final bytes = Uint8List.fromList(jsonData.codeUnits); // List<int>를 Uint8List로 변환
      await cacheManager.putFile(cacheKey, bytes);

      // 선택된 번호 반환 및 화면 닫기
      if (mounted) {
        Navigator.pop(context, userGame);
      }
    }
  }

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

    autoSelectTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
          Image.asset(
            'assets/images/lotto_more.png',
            width: 32,
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
                      return GestureDetector(
                        onTap: isGenerating ? null : () => toggleNumberSelection(number),
                        child: CircleAvatar(
                          backgroundColor: isSelected ? specialBlue : Colors.grey,
                          child: Text(
                            '$number',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
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
              onTap: isSaveButtonEnabled ? saveSelection : null,
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