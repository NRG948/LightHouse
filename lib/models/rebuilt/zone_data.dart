import 'package:json_annotation/json_annotation.dart';

part "zone_data.g.dart";

@JsonSerializable()
class LocationZoneData {
  LocationZoneId zoneId;
  List<int> data;

  LocationZoneData({required this.zoneId, List<int>? data}) : data = data ?? [];

  factory LocationZoneData.fromJson(Map<String, dynamic> json) =>
      _$ZoneDataFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneDataToJson(this);
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
