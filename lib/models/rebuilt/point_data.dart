import 'package:json_annotation/json_annotation.dart';

part "point_data.g.dart";

@JsonSerializable()
class PointData {
  double x;
  double y;

  PointData({required this.x, required this.y});

  factory PointData.fromJson(Map<String, dynamic> json) => _$PointDataFromJson(json);
  Map<String, dynamic> toJson() => _$PointDataToJson(this);
}