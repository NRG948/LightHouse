import 'package:json_annotation/json_annotation.dart';

part "location_tracker_data.g.dart";

@JsonSerializable()
class LocationTrackerData {
  Map<LocationZoneId, List<int>> zones;

  LocationTrackerData({Map<LocationZoneId, List<int>>? zones})
      : zones = zones ?? {};

  factory LocationTrackerData.fromJson(Map<String, dynamic> json) =>
      _$LocationTrackerDataFromJson(json);
  Map<String, dynamic> toJson() => _$LocationTrackerDataToJson(this);
}

enum LocationZoneId {
  depotCorner,
  depotTrench,
  depotWall,
  depotBump,
  tower,
  hub,
  outpostWall,
  outpostBump,
  outpostCorner,
  outpostTrench,
}
