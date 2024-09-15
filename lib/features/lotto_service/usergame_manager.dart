import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ref를 사용하기 위해 필요
import '../../models/lotto_result_model/lotto_result.dart';
import '../../models/user_game_model/user_game.dart';
import '../auth/auth_service.dart';
import '../user_service/user_provider.dart';
import 'lotto_functions.dart';

// 라운드에 해당하는 유저게임을 불러온다. 캐시먼저 보고 없으면 파베
Future<List<UserGame>> loadUserGames(WidgetRef ref, int roundNumber) async {
  final cacheManager = DefaultCacheManager();
  final user = ref.read(authServiceProvider);

  if (user != null) {
    final cacheKey = 'user_game_${user.uid}_$roundNumber';

    try {
      // 캐시에서 데이터 가져오기
      final fileInfo = await cacheManager.getFileFromCache(cacheKey);

      List<UserGame> userGames = [];

      if (fileInfo != null) {
        // 캐시에서 데이터 읽기
        final jsonString = await fileInfo.file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        userGames =
            jsonData.map((gameJson) => UserGame.fromJson(gameJson)).toList();
      }

      // 캐시에서 불러온 데이터가 비어 있거나(null이 아닌 빈 리스트인 경우) Firestore에서 데이터 가져오기
      if (userGames.isEmpty) {
        print('캐시가 비어있어서 Firestore에서 데이터 가져오기 시도');
        final firestore = FirebaseFirestore.instance;
        final querySnapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('userGames')
            .where('roundNo', isEqualTo: roundNumber) // roundNumber로 필터링
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          print('Firestore에서 유저 게임 불러옴: ${querySnapshot.docs.length}개 문서');
          // Firestore에서 가져온 데이터를 UserGame 리스트로 변환하여 userGames에 저장
          userGames = querySnapshot.docs
              .map((doc) => UserGame.fromJson(doc.data()))
              .toList();
        } else {
          print('Firestore 쿼리 결과가 비어있음.');
        }

        // Firestore에서 데이터를 가져온 후 다시 캐시에 저장
        if (userGames.isNotEmpty) {
          final jsonString =
              jsonEncode(userGames.map((game) => game.toJson()).toList());
          await cacheManager.putFile(
              cacheKey, Uint8List.fromList(utf8.encode(jsonString)));
        }
      }

      return userGames;
    } catch (e) {
      print('캐시에서 사용자 게임을 읽거나 Firestore에서 가져오는 중 오류 발생: $e');
    }
  }
  return [];
}

Future<void> updateUserGames(
  List<UserGame> userGames,
  LottoResult lottoResult,
  UserModelNotifier userModelNotifier, // 의존성 추가
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cacheManager = DefaultCacheManager();
  bool shouldUpdateCache = false;

  int totalMatchingCount = 0;
  int totalGamesUpdated = 0;

  for (int i = 0; i < userGames.length; i++) {
    var userGame = userGames[i];
    if (userGame.resultRank == null) {
      int rank = checkLottoRank(
        lottoResult.winningNumbers,
        lottoResult.bonusNumber,
        userGame.selectedDrwNos,
      );
      List<int> winningNos = userGame.selectedDrwNos
          .where(
              (selectedNum) => lottoResult.winningNumbers.contains(selectedNum))
          .toList();
      int matchingCount = winningNos.length;

      userGame = userGame.copyWith(
        resultRank: rank,
        winningNos: winningNos,
        matchingCount: matchingCount,
      );
      userGames[i] = userGame;

      await firestore
          .collection('users')
          .doc(userGame.playerUid)
          .collection('userGames')
          .doc(userGame.gameId)
          .set(userGame.toJson());

      totalMatchingCount += matchingCount;
      totalGamesUpdated++;
      shouldUpdateCache = true;
    }
  }
  //for구문 끝!

  if (shouldUpdateCache) {
    final cacheKey =
        'user_game_${userGames.first.playerUid}_${lottoResult.roundNumber}';
    final jsonString =
        jsonEncode(userGames.map((game) => game.toJson()).toList());
    await cacheManager.putFile(cacheKey, utf8.encode(jsonString));
  }

  if (totalGamesUpdated > 0) {
    await userModelNotifier.updateUserStats(
      totalGamesUpdated: totalGamesUpdated,
      totalMatchingCount: totalMatchingCount,
      userGames: userGames,
      lottoResult: lottoResult,
    );
  }
}

// **************해당회차로또게임즈를 받고, 당첨결과 로또리절트를 받아서
// 유저게임 리스트를 돌면서 모든 UserGame객체에 랭크랑 당첨번호 등 업데이트 후 저장 및 캐시저장
// UserModel 업데이트 한다면 여기... 한번만 저장되는지 확인 필요

