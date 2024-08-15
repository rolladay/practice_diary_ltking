import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_game.freezed.dart';
part 'user_game.g.dart';

@freezed
class UserGame with _$UserGame {
  factory UserGame({
    required int roundNo,
    required int drwNo1,
    required int drwNo2,
    required int drwNo3,
    required int drwNo4,
    required int drwNo5,
    required int drwNo6,
    required List<int> selectedDrwNos,
    required String playerUid,
  }) = _Game;

  factory UserGame.fromJson(Map<String, dynamic> json) => _$UserGameFromJson(json);
}
