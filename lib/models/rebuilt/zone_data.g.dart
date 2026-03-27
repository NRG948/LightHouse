// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneData _$ZoneDataFromJson(Map<String, dynamic> json) => ZoneData(
      zoneId: json['zoneId'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ZoneDataToJson(ZoneData instance) => <String, dynamic>{
      'zoneId': instance.zoneId,
      'data': instance.data,
    };
