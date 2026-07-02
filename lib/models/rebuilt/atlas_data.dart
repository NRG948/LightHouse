import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/general/match_prediction.dart';
import 'package:lighthouse/models/general/three_stage_checkbox_data.dart';
import 'package:lighthouse/models/rebuilt/climb_data.dart';
import 'package:lighthouse/models/rebuilt/pit_auto_data.dart';
import 'package:lighthouse/models/general/auto_path_data.dart';
import 'package:lighthouse/models/rebuilt/location_tracker_data.dart';
import 'package:lighthouse/models/general/metric_data.dart';

part 'atlas_data.g.dart';

@JsonSerializable()
class AtlasData {
  // setup
  String? scouterName;
  int? teamNumber;
  int? matchNumber;
  bool? isReplay;
  String? matchType;
  String? driverStation;
  MatchPrediction? matchPrediction;

  // auto
  AutoPathData? autoPath;

  // offense
  LocationTrackerData? locations;
  bool? isDefended;
  MetricData? isShoveling;
  MetricData? isShootingOver;

  // defense
  MetricData? isDefendingTrenchOrBump;
  MetricData? isDefendingNeutralZone;
  MetricData? isDefendingAllianceZone;
  MetricData? isStealing;

  // endgame
  List<String>? tags;
  ClimbData? climb;
  int? scoring;
  double? dataQuality;
  String? comments;

  AtlasData();

  factory AtlasData.fromJson(Map<String, dynamic> json) =>
      _$AtlasDataFromJson(json);
  Map<String, dynamic> toJson() => _$AtlasDataToJson(this);
}
