import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/ad_banner_widget.dart';
import '../components/my_container.dart';
import '../components/my_sizedbox.dart';
import '../components/signiture_font.dart';
import '../components/signiture_font2.dart';
import '../components/signiture_font3.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/lotto_service/lotto_result_manager.dart';
import '../features/lotto_service/usergame_manager.dart';
import '../models/lotto_result_model/lotto_result.dart';
import '../models/user_game_model/user_game.dart';




// 이 파일은 LottoPage 메인의 듀얼로 학습용임!!!! 홈페이지 다트파일에서 숫자만 추가해서 써도됨.
// 나중에 코드리뷰하자. 공부차원
class LottoPage2 extends ConsumerStatefulWidget {
  const LottoPage2({super.key});

  @override
  ConsumerState<LottoPage2> createState() => _LottoPageState();
}

class _LottoPageState extends ConsumerState<LottoPage2> {
  LottoResult? _lottoResult;
  List<UserGame>? _userGames;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final lottoResult = await getCachedOrFetchLottoResult();
      final userGames = await loadUserGames(ref, lottoResult.roundNumber);
      await updateUserGames(userGames, lottoResult);

      if (mounted) {
        setState(() {
          _lottoResult = lottoResult;
          _userGames = userGames;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
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
      body: Column(
        children: [
          const MySizedBox(height: 8),
          const AdBannerWidget(),
          const MySizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingWidget();
    } else if (_errorMessage != null) {
      return _buildErrorWidget();
    } else {
      return _buildLottoResultWidget();
    }
  }

  Widget _buildLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
  }

  Widget _buildErrorWidget() {
    return Center(child: Text('Error: $_errorMessage'));
  }

  Widget _buildLottoResultWidget() {
    return Column(
      children: [
        _buildLottoResultDetails(),
        _buildUserGamesDetails(),
      ],
    );
  }

  Widget _buildLottoResultDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MyContainer(
        upperChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text('${_lottoResult!.roundNumber}회',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(_lottoResult!.formattedYMDDrawDate,
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        bottomChild: Column(
          children: [
            const MySizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _lottoResult!.winningNumbers.map((number) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
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
            const MySizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bonus Number : ',
                    style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text(_lottoResult!.bonusNumber.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const MySizedBox(height: 8),
            const Text('1등 당첨금', style: TextStyle(color: Colors.black54)),
            SignutureFont2(
              title: '${_lottoResult!.prizeAmounts}원',
              textStyle: bigTextStyle,
              strokeTextStyle: bigTextStyleWithStroke,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 1, width: double.infinity, color: Colors.black45),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text('${_lottoResult!.winners} 명', style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  Text('당첨판매점 보기', style: TextStyle(fontWeight: FontWeight.bold, color: specialBlue)),
                ],
              ),
            ),
          ],
        ),
        bottomHeight: 200,
      ),
    );
  }

  Widget _buildUserGamesDetails() {
    if (_userGames == null) {
      return const Center(child: Text('No data available'));
    } else if (_userGames!.isEmpty) {
      return _buildNoUserGamesWidget();
    } else {
      return _buildUserGamesListWidget();
    }
  }

  Widget _buildNoUserGamesWidget() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/lotto_missing.png', width: 32),
            const MySizedBox(height: 8),
            const Text('이 라운드에 도전하지 않았습니다.'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserGamesListWidget() {
    List<UserGame> rankUpdatedGames = _userGames!
        .where((game) => game.resultRank != null)
        .toList();

    UserGame highestRankGame = rankUpdatedGames.reduce(
            (a, b) => (a.resultRank ?? double.infinity) < (b.resultRank ?? double.infinity) ? a : b);

    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          (highestRankGame.resultRank! != 0)
              ? SignutureFont3(
            title: '${highestRankGame.resultRank}등',
            textStyle: bigTextStyle2,
            strokeTextStyle: bigTextStyleWithStroke2,
          )
              : SignutureFont3(
            title: '액땜',
            textStyle: bigTextStyle2,
            strokeTextStyle: bigTextStyleWithStroke2,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '총상금 + 0원 | 적중률 0.04% - 4/36',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '총상금 + 0원 | 적중률 0.04% - 4/36',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(specialBlue),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          children: _userGames!.map((userGame) {
                            return ListTile(
                              title: Text('Game ID: ${userGame.gameId}'),
                              subtitle: Text('등수: ${userGame.resultRank}\n번호: ${userGame.selectedDrwNos.join(', ')}'),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    child: const Text(
                      '상세결과확인',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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