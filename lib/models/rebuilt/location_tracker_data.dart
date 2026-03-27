import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/rebuilt/zone_data.dart';

part "location_tracker_data.g.dart";

@JsonSerializable()
class LocationTrackerData {
  List<ZoneData> zones;

  LocationTrackerData({List<ZoneData>? zones}) : zones = zones ?? [];

  factory LocationTrackerData.fromJson(Map<String, dynamic> json) =>
      _$LocationTrackerDataFromJson(json);
  Map<String, dynamic> toJson() => _$LocationTrackerDataToJson(this);
}
