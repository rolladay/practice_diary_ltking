import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_game.freezed.dart';
part 'user_game.g.dart';

@freezed
class UserGame with _$UserGame {
  factory UserGame({
    required String gameId,  // 각 게임에 고유 ID 부여
    required int roundNo,
    required List<int> selectedDrwNos,
    required String playerUid,
    String? result,
    List<int>? winningNos,
    int? matchingCount,
    int? bonusNo,
  }) = _UserGame;

  factory UserGame.fromJson(Map<String, dynamic> json) => _$UserGameFromJson(json);
}