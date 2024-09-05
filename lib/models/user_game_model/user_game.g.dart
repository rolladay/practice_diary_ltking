// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserGameImpl _$$UserGameImplFromJson(Map<String, dynamic> json) =>
    _$UserGameImpl(
      gameId: json['gameId'] as String,
      roundNo: (json['roundNo'] as num).toInt(),
      selectedDrwNos: (json['selectedDrwNos'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      playerUid: json['playerUid'] as String,
      resultRank: (json['resultRank'] as num?)?.toInt(),
      winningNos: (json['winningNos'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      matchingCount: (json['matchingCount'] as num?)?.toInt(),
      donateAmount: (json['donateAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UserGameImplToJson(_$UserGameImpl instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'roundNo': instance.roundNo,
      'selectedDrwNos': instance.selectedDrwNos,
      'playerUid': instance.playerUid,
      'resultRank': instance.resultRank,
      'winningNos': instance.winningNos,
      'matchingCount': instance.matchingCount,
      'donateAmount': instance.donateAmount,
    };