// Future<void> updateUserGames(
//     List<UserGame> userGames, LottoResult lottoResult) async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final cacheManager = DefaultCacheManager();
//   bool shouldUpdateCache = false;
//
//   int totalMatchingCount = 0;
//   int totalGamesUpdated = 0;
//
//   // 유저게임리스트의 0번째부터 쭉~ 돌아보면서 업뎃해불자
//   for (int i = 0; i < userGames.length; i++) {
//     var userGame = userGames[i];
//     // UserGame에 rank가 업데이트되지 않은 경우에만 업데이트 진행. 즉 아직 로또리절트결과를 업데이트 안한 경우만 진행
//     if (userGame.resultRank == null) {
//       // 각 게임에 해당하는 등수를 추출
//       int rank = checkLottoRank(
//         lottoResult.winningNumbers,
//         lottoResult.bonusNumber,
//         userGame.selectedDrwNos,
//       );
//       // 맞은 번호 추출
//       List<int> winningNos = userGame.selectedDrwNos
//           .where(
//               (selectedNum) => lottoResult.winningNumbers.contains(selectedNum))
//           .toList();
//       // 맞은 갯수추출
//       int matchingCount = winningNos.length;
//
//       // 업데이트된 userGame 객체를 새롭게 할당
//       userGame = userGame.copyWith(
//         resultRank: rank,
//         winningNos: winningNos,
//         matchingCount: matchingCount,
//       );
//
//       // userGames 리스트에 업데이트된 userGame 객체 할당
//       userGames[i] = userGame;
//
//       // Firestore에 각 게임리스트 내 해당 게임에 업데이트
//       await firestore
//           .collection('users')
//           .doc(userGame.playerUid)
//           .collection('userGames')
//           .doc(userGame.gameId)
//           .set(userGame.toJson());
//
//       //적중갯수 누적
//       totalMatchingCount += matchingCount;
//       totalGamesUpdated++;
//
//       shouldUpdateCache = true; // 업데이트가 발생했으므로 캐시도 업데이트 필요
//     }
//   }
//   // for 구문 끝.
//
//   // 모든 업데이트가 완료된 후에  랭크, 매칭카운트 등 업데이트된 유저게임즈 리스트로 캐시 업데이트
//   if (shouldUpdateCache) {
//     final cacheKey =
//         'user_game_${userGames.first.playerUid}_${lottoResult.roundNumber}';
//     final jsonString =
//         jsonEncode(userGames.map((game) => game.toJson()).toList());
//     await cacheManager.putFile(cacheKey, utf8.encode(jsonString));
//   }
//
//
//
//   // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 여기서부터 실험적인 UserModel 업데이트야. $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//   // 좀 이상하다 싶으면 여기를 일단 날려라.(0905 밤...)
//   if (totalGamesUpdated > 0) {
//     final userDoc = await firestore.collection('users').doc(userGames.first.playerUid).get();
//     if (userDoc.exists) {
//       final userData = userDoc.data() as Map<String, dynamic>;
//
//       // UserModel 데이터를 가져오기
//       UserModel user = UserModel.fromJson(userData);
//
//       // 새로 추가된 게임들의 적중률 계산 %
//       // 기존 적중률과 새 게임의 적중률을 가중 평균으로 계산
//       double newGameWinningRate = (totalMatchingCount / (totalGamesUpdated * 6)) * 100;
//       double updatedWinningRate = ((user.winningRate ?? 0.0) * user.totalSpend/5000 + newGameWinningRate * totalGamesUpdated) / (user.totalSpend/5000 + totalGamesUpdated);
//
//       // 새로 얻은 경험치 계산
//       int newExperience = calculateExperience(userGames);
//       double updatedExperience = (user.exp ?? 0) + newExperience;
//       // *** 총 누적 상금 계산 ***
//       int newTotalPrize = calculateTotalPrizeAmount(userGames, lottoResult);
//       double updatedTotalPrize = (user.totalPrize ?? 0) + newTotalPrize;
//
//       // *** 총 누적 게임 수 계산 ***
//       double updatedTotalGames = (user.totalSpend ?? 0) + totalGamesUpdated;
//       double updatedTotalSpends = updatedTotalGames * 5000;
//
//       // UserModel을 Firestore에 업데이트
//       await firestore.collection('users').doc(userGames.first.playerUid).update({
//         'winningRate': updatedWinningRate,
//         'exp': updatedExperience,
//         'totalPrize': updatedTotalPrize, // 총 상금 업데이트
//         'totalSpend': updatedTotalSpends, // 총 게임 수 업데이트
//       });
//
//       // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 여기까지가 유저 누적 적중률 업데이트 구간 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//
//       // 캐시에 UserModel 저장 , 특별히 쓸일 없을듯?
//       await cacheManager.putFile(
//         'userModelCache_${userGames.first.playerUid}',
//         utf8.encode(jsonEncode(user.toJson())),
//         fileExtension: 'json',
//       );
//     }
//   }
// }
