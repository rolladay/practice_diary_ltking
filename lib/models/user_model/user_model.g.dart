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
      coreNos: (json['coreNos'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      exp: (json['exp'] as num?)?.toDouble() ?? 0,
      winningRate: (json['winningRate'] as num?)?.toDouble() ?? 0,
      wonGames: (json['wonGames'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 1,
      maxGames: (json['maxGames'] as num?)?.toInt() ?? 5,
      userComment: json['userComment'] as String? ?? 'your comment',
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
      'coreNos': instance.coreNos,
      'exp': instance.exp,
      'winningRate': instance.winningRate,
      'wonGames': instance.wonGames,
      'rank': instance.rank,
      'maxGames': instance.maxGames,
      'userComment': instance.userComment,
    };
