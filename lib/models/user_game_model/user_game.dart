import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_game.freezed.dart';
part 'user_game.g.dart';

@freezed
class UserGame with _$UserGame {
  factory UserGame({
    required int roundNo,
    required Set<int> selectedDrwNos,
    required String playerUid,
    String? result,
    Set<int>? winningNos,
    int? matchingCount,
    int? bonusNo,
  }) = _Game;

  factory UserGame.fromJson(Map<String, dynamic> json) => _$UserGameFromJson(json);
}
