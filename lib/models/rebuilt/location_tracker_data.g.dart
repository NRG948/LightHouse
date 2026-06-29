// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_tracker_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationTrackerData _$LocationTrackerDataFromJson(Map<String, dynamic> json) =>
    LocationTrackerData(
      zones: (json['zones'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$LocationZoneIdEnumMap, k),
            (e as List<dynamic>).map((e) => (e as num).toInt()).toList()),
      ),
    );

Map<String, dynamic> _$LocationTrackerDataToJson(
        LocationTrackerData instance) =>
    <String, dynamic>{
      'zones': instance.zones
          .map((k, e) => MapEntry(_$LocationZoneIdEnumMap[k]!, e)),
    };

const _$LocationZoneIdEnumMap = {
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
