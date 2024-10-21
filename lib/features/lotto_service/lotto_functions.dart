import 'package:flutter/material.dart';

import '../../components/signiture_font.dart';
import '../../constants/color_constants.dart';
import '../../constants/fonts_constants.dart';
import '../../models/lotto_result_model/lotto_result.dart';
import '../../models/user_game_model/user_game.dart';
import '../../models/user_model/user_model.dart';

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



int checkLottoRank(
    List<int> winningNumbers, int bonusNumber, List<int> userNumbers) {
  int matchCount =
      userNumbers.where((number) => winningNumbers.contains(number)).length;
  bool bonusMatch = userNumbers.contains(bonusNumber);

  if (matchCount == 6) {
    return 1; // 1등
  } else if (matchCount == 5 && bonusMatch) {
    return 2; // 2등
  } else if (matchCount == 5) {
    return 3; // 3등
  } else if (matchCount == 4) {
    return 4; // 4등
  } else if (matchCount == 3) {
    return 5; // 5등
  } else {
    return 0; // 꽝
  }
}


// 꾸타이 경험치 추가될때 이상한게 있는데 이 함수에서는 문제가 없음
int calculateExperience(List<UserGame> userGames) {
  int totalExperience = 0;

  // 1. 각 게임에 대해 1점
  totalExperience += userGames.length * 1;

  // 2. 모든 userGame.matchingCount의 합 * 2점
  totalExperience +=
      userGames.fold(0, (sum, game) => sum + (game.matchingCount ?? 0)) * 2;

  // 3. 게임 등수에 따라 점수 추가
  for (UserGame game in userGames) {
    if (game.resultRank != null) {
      switch (game.resultRank) {
        case 1:
          totalExperience += 1000;
          break;
        case 2:
          totalExperience += 500;
          break;
        case 3:
          totalExperience += 200;
          break;
        case 4:
          totalExperience += 50;
          break;
        case 5:
          totalExperience += 10;
          break;
        default:
          break; // 0 또는 기타 등급은 점수 없음
      }
    }
  }

  return totalExperience;
}

double calculateAccuracy(List<UserGame> userGames) {
  if (userGames.isEmpty) {
    return 0.0; // 게임이 없는 경우 적중률 0%를 의미하는 0.0 반환
  }

  // matchCount의 총합을 계산
  int totalMatchCount = userGames.fold(0, (sumMactingPoint, game) => sumMactingPoint + game.matchingCount!.toInt());

  // 적중률 계산
  double accuracy = totalMatchCount / (userGames.length*6);

  return accuracy; // 적중률을 소수 형태로 반환 (예: 0.75는 75%를 의미)
}


String formatTotalPrize(dynamic totalPrize) {
  if (totalPrize is int || totalPrize is double) {
    String totalPrizeStr = totalPrize.toStringAsFixed(0);
    if (totalPrizeStr.length >= 9) {
      String formatted = '${totalPrizeStr[0]}.${totalPrizeStr[1]}억원';
      return formatted;
    } else if (totalPrizeStr.length >= 5) {
      String formatted = '${totalPrizeStr[0]}.${totalPrizeStr[1]}만원';
      return formatted;
    } else {
      return '$totalPrizeStr원';
    }
  } else {
    return '0원';
  }
}


Widget buildTopNumbers(UserModel user) {
  // coreNos에서 가장 빈도가 높은 6개의 번호 추출
  final numberFrequency =
  user.coreNos!.fold<Map<int, int>>({}, (map, number) {
    map[number] = (map[number] ?? 0) + 1;
    return map;
  });

  final topNumbers = numberFrequency.keys.toList()
    ..sort((a, b) => numberFrequency[b]! == numberFrequency[a]!
        ? a.compareTo(b)
        : numberFrequency[b]!.compareTo(numberFrequency[a]!));
  final top6Numbers = topNumbers.take(6).toList();

  print('넘버프리퀀시 : $numberFrequency');
  print('넘버프리퀀시 엔트리 : ${numberFrequency.entries}');
  print('coreNos: ${user.coreNos}');
  print('탑넘버: $top6Numbers');

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: top6Numbers.map((number) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
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
  );
}


int calculateRank(double experience) {
  if (experience < 25) return 1;
  if (experience < 100) return 2;
  if (experience < 250) return 3;
  if (experience < 1000) return 4;
  if (experience < 9999) return 5;
  return 5; // 1000 이상일 경우도 5로 설정
}

int calculateMaxGames(int rank) {
  switch (rank) {
    case 1:
      return 5;
    case 2:
      return 10;
    case 3:
      return 25;
    case 4:
      return 50;
    case 5:
      return 100;
    default:
      return 5; // 기본값
  }
}