import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/components/my_container.dart';
import 'package:kingoflotto/constants/color_constants.dart';
import 'package:kingoflotto/models/lotto_result_model/lotto_result.dart';
import 'package:kingoflotto/models/user_game_model/user_game.dart';
import '../components/ad_banner_widget.dart';
import '../components/game_result_analysis.dart';
import '../components/my_sizedbox.dart';
import '../components/signiture_font.dart';
import '../components/signiture_font2.dart';
import '../components/signiture_font3.dart';
import '../constants/fonts_constants.dart';
import '../features/lotto_service/lotto_result_manager.dart';
import '../features/lotto_service/usergame_manager.dart';

class LottoPage extends ConsumerStatefulWidget {
  const LottoPage({super.key});

  @override
  ConsumerState<LottoPage> createState() => _LottoPageState();
}

class _LottoPageState extends ConsumerState<LottoPage> {
  // 로또리절트 퓨쳐를 반환 및 저장 - isarDB에 저장되는 객체 (차례차례 저장됨)
  late Future<LottoResult> _futureLottoResult;
  late Future<List<UserGame>> _futureUserGames;

  // 처음 화면 그릴때 광고로드하고, 퓨처<로또리절트> 를 _futureLottoResult 변수에 저장해둠
  @override
  void initState() {
    super.initState();
    // 패치해서 로또리절트 보여주든, isar 라스트리절트 보여주든 캐시저장된 로또리절트 보여주든 LottoResult객체 반환
    _futureLottoResult = getCachedOrFetchLottoResult();
  }

