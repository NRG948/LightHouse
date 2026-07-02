import 'package:json_annotation/json_annotation.dart';

part "climb_data.g.dart";

@JsonSerializable(explicitToJson: true)
class ClimbData {
  bool attempted;
  int? startTime;
  String? region;
  ClimbLevelType level;
  ClimbData({
    this.attempted = false,
    this.startTime,
    this.region,
    this.level = ClimbLevelType.none,
  });
  factory ClimbData.fromJson(Map<String, dynamic> json) =>
      _$ClimbDataFromJson(json);
  Map<String, dynamic> toJson() => _$ClimbDataToJson(this);
}

@JsonEnum()
enum ClimbLevelType { none, l1, l2, l3 }
