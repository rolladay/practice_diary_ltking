import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ref를 사용하기 위해 필요
import '../../models/lotto_result_model/lotto_result.dart';
import '../../models/user_game_model/user_game.dart';
import '../auth/auth_service.dart';



// 라운드에 해당하는 유저게임을 불러온다. 캐시먼저 보고 없으면 파베
Future<List<UserGame>> loadUserGames(WidgetRef ref, int roundNumber) async {
  final cacheManager = DefaultCacheManager();
  final user = ref.read(authServiceProvider);

  if (user != null) {
    final cacheKey = 'user_game_${user.uid}_$roundNumber';
    print('유저값 : ${user.uid}');
    print('라운드넘버 : $roundNumber');
    try {
      // 캐시에서 데이터 가져오기
      final fileInfo = await cacheManager.getFileFromCache(cacheKey);

      List<UserGame> userGames = [];

      if (fileInfo != null) {
        // 캐시에서 데이터 읽기
        final jsonString = await fileInfo.file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        userGames = jsonData.map((gameJson) => UserGame.fromJson(gameJson)).toList();
        print('캐시에서 불러온 유저게임: $userGames');
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
          userGames = querySnapshot.docs.map((doc) => UserGame.fromJson(doc.data())).toList();
        } else {
          print('Firestore 쿼리 결과가 비어있음.');
        }

        // Firestore에서 데이터를 가져온 후 다시 캐시에 저장
        if (userGames.isNotEmpty) {
          final jsonString = jsonEncode(userGames.map((game) => game.toJson()).toList());
          await cacheManager.putFile(cacheKey, Uint8List.fromList(utf8.encode(jsonString)));
        }
      }

      return userGames;
    } catch (e) {
      print('캐시에서 사용자 게임을 읽거나 Firestore에서 가져오는 중 오류 발생: $e');
    }
  }
  return [];
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

// 해당회차로또게임즈를 받고, 당첨결과 로또리절트를 받아서
// 유저게임 리스트를 돌면서 모든 UserGame객체에 랭크랑 당첨번호 등 업데이트 후 저장 및 캐시저장
// UserModel 업데이트 한다면 여기... 한번만 저장되는지 확인 필요

Future<void> updateUserGames(
    List<UserGame> userGames, LottoResult lottoResult) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cacheManager = DefaultCacheManager();
  bool shouldUpdateCache = false;

  // 유저게임리스트의 0번째부터 쭉~ 돌아보면서 업뎃해불자
  for (int i = 0; i < userGames.length; i++) {
    var userGame = userGames[i];
    // UserGame에 rank가 업데이트되지 않은 경우에만 업데이트 진행. 즉 아직 로또리절트결과를 업데이트 안한 경우만 진행
    if (userGame.resultRank == null) {
      // 각 게임에 해당하는 등수를 추출
      int rank = checkLottoRank(
        lottoResult.winningNumbers,
        lottoResult.bonusNumber,
        userGame.selectedDrwNos,
      );
      // 맞은 번호 추출
      List<int> winningNos = userGame.selectedDrwNos
          .where(
              (selectedNum) => lottoResult.winningNumbers.contains(selectedNum))
          .toList();
      // 맞은 갯수추출
      int matchingCount = winningNos.length;

      // 업데이트된 userGame 객체를 새롭게 할당
      userGame = userGame.copyWith(
        resultRank: rank,
        winningNos: winningNos,
        matchingCount: matchingCount,
      );

      // userGames 리스트에 업데이트된 userGame 객체 할당
      userGames[i] = userGame;

      // Firestore에 업데이트
      await firestore
          .collection('users')
          .doc(userGame.playerUid)
          .collection('userGames')
          .doc(userGame.gameId)
          .set(userGame.toJson());

      shouldUpdateCache = true; // 업데이트가 발생했으므로 캐시도 업데이트 필요
    }
  }

  // 모든 업데이트가 완료된 후에  랭크, 매칭카운트 등 업데이트된 유저게임즈 리스트로 캐시 업데이트
  if (shouldUpdateCache) {
    final cacheKey =
        'user_game_${userGames.first.playerUid}_${lottoResult.roundNumber}';
    final jsonString =
        jsonEncode(userGames.map((game) => game.toJson()).toList());
    await cacheManager.putFile(cacheKey, utf8.encode(jsonString));
  }
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






// 캐시에 있는(키 : 'lotto_result') 로또 결과 다 반환 (최근거 아님)
// LottoResult는 FB에 저장하지 않기 때문에... 항상 새로 패치해오고 나서 캐시에 저장하는 과정을 거침

// 캐시매니저 캐시 : 유저게임_uid_회차 에 있는 캐시에 저장된 파일을 가져온다. 이 아래꺼가 원래꺼임.
// Future<List<UserGame>> loadUserGames(WidgetRef ref, int roundNumber) async {
//   final cacheManager = DefaultCacheManager();
//   final user = ref.read(authServiceProvider);
//
//   // 나중에 에러생기면 캐시에 데이터 없을떄 파베에서 불러오는 로직 추가해야함.
//   if (user != null) {
//     final cacheKey = 'user_game_${user.uid}_$roundNumber';
//     try {
//       final fileInfo = await cacheManager.getFileFromCache(cacheKey);
//       if (fileInfo != null) {
//         final jsonString = await fileInfo.file.readAsString();
//         final List<dynamic> jsonData = jsonDecode(jsonString);
//         final List<UserGame> userGames =
//             jsonData.map((gameJson) => UserGame.fromJson(gameJson)).toList();
//         print('유저게임 로드유저게임 함수 : $userGames');
//         return userGames;
//       }
//     } catch (e) {
//       print('Error reading cached user games: $e');
//     }
//   }
//
//   return [];
// }

