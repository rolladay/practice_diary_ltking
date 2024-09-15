import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    double? winningRate,
    int? rank,
    double? exp,
    List<int>? coreNos,
    @Default(5) int maxGames,
    @Default('your comment') String userComment,
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