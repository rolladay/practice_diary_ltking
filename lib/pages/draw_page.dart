import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';

import '../components/direct_number_selector.dart';
import '../components/my_btn_container.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/admob/ad_service.dart';
import '../features/web_crawl/crawl_lotto_result.dart';
import '../features/web_crawl/get_cashed_date.dart';
import '../models/lotto_result_model/lotto_result.dart';

class DrawPage extends ConsumerStatefulWidget {
  const DrawPage({super.key});

  @override
  ConsumerState<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends ConsumerState<DrawPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                // Stroke Text
                Text(
                  '추첨하기',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<LottoResult?>(
                future: getCachedLottoResult(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('에러 발생: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final lottoResult = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
        
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('회차: ${lottoResult.drawNumber+1}'),
                            Text('추첨일: ${lottoResult.drawDate}'),
                            // Text('당첨번호: ${lottoResult.winningNumbers.join(', ')}'),
                            // Text('보너스 번호: ${lottoResult.bonusNumber}'),
                            // Text('1등 당첨금: ${lottoResult.prizeAmounts}'),
                            MySizedBox(height: 16),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
                            MySizedBox(height: 8),
                            MyBtnContainer(color: Colors.white24),
        
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('캐시된 데이터가 없습니다.'));
                  }
                }),
            Text('1'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DirectNumberSelector();
                    },
                  );
                },
                child: const MyBtnContainer(
                  color: Colors.deepPurpleAccent,
                  child: Text('뽑기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
