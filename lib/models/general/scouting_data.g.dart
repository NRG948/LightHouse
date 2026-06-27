// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scouting_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtlasData _$AtlasDataFromJson(Map<String, dynamic> json) => AtlasData()
  ..scouterName = json['scouterName'] as String?
  ..teamNumber = (json['teamNumber'] as num?)?.toInt()
  ..matchNumber = (json['matchNumber'] as num?)?.toInt()
  ..isReplay = json['isReplay'] as bool?
  ..matchType = json['matchType'] as String?
  ..driverStation = json['driverStation'] as String?
  ..matchPrediction = json['matchPrediction'] == null
      ? null
      : MatchPrediction.fromJson(
          json['matchPrediction'] as Map<String, dynamic>)
  ..autoPath = AutoPathData.fromJson(json['autoPath'] as Map<String, dynamic>)
  ..locations = json['locations'] == null
      ? null
      : LocationTrackerData.fromJson(json['locations'] as Map<String, dynamic>)
  ..isDefended = json['isDefended'] as bool?
  ..isShoveling = json['isShoveling'] == null
      ? null
      : MetricData.fromJson(json['isShoveling'] as Map<String, dynamic>)
  ..isShootingOver = json['isShootingOver'] == null
      ? null
      : MetricData.fromJson(json['isShootingOver'] as Map<String, dynamic>)
  ..isDefendingTrenchOrBump = json['isDefendingTrenchOrBump'] == null
      ? null
      : MetricData.fromJson(
          json['isDefendingTrenchOrBump'] as Map<String, dynamic>)
  ..isDefendingNeutralZone = json['isDefendingNeutralZone'] == null
      ? null
      : MetricData.fromJson(
          json['isDefendingNeutralZone'] as Map<String, dynamic>)
  ..isDefendingAllianceZone = json['isDefendingAllianceZone'] == null
      ? null
      : MetricData.fromJson(
          json['isDefendingAllianceZone'] as Map<String, dynamic>)
  ..isStealing = json['isStealing'] == null
      ? null
      : MetricData.fromJson(json['isStealing'] as Map<String, dynamic>)
  ..tags = (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..climb = json['climb'] == null
      ? null
      : ClimbData.fromJson(json['climb'] as Map<String, dynamic>)
  ..scoring = (json['scoring'] as num?)?.toInt()
  ..dataQuality = (json['dataQuality'] as num?)?.toDouble()
  ..comments = json['comments'] as String?;

Map<String, dynamic> _$AtlasDataToJson(AtlasData instance) => <String, dynamic>{
      'scouterName': instance.scouterName,
      'teamNumber': instance.teamNumber,
      'matchNumber': instance.matchNumber,
      'isReplay': instance.isReplay,
      'matchType': instance.matchType,
      'driverStation': instance.driverStation,
      'matchPrediction': instance.matchPrediction,
      'autoPath': instance.autoPath,
      'locations': instance.locations,
      'isDefended': instance.isDefended,
      'isShoveling': instance.isShoveling,
      'isShootingOver': instance.isShootingOver,
      'isDefendingTrenchOrBump': instance.isDefendingTrenchOrBump,
      'isDefendingNeutralZone': instance.isDefendingNeutralZone,
      'isDefendingAllianceZone': instance.isDefendingAllianceZone,
      'isStealing': instance.isStealing,
      'tags': instance.tags,
      'climb': instance.climb,
      'scoring': instance.scoring,
      'dataQuality': instance.dataQuality,
      'comments': instance.comments,
    };

PitData _$PitDataFromJson(Map<String, dynamic> json) => PitData()
  ..scouterName = json['scouterName'] as String?
  ..teamNumber = (json['teamNumber'] as num?)?.toInt()
  ..teamName = json['teamName'] as String?
  ..shooterType = json['shooterType'] as String?
  ..intakeType = json['intakeType'] as String?
  ..fuelCapacity = (json['fuelCapacity'] as num?)?.toInt()
  ..ballsPerSecond = (json['ballsPerSecond'] as num?)?.toInt()
  ..weight = (json['weight'] as num?)?.toInt()
  ..width = (json['width'] as num?)?.toInt()
  ..length = (json['length'] as num?)?.toInt()
  ..drivetrain = json['drivetrain'] as String?
  ..mechanisms = json['mechanisms'] as String?
  ..autos = (json['autos'] as List<dynamic>)
      .map((e) => PitAutoData.fromJson(e as Map<String, dynamic>))
      .toList()
  ..canGoBump = json['canGoBump'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canGoBump'] as Map<String, dynamic>)
  ..canGoTrench = json['canGoTrench'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canGoTrench'] as Map<String, dynamic>)
  ..canShootTrench = json['canShootTrench'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShootTrench'] as Map<String, dynamic>)
  ..canShootHub = json['canShootHub'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShootHub'] as Map<String, dynamic>)
  ..canShootTower = json['canShootTower'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShootTower'] as Map<String, dynamic>)
  ..canShootAnywhere = json['canShootAnywhere'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShootAnywhere'] as Map<String, dynamic>)
  ..canFeed = json['canFeed'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(json['canFeed'] as Map<String, dynamic>)
  ..canDefend = json['canDefend'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canDefend'] as Map<String, dynamic>)
  ..canHoard = json['canHoard'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canHoard'] as Map<String, dynamic>)
  ..canPass = json['canPass'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(json['canPass'] as Map<String, dynamic>)
  ..canShovelBump = json['canShovelBump'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShovelBump'] as Map<String, dynamic>)
  ..canShovelTrench = json['canShovelTrench'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShovelTrench'] as Map<String, dynamic>)
  ..cycleTime = (json['cycleTime'] as num?)?.toInt()
  ..climb = json['climb'] == null
      ? null
      : ClimbData.fromJson(json['climb'] as Map<String, dynamic>)
  ..canShootEndgame = json['canShootEndgame'] == null
      ? null
      : ThreeStageCheckboxData.fromJson(
          json['canShootEndgame'] as Map<String, dynamic>);

Map<String, dynamic> _$PitDataToJson(PitData instance) => <String, dynamic>{
      'scouterName': instance.scouterName,
      'teamNumber': instance.teamNumber,
      'teamName': instance.teamName,
      'shooterType': instance.shooterType,
      'intakeType': instance.intakeType,
      'fuelCapacity': instance.fuelCapacity,
      'ballsPerSecond': instance.ballsPerSecond,
      'weight': instance.weight,
      'width': instance.width,
      'length': instance.length,
      'drivetrain': instance.drivetrain,
      'mechanisms': instance.mechanisms,
      'autos': instance.autos,
      'canGoBump': instance.canGoBump,
      'canGoTrench': instance.canGoTrench,
      'canShootTrench': instance.canShootTrench,
      'canShootHub': instance.canShootHub,
      'canShootTower': instance.canShootTower,
      'canShootAnywhere': instance.canShootAnywhere,
      'canFeed': instance.canFeed,
      'canDefend': instance.canDefend,
      'canHoard': instance.canHoard,
      'canPass': instance.canPass,
      'canShovelBump': instance.canShovelBump,
      'canShovelTrench': instance.canShovelTrench,
      'cycleTime': instance.cycleTime,
      'climb': instance.climb,
      'canShootEndgame': instance.canShootEndgame,
    };
