import 'package:flutter/material.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';

import '../constants/color_constants.dart';
import '../features/lotto_service/lotto_functions.dart';
import '../models/lotto_result_model/lotto_result.dart';
import '../models/user_game_model/user_game.dart';

class GameResultAnalysis extends StatelessWidget {
  const GameResultAnalysis({
    super.key,
    required this.userGames,
    required this.lottoResult,
  });

  final List<UserGame> userGames;
  final LottoResult lottoResult;

  @override
  Widget build(BuildContext context) {
    double accuracy = calculateAccuracy(userGames);
    int totalPrizeAmount = calculateTotalPrizeAmount(userGames, lottoResult);
    int totalExperience = calculateExperience(userGames);
    print('토탈프라이즈어마운트5 : $totalPrizeAmount');

    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '도전게임 ',
                style: TextStyle(color: Colors.black54), // 기본 스타일
              ),
              TextSpan(
                text: '${userGames.length}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold), // Bold 스타일 적용
              ),
              const TextSpan(
                text: ' | 당첨게임 ',
                style: TextStyle(color: Colors.black54),
              ),
              TextSpan(
                text:
                    '${userGames.where((game) => game.resultRank != 0).length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: ' | 적중률 ',
                style: TextStyle(color: Colors.black54),
              ),
              TextSpan(
                text: '${(accuracy * 100).toStringAsFixed(2)}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const MySizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '획득상금 ',
                style: TextStyle(color: Colors.black54),
              ),
              TextSpan(
                text: '+$totalPrizeAmount ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '원 | 경험치 ',
                style: TextStyle(color: Colors.black54),
              ),
              TextSpan(
                text: '+$totalExperience',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(specialBlue),
          ),
          onPressed: () {
            // 상세결과확인 보여주는 부분
            showModalBottomSheet(
              context: context,
              backgroundColor: backGroundColor, // 배경색 설정
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.0), // 모서리 반지름 설정
                ),
              ),
              builder: (context) {
                // 2. resultRank를 기준으로 리스트를 정렬합니다.
                List<UserGame> sortedGames = List.from(userGames)
                  ..sort((a, b) {
                    if (a.resultRank == 0) return 1; // 0 등은 마지막으로 이동
                    if (b.resultRank == 0) return -1;
                    return a.resultRank!.compareTo(b.resultRank!.toInt());
                  });

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 70%로 제한
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    // 모달 내부 여백 설정
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            height: 3,
                            width: 60,
                            color: primaryBlack,
                          ),
                        ),
                        const MySizedBox(height: 8),
                        const Text(
                          '상세결과',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const MySizedBox(height: 16),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // 내용물에 맞게 크기 조정
                              children: sortedGames.map((userGame) {
                                // 3. resultRank가 0이면 '액땜'으로 표시
                                String rankText = userGame.resultRank == 0
                                    ? '액땜'
                                    : '${userGame.resultRank}등';

                                return ListTile(
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$rankText :',
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: userGame.selectedDrwNos.map((number) {
                                          // 5. winningNos에 있는 숫자에 대해 색상 및 텍스트 스타일 변경
                                          bool isWinningNumber = userGame.winningNos
                                              ?.contains(number) ??
                                              false;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Container(
                                              width: 38.0, // 동그라미의 가로 크기
                                              height: 38.0, // 동그라미의 세로 크기
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: primaryBlack, // 테두리 색상
                                                  width: 1.0, // 테두리 두께
                                                ),
                                                color: isWinningNumber
                                                    ? primaryYellow
                                                    : Colors.grey,
                                              ),
                                              alignment: Alignment.center, // 텍스트 가운데 정렬
                                              child: Text(
                                                number.toString(),
                                                style: TextStyle(
                                                  color: isWinningNumber
                                                      ? Colors.black
                                                      : Colors.white, // 글씨 색상
                                                  fontWeight: isWinningNumber
                                                      ? FontWeight.bold
                                                      : FontWeight.normal, // 글씨 굵기
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text(
            '    상세결과확인    ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

int calculatePrizeAmount(UserGame userGame, LottoResult lottoResult) {
  switch (userGame.resultRank) {
    case 1:
      return int.tryParse(lottoResult.prizeAmounts.replaceAll(',', '')) ?? 0;
    case 2:
      return int.tryParse(lottoResult.prizeAmounts2.replaceAll(',', '')) ?? 0;
    case 3:
      return int.tryParse(lottoResult.prizeAmounts3.replaceAll(',', '')) ?? 0;
    case 4:
      return 50000; // 4등 상금 5만 원
    case 5:
      return 5000; // 5등 상금 5천 원
    default:
      return 0; // 당첨되지 않은 경우
  }
}

int calculateTotalPrizeAmount(
    List<UserGame> userGames, LottoResult lottoResult) {
  int totalPrize = 0;
  for (UserGame userGame in userGames) {
    // 상금 계산
    int prizeAmount = calculatePrizeAmount(userGame, lottoResult);
    totalPrize += prizeAmount;
  }
  return totalPrize;
}