  // userGames 와 LottoResult 객체를 받아서 각 UserGame 객체가 ResultRank가 널인경우
  // checkLottoRank메소드 실행해서 rank 변수에 저장, winningNos 에 당첨번호 저장, matchingCount에 맞은갯수저장
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Text('당첨확인', style: appBarTitleTextStyleWithStroke),
                Text('당첨확인', style: appBarTitleTextStyle),
              ],
            ),
          ],
        ),
        actions: [
          Image.asset('assets/images/lotto_more.png', width: 32),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),

      // #####################  바디부분  #######################
      body: Column(
        children: [
          // AD 배너 부분
          const MySizedBox(height: 8),
          const AdBannerWidget(),
          const MySizedBox(height: 8),

          // 애드배너 밑에는 다 singleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: FutureBuilder<LottoResult>(
                      // 지난 로또 결과가 이 변수에 저장되어있다.
                      future: _futureLottoResult,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            // 마이컨테이너 height36 커스텀/컬럼 위젯 child로 위젯 두개 갖고있다.
                            child: MyContainer(
                              upperChild: const Row(
                                children: [
                                  SizedBox(width: 8),
                                  Text('Loading..'),
                                  Spacer(),
                                ],
                              ),
                              bottomChild: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryYellow,
                                ),
                              ),
                              bottomHeight: 200,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));

                          // 여기가 이제 FutureLottoResult 에 데이터 들어오면 실행되는 부분
                        } else if (snapshot.hasData) {
                          final lottoResult = snapshot.data!;

                          // 캐시드 로또데이터가 있으면 이게 나온다. 즉, 로또결과를 한번이라도 페치해왔으면 이 아래가 나온다.
                          // 이 아래는 컬럼인데, 위 아래 컨테이너 다 나온다. 이건 갠찬음. 위에는 항상 캐시된 로또 리절트 나와야하고
                          // 위에가 나오는 동시에 아래가 나오는 구조임 이건 크게 문제없어보인다.

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 위 컨테이너 - 로또리절트를 담고 있는 넘 부분
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: MyContainer(
                                  upperChild: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Text('${lottoResult.roundNumber}회',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text(lottoResult.formattedYMDDrawDate,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  bottomChild: Column(
                                    children: [
                                      const MySizedBox(height: 8),
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
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.5),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      primaryYellow,
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
                                          const Text('Bonus Number : ',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12)),
                                          Text(
                                              lottoResult.bonusNumber
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                      const MySizedBox(height: 8),
                                      const Text('1등 당첨금',
                                          style:
                                              TextStyle(color: Colors.black54)),
                                      SignutureFont2(
                                        title: '${lottoResult.prizeAmounts}원',
                                        textStyle: bigTextStyle,
                                        strokeTextStyle: bigTextStyleWithStroke,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.black45),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            // 여기에 나중에 당첨자수 보여주거나 하기
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: '로또왕 ',
                                                    style: TextStyle(
                                                        fontSize:
                                                            12), // 기본 스타일 설정
                                                  ),
                                                  TextSpan(
                                                    text: lottoResult.winners,
                                                    // 동적으로 바뀌는 부분
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: ' 명',
                                                    style: TextStyle(
                                                        fontSize:
                                                            12), // 기본 스타일 설정
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            // 여기에 제스쳐디텍터 달아서 나중에 링크보내기
                                            Text('당첨판매점 보기',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: specialBlue)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  bottomHeight: 200,
                                ),
                              ),
                              const MySizedBox(height: 16),
                              // 아래 컨테이너에 대한 이야기고, 퓨쳐빌더를 통해 아래 UI가 그려지는 부분
                              // 이 아래 부터가 유저의 게임결과와 당첨결과를 비교해 결과를 주는 UI이다.

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: FutureBuilder<List<UserGame>>(
                                  // 해당 라운드의 유저게임즈(캐시에 저장되어있는) '유저게임 리스트'를 불러온다.
                                  future: loadUserGames(
                                      ref, lottoResult.roundNumber),
                                  // 사용자 게임 데이터 로드
                                  builder: (context, userGameSnapshot) {
                                    if (userGameSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(child: Text(''));
                                    } else if (userGameSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${userGameSnapshot.error}'));
                                    } else if (userGameSnapshot.hasData) {
                                      // 해당 라운드에 해당하는 유저게임 리스트를 불러와서 userGames 에 저장
                                      // 이때 캐시에도 , 파베에도 해당라운드 게임리스트가 없으면 빈리스트 저장(뽑기안한경우)
                                      final userGames = userGameSnapshot.data!;

                                      if (userGames.isEmpty) {
                                        return Container(
                                          width: double.infinity,
                                          height: 240,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/images/lotto_missing.png',
                                                    width: 32),
                                                const MySizedBox(height: 8),
                                                const Text(
                                                    '이 라운드에 도전하지 않았습니다.'),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        // 만약 유저게임즈 리스트가 데이터가 있는 경우엔~ 또 퓨쳐빌더 들어가주고...
                                        // 이건 기존 userGames에 lottoResult를 적용, 업데이트 하는 것
                                        return FutureBuilder<void>(
                                          future: updateUserGames(
                                              userGames, lottoResult),

                                          // 업데이트 비동기 처리
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child: Text(''));
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else {
                                              // 업데이트 완료 후, 높은 순위의 게임 찾기
                                              List<UserGame> rankUpdatedGames =
                                                  userGames
                                                      .where((game) =>
                                                          game.resultRank !=
                                                          null)
                                                      .toList();

                                              UserGame highestRankGame =
                                                  rankUpdatedGames.reduce(
                                                (a, b) {
                                                  // a와 b의 resultRank 값을 비교, 0인 경우 6으로 변환하고 double로 캐스팅
                                                  double aRank = (a
                                                                  .resultRank ==
                                                              0
                                                          ? 6.0
                                                          : a.resultRank
                                                              ?.toDouble()) ??
                                                      double.infinity;
                                                  double bRank = (b
                                                                  .resultRank ==
                                                              0
                                                          ? 6.0
                                                          : b.resultRank
                                                              ?.toDouble()) ??
                                                      double.infinity;

                                                  return aRank < bRank ? a : b;
                                                },
                                              );

                                              return Container(
                                                width: double.infinity,
                                                height: 240,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 8, 8, 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                //
                                                child: Column(
                                                  // resultRank 값이 0이 아닐때는 몇등인지 표시해주고 5등도 안되면 액땜 표시
                                                  children: [
                                                    (highestRankGame
                                                                .resultRank! !=
                                                            0)
                                                        ? SignutureFont3(
                                                            title:
                                                                '${highestRankGame.resultRank}등',
                                                            textStyle:
                                                                bigTextStyle2,
                                                            strokeTextStyle:
                                                                bigTextStyleWithStroke2,
                                                          )
                                                        : SignutureFont3(
                                                            title: '액땜',
                                                            textStyle:
                                                                bigTextStyle2,
                                                            strokeTextStyle:
                                                                bigTextStyleWithStroke2,
                                                          ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                  255,
                                                                  238,
                                                                  238,
                                                                  238,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        child:
                                                            // 밑에 박스에 회색영역으로 경험치 상금등 게임결과 및 상세정보버튼
                                                            GameResultAnalysis(
                                                                userGames:
                                                                    userGames,
                                                                lottoResult:
                                                                    lottoResult)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    } else {
                                      return const Center(
                                          child: Text('No data available'));
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Text('No data available',
                              style: TextStyle(color: Colors.black12));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
