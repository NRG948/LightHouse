import 'package:json_annotation/json_annotation.dart';
import 'package:lighthouse/models/general/page_data.dart';
import 'package:lighthouse/models/general/three_stage_checkbox_data.dart';
import 'package:lighthouse/models/rebuilt/climb_data.dart';
import 'package:lighthouse/models/rebuilt/pit_auto_data.dart';

part "pit_data.g.dart";

@JsonSerializable()
class PitData implements PageData{
  // setup
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
