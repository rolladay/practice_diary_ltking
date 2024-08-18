// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      roundNo: (json['roundNo'] as num).toInt(),
      selectedDrwNos: (json['selectedDrwNos'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toSet(),
      playerUid: json['playerUid'] as String,
      result: json['result'] as String?,
      winningNos: (json['winningNos'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toSet(),
      matchingCount: (json['matchingCount'] as num?)?.toInt(),
      bonusNo: (json['bonusNo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'roundNo': instance.roundNo,
      'selectedDrwNos': instance.selectedDrwNos.toList(),
      'playerUid': instance.playerUid,
      'result': instance.result,
      'winningNos': instance.winningNos?.toList(),
      'matchingCount': instance.matchingCount,
      'bonusNo': instance.bonusNo,
    };
