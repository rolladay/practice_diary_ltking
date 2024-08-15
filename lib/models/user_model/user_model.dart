import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kingoflotto/models/user_game_model/user_game.dart';


part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String uid,
    required String displayName,
    required String photoUrl,
    @TimestampConverter() required DateTime createdTime,
    @TimestampConverter() required DateTime lastSignedIn,
    required double totalSpend,
    required double totalPrize,
    required String email,
    required List<UserGame> userGames,
    double? winningRate,
    int? rank,
  }) = _User;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}