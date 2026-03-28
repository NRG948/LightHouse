import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/general/auto_path_data.dart';

part "pit_auto_data.g.dart";

@JsonSerializable()
class PitAutoData {
  AutoPathData path;
  int fuelScored; 
  bool crossedMidline;

  PitAutoData({required this.path, required this.fuelScored, required this.crossedMidline});

  factory PitAutoData.fromJson(Map<String, dynamic> json) =>
      _$PitAutoDataFromJson(json);
  Map<String, dynamic> toJson() => _$PitAutoDataToJson(this);
}
