import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/general/match_prediction.dart';
import 'package:lighthouse/models/general/three_stage_checkbox_data.dart';
import 'package:lighthouse/models/rebuilt/climb_data.dart';
import 'package:lighthouse/models/rebuilt/pit_auto_data.dart';
import 'package:lighthouse/models/general/auto_path_data.dart';
import 'package:lighthouse/models/rebuilt/location_tracker_data.dart';
import 'package:lighthouse/models/general/metric_data.dart';

part 'scouting_data.g.dart';

// @JsonSerializable()
// abstract class PageData {
//   Map<String, dynamic> toJson();
// }

/// this allows for tagged union-like behaviour, which IMO is great for this use case.
sealed class ScoutingData {}

@JsonSerializable()
class AtlasData implements ScoutingData {
  // setup
  String? scouterName;
  int? teamNumber;
  int? matchNumber;
  bool? isReplay;
  String? matchType;
  String? driverStation;
  MatchPrediction? matchPrediction;

  // auto
  AutoPathData autoPath;
  bool? crossedMidline;

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

  AtlasData() : autoPath = AutoPathData();

  factory AtlasData.fromJson(Map<String, dynamic> json) =>
      _$AtlasDataFromJson(json);
  Map<String, dynamic> toJson() => _$AtlasDataToJson(this);
}

@JsonSerializable()
class PitData implements ScoutingData {
  // setup
  String? scouterName;
  int? teamNumber;
  String? teamName;

  // general
  String? shooterType;
  String? intakeType;
  int? fuelCapacity;
  int? ballsPerSecond;
  int? weight; // so, why int for these? they absolutely could
  int? width; // be doubles, but the NRG number box only allows
  int? length; // integers, so ints they shall be
  String? drivetrain;
  String? mechanisms;

  // auto
  List<PitAutoData> autos;

  // teleop
  ThreeStageCheckboxData? canGoBump;
  ThreeStageCheckboxData? canGoTrench;
  ThreeStageCheckboxData? canShootTrench;
  ThreeStageCheckboxData? canShootHub;
  ThreeStageCheckboxData? canShootTower;
  ThreeStageCheckboxData? canShootAnywhere;
  ThreeStageCheckboxData? canFeed;
  ThreeStageCheckboxData? canDefend;
  ThreeStageCheckboxData? canHoard;
  ThreeStageCheckboxData? canPass;
  ThreeStageCheckboxData? canShovelBump;
  ThreeStageCheckboxData? canShovelTrench;
  int? cycleTime;

  // endgame
  ClimbData? climb;
  ThreeStageCheckboxData? canShootEndgame;

  PitData() : autos = []; // default constructor

  factory PitData.fromJson(Map<String, dynamic> json) =>
      _$PitDataFromJson(json);
  Map<String, dynamic> toJson() => _$PitDataToJson(this);
}
