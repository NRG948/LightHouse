// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationZoneData _$ZoneDataFromJson(Map<String, dynamic> json) => LocationZoneData(
      zoneId: $enumDecode(_$ZoneIdEnumMap, json['zoneId']),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ZoneDataToJson(LocationZoneData instance) => <String, dynamic>{
      'zoneId': _$ZoneIdEnumMap[instance.zoneId]!,
      'data': instance.data,
    };

const _$ZoneIdEnumMap = {
  LocationZoneId.depotCorner: 'depotCorner',
  LocationZoneId.depotTrench: 'depotTrench',
  LocationZoneId.depotWall: 'depotWall',
  LocationZoneId.depotBump: 'depotBump',
  LocationZoneId.tower: 'tower',
  LocationZoneId.hub: 'hub',
  LocationZoneId.outpostWall: 'outpostWall',
  LocationZoneId.outpostBump: 'outpostBump',
  LocationZoneId.outpostCorner: 'outpostCorner',
  LocationZoneId.outpostTrench: 'outpostTrench',
};
