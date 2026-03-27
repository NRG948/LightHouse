import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/rebuilt/auto_path_data.dart';
import 'package:lighthouse/models/rebuilt/location_tracker_data.dart';
import 'package:lighthouse/models/rebuilt/metric_data.dart';

part "atlas_data.g.dart";

@JsonSerializable()
class AtlasData {
  // setup
  String? scouterName;
  int? matchNumber;
  bool? isReplay;
  String? matchType;
  String? driverStation;

  // auto
  List<AutoPathData>? autoPaths;
  bool? crossedMidline;

  // offense
  LocationTrackerData? locations;
  bool? isDefended;
  MetricData? isShoveling;
  MetricData? isFeeding;

  // defense
  MetricData? isDefendingTrenchOrBump;
  MetricData? isDefendingNeutralZone;
  MetricData? isDefendingAllianceZone;
  MetricData? isStealing;

  AtlasData(); // default constructor

  factory AtlasData.fromJson(Map<String, dynamic> json) =>
      _$AtlasDataFromJson(json);
  Map<String, dynamic> toJson() => _$AtlasDataToJson(this);
}
