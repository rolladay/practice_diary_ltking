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
      List<UserGame> userGames = [];
      // 캐시에서 데이터 가져오기
      final fileInfo = await cacheManager.getFileFromCache(cacheKey);
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
    //헷갈림 안됨 user game 이긴 한데 실제로는 List, games임
        'user_game_${userGames.first.playerUid}_${lottoResult.roundNumber}';
    final jsonString =
        jsonEncode(userGames.map((game) => game.toJson()).toList());
    await cacheManager.putFile(cacheKey, utf8.encode(jsonString));
  }

  // > 여야함
  if (totalGamesUpdated > 0) {
    await userModelNotifier.updateUserStats(
      totalGamesUpdated: totalGamesUpdated,
      totalMatchingCount: totalMatchingCount,
      userGames: userGames,
      lottoResult: lottoResult,
    );
  }
}


Future<void> saveGamesToCache(
    WidgetRef ref,
    List<UserGame> games,
    LottoResult nextLottoResult
    ) async {
  final cacheManager = DefaultCacheManager();
  final user = ref.read(userModelNotifierProvider);
  if (user != null) {
    final cacheKey = 'user_game_${user.uid}_${nextLottoResult.roundNumber + 1}';
    try {
      final jsonString = jsonEncode(games.map((game) => game.toJson()).toList());
      await cacheManager.putFile(cacheKey, utf8.encode(jsonString));
    } catch (e) {
      print('Error saving games to cache: $e');
    }
  }
}