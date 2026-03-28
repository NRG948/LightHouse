// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climb_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClimbData _$ClimbDataFromJson(Map<String, dynamic> json) => ClimbData(
      attempted: json['attempted'] as bool? ?? false,
      startTime: (json['startTime'] as num?)?.toInt(),
      region: json['region'] as String?,
      level: $enumDecodeNullable(_$ClimbLevelTypeEnumMap, json['level']) ??
          ClimbLevelType.none,
    );

Map<String, dynamic> _$ClimbDataToJson(ClimbData instance) => <String, dynamic>{
      'attempted': instance.attempted,
      'startTime': instance.startTime,
      'region': instance.region,
      'level': _$ClimbLevelTypeEnumMap[instance.level]!,
    };

const _$ClimbLevelTypeEnumMap = {
  ClimbLevelType.none: 'none',
  ClimbLevelType.l1: 'l1',
  ClimbLevelType.l2: 'l2',
  ClimbLevelType.l3: 'l3',
};
