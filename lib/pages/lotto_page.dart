import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingoflotto/components/my_container.dart';
import 'package:kingoflotto/constants/color_constants.dart';
import 'package:kingoflotto/features/admob/ad_service.dart';
import 'package:kingoflotto/models/lotto_result_model/lotto_result.dart';

import '../components/my_sizedbox.dart';
import '../components/signiture_font.dart';
import '../components/signiture_font2.dart';
import '../constants/fonts_constants.dart';
import '../features/web_crawl/crawl_lotto_result.dart';

class LottoPage extends ConsumerStatefulWidget {
  const LottoPage({super.key});

  @override
  ConsumerState<LottoPage> createState() => _LottoPageState();
}

class _LottoPageState extends ConsumerState<LottoPage> {
  final AdManager _adManager = AdManager();
  late Future<LottoResult> _futureLottoResult;

  @override
  void initState() {
    super.initState();

    _adManager.initializeBannerAd(
      () {
        setState(() {});
      },
      (ad, error) {
        print('BannerAd failed to load: $error');
      },
    );
    print('44444444444444444');
    // fetchLottoResult()를 initState에서 호출하여 Future를 저장
    _futureLottoResult = getCachedOrFetchLottoResult();
    print('555555555555555555');
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // Stroke Text
                Text(
                  '당첨확인',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
                Text(
                  '당첨확인',
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
      body: Column(
        children: [
          const MySizedBox(
            height: 16,
          ),
          (_adManager.isBannerAdReady)
              ? SizedBox(
                  height: _adManager.bannerAd.size.height.toDouble(),
                  width: _adManager.bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _adManager.bannerAd),
                )
              : Container(
                  width: 320,
                  height: 50,
                  color: backGroundColor,
                  child: Center(
                    child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: primaryOrange,
                          strokeWidth: 2,
                        )),
                  ),
                ),
          const MySizedBox(height: 16),
          // 여기가 웹크롤링...
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: FutureBuilder<LottoResult>(
                    future: _futureLottoResult, // 저장된 Future 사용
                    builder: (context, snapshot) {
                      print('aaaaaaaaaaaaaaaaaaaaaaa');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print('bbbbbbbbbbbbbbbbbbbbbbbbbb');
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: MyContainer(
                            upperChild: const Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Loading..'),
                                Spacer(),
                              ],
                            ),
                            bottomChild: Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryYellow,
                            )),
                            bottomHeight: 200,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        print('ffffffffffffffffffff');
                        final lottoResult = snapshot.data!;
                        print(snapshot);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: MyContainer(
                                  upperChild: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${lottoResult.drawNumber}회',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          lottoResult.drawDate.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  bottomChild: Column(
                                    children: [
                                      const MySizedBox(height: 8),
                                      // 동그라미 6개 영역
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: lottoResult.winningNumbers
                                              .map((number) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              // 각 숫자 사이의 간격
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.5), // 테두리 색상과 두께
                                                ),
                                                child: CircleAvatar(
                                                  radius: 18, // 원의 크기
                                                  backgroundColor:
                                                      primaryYellow,

                                                  // 원의 배경색
                                                  child: SignutureFont(
                                                    title: number.toString(),
                                                    textStyle: ballTextStyle,
                                                    strokeTextStyle:
                                                        ballTextStyleWithStroke,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const MySizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Bonus Number : ',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            lottoResult.bonusNumber.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const MySizedBox(height: 8),
                                      const Text(
                                        '1등 당첨금',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      SignutureFont2(
                                          title: '${lottoResult.prizeAmounts}원',
                                          textStyle: bigTextStyle,
                                          strokeTextStyle:
                                              bigTextStyleWithStroke),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Text('당첨자수', style: TextStyle(fontSize: 12),),
                                            Spacer(),
                                            Text('당첨판매점 보기', style: TextStyle(fontWeight: FontWeight.bold, color: specialBlue),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  bottomHeight: 200),
                            ),
                            const MySizedBox(height: 16),
                            // 나의 성적보기



                            // 웹크롤링 해서 가져온 데이터 > 주석처리 참조용
                            // Text('Draw Number: ${lottoResult.drawNumber}'),
                            // Text(
                            //     'Winning Numbers: ${lottoResult.winningNumbers.join(', ')}'),
                            // Text('Bonus Number: ${lottoResult.bonusNumber}'),
                            // Text('Prize Amounts: ${lottoResult.prizeAmounts}'),
                            // Text('drawDate: ${lottoResult.drawDate}'),
                          ],
                        );
                      } else {
                        return Text(
                          'No data available',
                          style: TextStyle(color: Colors.black12),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // 여기가 웹크롤링...
        ],
      ),
    );
  }
}
