import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/lotto_result_model/lotto_result.dart';
import '../../models/user_game_model/user_game.dart';
import '../../models/user_model/user_model.dart';
import '../lotto_service/lotto_functions.dart';

part 'user_provider.g.dart';

// user 객체를 업데이트 할 때 사용하는데, auth랑 구분해서 사용하면 될듯
// 초기값은 null이지만, 이 후 state는 UserModel 객체이며, Notifier는 이 메소드 접근가능한 class의미

@Riverpod(keepAlive: true)
class UserModelNotifier extends _$UserModelNotifier {
  @override
  UserModel? build() => null;

  // 주어진 user 객체를 가지고 firebase에 update 및 상태관리
  // 즉 UserModel의 바뀐 정보를 정리하고 나서 UserModel에 업데이트 쳐주는 작업
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      // 직렬화된 JSON 객체를 Firestore에 저장
      final data = updatedUser.toJson();
      // Firestore에 데이터 업데이트 시도
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.uid)
          .update(data);
      // Firestore에 저장된 후, 상태 업데이트
      state = updatedUser;
    } catch (e) {
      print('파이어스토어에 데이터 저장 중 오류 발생: $e');
    }
  }


  //**** 이게 원래 있던 업데이트 유저 스탯... 이 아래 1003 새로운(rnak업뎃) 함수 시험적으로 넣어봄 ****

