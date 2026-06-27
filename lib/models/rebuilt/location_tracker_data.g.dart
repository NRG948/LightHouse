// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_tracker_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationTrackerData _$LocationTrackerDataFromJson(Map<String, dynamic> json) =>
    LocationTrackerData(
      zones: (json['zones'] as List<dynamic>?)
          ?.map((e) => ZoneData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationTrackerDataToJson(
        LocationTrackerData instance) =>
    <String, dynamic>{
      'zones': instance.zones,
    };
