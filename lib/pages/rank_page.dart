import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(

        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(height: 8,),
            Stack(
              children: [
                // Stroke Text
                Text(
                  '랭크',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
                Text(
                  '랭크',
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
      body: const Column(
        children: [
          Center(
            child: Text('컬럼'),
          ),
          Text('1'),
        ],
      ),
    );
  }
}
