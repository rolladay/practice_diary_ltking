// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      createdTime:
          const TimestampConverter().fromJson(json['createdTime'] as Timestamp),
      lastSignedIn: const TimestampConverter()
          .fromJson(json['lastSignedIn'] as Timestamp),
      totalSpend: (json['totalSpend'] as num).toDouble(),
      totalPrize: (json['totalPrize'] as num).toDouble(),
      email: json['email'] as String,
      userGames: (json['userGames'] as List<dynamic>)
          .map((e) => UserGame.fromJson(e as Map<String, dynamic>))
          .toList(),
      winningRate: (json['winningRate'] as num?)?.toDouble(),
      rank: (json['rank'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'createdTime': const TimestampConverter().toJson(instance.createdTime),
      'lastSignedIn': const TimestampConverter().toJson(instance.lastSignedIn),
      'totalSpend': instance.totalSpend,
      'totalPrize': instance.totalPrize,
      'email': instance.email,
      'userGames': instance.userGames,
      'winningRate': instance.winningRate,
      'rank': instance.rank,
    };
