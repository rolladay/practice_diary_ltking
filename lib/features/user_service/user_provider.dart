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

      print('파이어스토어에 저장될 데이터는 ? : $data'); // Firestore에 저장되는 데이터를 확인

      // Firestore에 저장된 후, 상태 업데이트
      state = updatedUser;
    } catch (e) {
      print('파이어스토어에 데이터 저장 중 오류 발생: $e');
    }
  }


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
    double updatedWinningRate = ((user.winningRate ?? 0.0) * user.totalSpend / 1000 +
        newGameWinningRate * totalGamesUpdated) /
        (user.totalSpend / 1000 + totalGamesUpdated);

    // 경험치 계산
    int newExperience = calculateExperience(userGames);
    double updatedExperience = (user.exp ?? 0) + newExperience;

    // 총 상금 계산
    int newTotalPrize = calculateTotalPrizeAmount(userGames, lottoResult);
    double updatedTotalPrize = (user.totalPrize ?? 0) + newTotalPrize;

    // 총 게임 수 및 지출 계산
    double updatedTotalGames = (user.totalSpend/1000 ?? 0) + totalGamesUpdated;
    double updatedTotalSpends = updatedTotalGames * 1000;


    // 당첨번호를 유저의 coreNos에 모두 추가하는 과정
    List<int> updatedCoreNos = List<int>.from(user.coreNos ?? []);
    for (var game in userGames) {
      updatedCoreNos.addAll(game.winningNos as Iterable<int>);
    }


    // 업데이트된 유저 정보 객체
    final updatedUser = user.copyWith(
      winningRate: updatedWinningRate,
      exp: updatedExperience,
      totalPrize: updatedTotalPrize,
      totalSpend: updatedTotalSpends,
      coreNos: updatedCoreNos,
    );

    // Firestore 및 상태 업데이트
    await updateUser(updatedUser);
  }




  // user Collection에서 데이터를 가져와 User 객체 생성 및 상태 업데이트
  // 파이어스토어에서 uid를 찔러 유저정보를 가져온다. 가져온 유저정보를 토대로 UserModel을 구성, State에 업뎃
  Future<UserModel?> fetchUser(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final user =  UserModel.fromJson(doc.data()!);
      // print('페치전 유저는 null이어야함 $state');
      state = user;
      // print('페치 후 업데이트된 스테이트는 uid KpM2iTirTAMSJaufq4Ddwv1FUK53 :  $state');

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
          .doc(game.gameId)  // 고유한 gameId로 문서 생성
          .set(game.toJson());  // 새로운 게임 추가

      print('게임이 성공적으로 추가되었습니다: ${game.toJson()}');
    } catch (e) {
      print('게임 추가 중 오류 발생: $e');
    }
  }


  // uid 받아서 유저게임리스트 받아오기
  Future<List<UserGame>> getUserGames(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userGames')
          .orderBy('roundNo', descending: true)
          .get();
      return snapshot.docs.map((doc) => UserGame.fromJson(doc.data() as Map<String, dynamic>)).toList();
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

      return snapshot.docs.map((doc) => UserGame.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('게임 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }
}
