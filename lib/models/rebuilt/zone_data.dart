import 'package:json_annotation/json_annotation.dart';

part "zone_data.g.dart";

@JsonSerializable()
class ZoneData {
  String zoneId;
  List<int> data;

  ZoneData({required this.zoneId, List<int>? data}) : data = data ?? [];

  factory ZoneData.fromJson(Map<String, dynamic> json) =>
      _$ZoneDataFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneDataToJson(this);
}
