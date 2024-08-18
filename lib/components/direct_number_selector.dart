import 'package:flutter/material.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/signiture_font.dart';

import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../models/user_game_model/user_game.dart';
// UserGame 모델을 사용하는 경로로 변경

class NumberSelectionScreen extends StatefulWidget {
  final int roundNo;
  final String playerUid;

  const NumberSelectionScreen(
      {super.key, required this.roundNo, required this.playerUid});

  @override
  _NumberSelectionScreenState createState() => _NumberSelectionScreenState();
}

class _NumberSelectionScreenState extends State<NumberSelectionScreen> {
  Set<int> selectedNos = {};
  bool isSaveButtonEnabled = false;

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

  void saveSelection() {
    if (isSaveButtonEnabled) {
      UserGame userGame = UserGame(
        roundNo: widget.roundNo,
        selectedDrwNos: selectedNos,
        playerUid: widget.playerUid,
      );

      // 저장 작업 (필요한 동작으로 교체)
      Navigator.pop(context, userGame);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset('assets/images/common_back.png', width: 32),
            // 사용자 지정 이미지
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 동작
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
                // Stroke Text
                Text(
                  '번호뽑기',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
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
            color: Colors.black, // 라인 색상
            height: 1.0, // 라인 두께
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
                    // 각 숫자 사이의 간격
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black, width: 1.5), // 테두리 색상과 두께
                      ),
                      child: CircleAvatar(
                        radius: 18, // 원의 크기
                        backgroundColor: primaryYellow,

                        // 원의 배경색
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
            // Wrap(
            //   spacing: 8.0,
            //   children: selectedNos.map((num) => Chip(label: Text('$num'))).toList(),
            // ),
            const SizedBox(height: 16),
            // 숫자 선택 버튼들
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, // 한 줄에 5개씩 배치
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0, // 정사각형 모양으로 만듦
                    ),
                    itemCount: 45,
                    itemBuilder: (context, index) {
                      int number = index + 1;
                      bool isSelected = selectedNos.contains(number);
                      return GestureDetector(
                        onTap: () => toggleNumberSelection(number),
                        child: CircleAvatar(
                          backgroundColor:
                              isSelected ? specialBlue : Colors.grey,
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
            // ElevatedButton(
            //   onPressed: isSaveButtonEnabled ? saveSelection : null,
            //   child: const Text('저장'),
            // ),
          ],
        ),
      ),
    );
  }
}