//   Future<void> updateUserStats({
//     required int totalGamesUpdated,
//     required int totalMatchingCount,
//     required List<UserGame> userGames,
//     required LottoResult lottoResult,
//   }) async {
//     final userId = userGames.first.playerUid;
//
//     final user = await fetchUser(userId);
//     if (user == null) return;
//
//     // 적중률 계산
//     double newGameWinningRate =
//         (totalMatchingCount / (totalGamesUpdated * 6)) * 100;
//     double updatedWinningRate =
//         ((user.winningRate ?? 0.0) * user.totalSpend / 1000 +
//                 newGameWinningRate * totalGamesUpdated) /
//             (user.totalSpend / 1000 + totalGamesUpdated);
//
//     // 경험치 계산
//     int newExperience = calculateExperience(userGames);
//     double updatedExperience = (user.exp ?? 0) + newExperience;
//
//     // 총 상금 계산
//     int newTotalPrize = calculateTotalPrizeAmount(userGames, lottoResult);
//     double updatedTotalPrize = (user.totalPrize) + newTotalPrize;
//
//     // 총 게임 수 및 지출 계산
//     double updatedTotalGames = (user.totalSpend / 1000) + totalGamesUpdated;
//     double updatedTotalSpends = updatedTotalGames * 1000;
//
//     // 당첨번호를 유저의 coreNos에 모두 추가하는 과정
//     List<int> updatedCoreNos = List<int>.from(user.coreNos ?? []);
//     for (var game in userGames) {
//       updatedCoreNos.addAll(game.winningNos as Iterable<int>);
//     }
//
// // 여기서부터 0928 실험
//     int newWonGames = userGames.where((game) => game.matchingCount! >= 3).length;
//     int updatedWonGames = (user.wonGames) + newWonGames;
// // 여기서부터 0928 실험
//
//     // 업데이트된 유저 정보 객체
//     final updatedUser = user.copyWith(
//       winningRate: updatedWinningRate,
//       exp: updatedExperience,
//       totalPrize: updatedTotalPrize,
//       totalSpend: updatedTotalSpends,
//       coreNos: updatedCoreNos,
//       wonGames: updatedWonGames,
//     );
//     // Firestore 및 상태 업데이트
//
//     // 0928 실험하면서 아래 주석처리
//     // await updateWonGames(updatedUser.uid);
//     await updateUser(updatedUser);
//   }


  // 여기사 1003 새로운 업데이트유저스탯 함수 (랭크업데이트용)
  // 업데이트 유저스탯 함수는 rank가 없는 게임이 있을때만
  Future<void> updateUserStats({
    required int totalGamesUpdated,
    required int totalMatchingCount,
    required List<UserGame> userGames,
    required LottoResult lottoResult,
  }) async {
    final userId = userGames.first.playerUid;
    final user = await fetchUser(userId);
    if (user == null) return;

    // 적중률 계산
    double newGameWinningRate = (totalMatchingCount / (totalGamesUpdated * 6)) * 100;
    double updatedWinningRate = ((user.winningRate ?? 0.0) * user.totalSpend / 1000 + newGameWinningRate * totalGamesUpdated) / (user.totalSpend / 1000 + totalGamesUpdated);

    // 경험치 계산
    int newExperience = calculateExperience(userGames);
    double updatedExperience = (user.exp ?? 0) + newExperience;

    // 경험치에 따른 랭크 결정
    int updatedRank = calculateRank(updatedExperience);

    // 새로운 랭크에 따른 maxGames 결정
    int updatedMaxGames = calculateMaxGames(updatedRank);

    // 총 상금 계산
    int newTotalPrize = calculateTotalPrizeAmount(userGames, lottoResult);
    double updatedTotalPrize = (user.totalPrize) + newTotalPrize;

    // 총 게임 수 및 지출 계산
    double updatedTotalGames = (user.totalSpend / 1000) + totalGamesUpdated;
    double updatedTotalSpends = updatedTotalGames * 1000;

    // 당첨번호를 유저의 coreNos에 모두 추가하는 과정
    List<int> updatedCoreNos = List<int>.from(user.coreNos ?? []);
    for (var game in userGames) {
      updatedCoreNos.addAll(game.winningNos as Iterable<int>);
    }

    int newWonGames = userGames.where((game) => game.matchingCount! >= 3).length;
    int updatedWonGames = (user.wonGames) + newWonGames;

    // 업데이트된 유저 정보 객체
    final updatedUser = user.copyWith(
      winningRate: updatedWinningRate,
      exp: updatedExperience,
      rank: updatedRank, // 새로 추가된 부분
      maxGames: updatedMaxGames, // 새로 추가된 부분
      totalPrize: updatedTotalPrize,
      totalSpend: updatedTotalSpends,
      coreNos: updatedCoreNos,
      wonGames: updatedWonGames,
    );

    await updateUser(updatedUser);
  }








  // 파이어스토어에서 uid를 찔러 유저정보를 가져온다. 가져온 유저정보를 토대로 UserModel을 구성, State에 업뎃
  Future<UserModel?> fetchUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final user = UserModel.fromJson(doc.data()!);
      state = user;
      return user;
    }
    return null;
  }

  // UserGame객체 받고, uid 받아서 유저컬렉션 내 games 에 게임객체 추가
  Future<void> addGameToUser(UserGame game, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userGames')
          .doc(game.gameId) // 고유한 gameId로 문서 생성
          .set(game.toJson()); // 새로운 게임 추가

      print('게임이 성공적으로 추가되었습니다: ${game.toJson()}');
      // 최근추가 아래줄

    } catch (e) {
      print('게임 추가 중 오류 발생: $e');
    }
    await fetchUser(userId);
  }


  // 자꾸 마지막 것만 저장되서 게임리스트 전체를 저장하게 하는 것
  Future<void> addGamesToUser(List<UserGame> games, String userId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var game in games) {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('userGames')
            .doc(game.gameId);
        batch.set(docRef, game.toJson());
      }
      await batch.commit();
      print('All games added successfully');
      await fetchUser(userId);
    } catch (e) {
      print('Error adding games: $e');
    }
  }
  // 자꾸 마지막 것만 저장되서 게임리스트 전체를 저장하게 하는 것


  // uid 받아서 유저게임리스트 받아오기
  // 이 함수 쓰이는데가 없네?
  Future<List<UserGame>> getUserGames(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userGames')
          .orderBy('roundNo', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => UserGame.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('게임 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  // uid, roundNo받아서 해당 라운드 게임만 받아오기
  Future<List<UserGame>> getUserGamesByRound(String userId, int roundNo) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userGames')
          .where('roundNo', isEqualTo: roundNo) // 특정 회차 번호로 필터링
          .orderBy('roundNo', descending: true) // 내림차순 정렬 (필요에 따라 유지)
          .get();

      return snapshot.docs
          .map((doc) => UserGame.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('게임 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }


  Future<UserModel?> fetchUserWithoutStateUpdate(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching user $uid: $e');
      return null;
    }
  }


}
