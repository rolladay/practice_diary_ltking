// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      roundNo: (json['roundNo'] as num).toInt(),
      drwNo1: (json['drwNo1'] as num).toInt(),
      drwNo2: (json['drwNo2'] as num).toInt(),
      drwNo3: (json['drwNo3'] as num).toInt(),
      drwNo4: (json['drwNo4'] as num).toInt(),
      drwNo5: (json['drwNo5'] as num).toInt(),
      drwNo6: (json['drwNo6'] as num).toInt(),
      selectedDrwNos: (json['selectedDrwNos'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      playerUid: json['playerUid'] as String,
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'roundNo': instance.roundNo,
      'drwNo1': instance.drwNo1,
      'drwNo2': instance.drwNo2,
      'drwNo3': instance.drwNo3,
      'drwNo4': instance.drwNo4,
      'drwNo5': instance.drwNo5,
      'drwNo6': instance.drwNo6,
      'selectedDrwNos': instance.selectedDrwNos,
      'playerUid': instance.playerUid,
    };
