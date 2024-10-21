import 'package:flutter/material.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';

import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

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
                  '서비스 이용약관',
                  style: appBarTitleTextStyleWithStroke,
                ),
                Text(
                  '서비스 이용약관',
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MySizedBox(height: 16),
            Text(
              '로또킹 서비스 이용약관',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '''
제1조 (목적)
본 약관은 [Rolladay Inc.](이하 "회사"라 함)이 제공하는 로또 앱 서비스(이하 "서비스"라 함)의 이용 조건 및 절차, 회사와 이용자의 권리, 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
1. "이용자"라 함은 본 약관에 따라 회사가 제공하는 서비스를 이용하는 자를 말합니다.
2. "로또"라 함은 동행복권에서 시행하는 복권 게임을 말합니다.

제3조 (약관의 효력 및 변경)
1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에 대하여 그 효력을 발생합니다.
2. 회사는 합리적인 사유가 있는 경우 관련 법령에 위배되지 않는 범위 내에서 본 약관을 변경할 수 있습니다. 회사가 약관을 변경하는 경우에는 적용일자 및 변경사유를 명시하여 그 적용일자 7일 전부터 서비스 내에 공지합니다.

제4조 (서비스의 제공 및 변경)
1. 회사는 다음과 같은 서비스를 제공합니다:
   a) 로또 번호 생성 서비스
   b) 로또 당첨 번호 정보 제공
   c) 기타 회사가 정하는 서비스
2. 회사는 운영상, 기술상의 필요에 따라 제공하고 있는 서비스를 변경할 수 있습니다.

제5조 (서비스 이용 제한)
회사는 다음 각 호에 해당하는 경우 서비스의 전부 또는 일부의 이용을 제한할 수 있습니다:
1. 기술상의 필요에 의해 서비스 점검이 필요한 경우
2. 시스템 고장 등 불가항력적 사유가 발생한 경우
3. 기타 회사가 서비스를 제공할 수 없는 사유가 발생한 경우

제6조 (회사의 책임제한)
1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임을 지지 않습니다.
2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.
3. 회사는 이용자가 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며, 그 밖에 서비스를 통하여 얻은 자료로 인한 손해에 관하여 책임을 지지 않습니다.
4. 회사는 이용자 간 또는 이용자와 제3자 상호간에 서비스를 매개로 하여 거래 등을 한 경우에는 책임을 지지 않습니다.
5. 회사는 무료로 제공되는 서비스 이용과 관련하여 관련법에 특별한 규정이 없는 한 책임을 지지 않습니다.

제7조 (이용자의 의무)
1. 이용자는 관계법령, 본 약관의 규정, 이용안내 및 서비스와 관련하여 공지한 주의사항, 회사가 통지하는 사항 등을 준수하여야 하며, 기타 회사의 업무에 방해되는 행위를 하여서는 안 됩니다.
2. 이용자는 서비스를 이용하여 얻은 정보를 회사의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.

제8조 (저작권의 귀속 및 이용제한)
1. 회사가 작성한 저작물에 대한 저작권 기타 지적재산권은 회사에 귀속합니다.
2. 이용자는 서비스를 이용함으로써 얻은 정보를 회사의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.

제9조 (분쟁해결)
1. 회사와 이용자 간에 제기된 소송은 대한민국 법을 준거법으로 합니다.
2. 서비스 이용으로 발생한 분쟁에 대해 소송이 제기될 경우 회사의 본점 소재지를 관할하는 법원을 관할 법원으로 합니다.

제10조 (기타)
본 약관에 명시되지 않은 사항은 관계법령 및 회사가 정한 서비스의 세부이용지침 등의 규정에 따릅니다.

부칙
본 약관은 [2024.11.09]부터 시행합니다.


서비스 이용관련 문의 : rolladay.cs@gmail.com

              ''',
              style: TextStyle(fontSize: 14),
            ),
            MyBtnContainer(
              color: Colors.black87,
              child: Center(
                child: Text('회원탈퇴', style: btnTextStyle),
              ),
            )
          ],
        ),
      ),
    );
  }
}
