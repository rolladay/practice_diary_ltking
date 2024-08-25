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
import '../features/lotto_service/crawl_lotto_result.dart';

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
    // fetchLottoResult()를 initState에서 호출하여 LottoRsult Future를 저장
    // nextDrawDate 지났으면 http요청
    _futureLottoResult = getCachedOrFetchLottoResult();
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

      // Starting point of Body!!!
      body: Column(
        children: [
          const MySizedBox(
            height: 8,
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
          const MySizedBox(height: 8),
          // 여기가 웹크롤링...
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: FutureBuilder<LottoResult>(
                      future: _futureLottoResult, // 저장된 Future 사용
                      builder: (context, snapshot) {
                        print('퓨쳐빌더 수행시작 : Cached or Fetch LottoResult!');
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Future 로딩중일 때 들어갈 위젯
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          print('퓨처완료 후 실행 영역');

                          //아래 있는 LottoResult는 Future<LottoResult>인데 Isar 아니면 Fetch해온놈
                          final lottoResult = snapshot.data!;
                          print('스냅샷은 : $snapshot');
                          print('snapshot.datad는 : $lottoResult');
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //당첨결과 카드
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: MyContainer(
                                    upperChild: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${lottoResult.roundNumber}회',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            lottoResult.formattedYMDDrawDate,
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                            // Row의 자식으로 LottoResult의 WinningNumbers 리스트를 순회하는 map
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
                                                        width:
                                                            1.5), // 테두리 색상과 두께
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
                                              lottoResult.bonusNumber
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        const MySizedBox(height: 8),
                                        const Text(
                                          '1등 당첨금',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        SignutureFont2(
                                            title:
                                                '${lottoResult.prizeAmounts}원',
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                '당첨자수',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '당첨판매점 보기',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: specialBlue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    bottomHeight: 200),
                              ),
                              const MySizedBox(height: 16),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // 여기 if문으로 유저의 해당회차 결과가 있으면 보여주는 코드 삽입
                                  child: Center(
                                    //***************여기 컬럼 child에 if문으로 들어가야함 나중에 ***********
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // 세로 축 중앙 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // 가로 축 중앙 정렬
                                      children: [
                                        Image.asset(
                                          'assets/images/lotto_missing.png',
                                          width: 32,
                                        ),
                                        const MySizedBox(height: 8),
                                        const Text('이 라운드에 도전하지 않았습니다.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              //여기가 내 결과 밑에 뭔가들어갈게 있다면 들어가고 AD외 전체 스크롤됨
                              // Text('1', style: TextStyle(fontSize: 40),),

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
                          return const Text(
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
          ),
          // 여기가 웹크롤링...
          // Text('1'),
        ], //여기가 body전체 마지막
      ),
    );
  }
}
