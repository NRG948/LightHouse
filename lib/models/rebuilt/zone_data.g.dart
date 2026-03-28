// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneData _$ZoneDataFromJson(Map<String, dynamic> json) => ZoneData(
      zoneId: $enumDecode(_$ZoneEnumMap, json['zoneId']),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ZoneDataToJson(ZoneData instance) => <String, dynamic>{
      'zoneId': _$ZoneEnumMap[instance.zoneId]!,
      'data': instance.data,
    };

const _$ZoneEnumMap = {
  Zone.depotCorner: 'depotCorner',
  Zone.depotTrench: 'depotTrench',
  Zone.depotWall: 'depotWall',
  Zone.depotBump: 'depotBump',
  Zone.tower: 'tower',
  Zone.hub: 'hub',
  Zone.outpostWall: 'outpostWall',
  Zone.outpostBump: 'outpostBump',
  Zone.outpostCorner: 'outpostCorner',
  Zone.outpostTrench: 'outpostTrench',
};
