import 'package:flutter/material.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';

import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';

class UserGuide extends StatefulWidget {
  const UserGuide({super.key});

  @override
  State<UserGuide> createState() => _UserGuideState();
}

class _UserGuideState extends State<UserGuide> {
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
                  '로또왕 이용설명서',
                  style: appBarTitleTextStyleWithStroke,
                ),
                Text(
                  '로또왕 이용설명서',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MySizedBox(height: 16),
            const Text(
              '게임의 목적',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:8),
            const Text(
              '''로또킹은 건전한 로또게임 문화정착에 앞장서며,실제 로또구매게임의 이력관리 및 나의 데이터분석 또는 가상 로또생활(주10만원 Max)을 할 수 있게 지원하는 서비스입니다.\n운 지지리도 없는 다른 유저들과 함께 언젠가는 찾아올 1등의 기회를 호시탐탐 노려보세요.\n서비스가 잘되면 인게임 상품도 준비할 계획이오니 많은 성원 부탁드립니다.''',
              style: TextStyle(fontSize: 14),
            ),
            const MySizedBox(height: 20),
            const Text(
              '로또킹의 특징',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const MySizedBox(height: 8),
            const Text(
              '''로또에서 유일한 당첨확률을 높이는 것은 더 많은 게임을 하는 것 뿐입니다.\n수학적/통계적 관점에서는 AI를 통한 빈도높은/적은 번호등의 선택 등은 과학적으로는 당첨확률에 영향이 없습니다.\n하지만 로또킹은 과학을 뛰어넘어, 나와 궁합이 잘맞는 번호, 토정비결에 따른 추천번호 등 초과학적 영역을 조합, 게임을 즐길 수 있도록 설계 및 개발중입니다.''',
              style: TextStyle(fontSize: 14),
            ),
            const MySizedBox(height: 20),
            const Text(
              '유저등급 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:8),
            Image.asset('assets/images/userguide_levelsystem.png'),
            const MySizedBox(height: 20),
            const Text(
              '승급 시스템',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const MySizedBox(height: 8),
            const Text(
              '''일정 경험치를 쌓으면 자동으로 등급이 올라갑니다.\n등급이 올라가면 특별한 기능을 이용할 수 있고, 더 많은 게임을 할 수 있게 되어 더욱 빠른 승급이 가능해집니다.\n랭커가 되어 자신의 부를 과시 해 보세요.\n자신의 운을 믿고 천천히 기다리거나, 또는 돈으로 빠른 승급을 통해 더 높은 당첨확률에 도전해보세요.''',
              style: TextStyle(fontSize: 14),
            ),
            const MySizedBox(height: 20),
            const Text(
              '획득경험치 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:8),
            Image.asset('assets/images/userguide_expsystem.png'),
            const MySizedBox(height: 20),
            const Text(
              '로또용지 OCR',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const MySizedBox(height: 8),
            const Text(
              '''로또용지 OCR 기능은 당초 구매한 로또용지를 등록하는 수고를 덜어드리기 위해 기획/개발 되었으나, 개발 역량의 한계로 인해 다소 아쉬운 성능을 보이고 있습니다.\n하지만 점차 좋아질 것이오니 믿고 기다려주세요.\n로또용지의 [A 자 동] 이 부분과 연속된 6개의 두자리 숫자를 인식하기 때문에 그 부분을 수평을 잘 맞춰 선명하게 촬영하세요.''',
              style: TextStyle(fontSize: 14),
            ),
            const MySizedBox(height: 20),
            const Text(
              '서비스 개발 후원',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const MySizedBox(height: 8),
            const Text(
              '''여러분의 개발 후원금은 서비스 고도화에 큰 힘이 되며, 이러한 작은 선행 하나하나가 카르마로 여러분의 당첨확률을 높이고 이 외에도 여러분의 어진 마음씨가 반드시 인생에 더 큰 행운으로 작용할 것이라고 생각합니다.\n미리 감사합니다.''',
              style: TextStyle(fontSize: 14),
            ),
            const MySizedBox(height: 32),


            MyBtnContainer(
              color: specialBlue,
              child: const Center(
                child: Text('개발 후원', style: btnTextStyle),
              ),
            )
          ],
        ),
      ),
    );
  }
}