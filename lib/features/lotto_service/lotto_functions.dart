import '../../models/lotto_result_model/lotto_result.dart';
import '../../models/user_game_model/user_game.dart';

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