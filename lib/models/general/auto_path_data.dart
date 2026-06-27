import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/general/point_data.dart';

part "auto_path_data.g.dart";

@JsonSerializable()
class AutoPathData {
  List<PointData> path;
  bool attemptedClimb;
  bool? climbSuccessful;
  bool? crossedMidline;

  AutoPathData({List<PointData>? path, this.attemptedClimb = false}) : path = path ?? [];

  factory AutoPathData.fromJson(Map<String, dynamic> json) => _$AutoPathDataFromJson(json);
  Map<String, dynamic> toJson() => _$AutoPathDataToJson(this);
}