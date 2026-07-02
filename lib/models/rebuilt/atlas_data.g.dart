// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atlas_data.dart';

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
  ..autoPath = json['autoPath'] == null
      ? null
      : AutoPathData.fromJson(json['autoPath'] as Map<String, dynamic>)
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
      'matchPrediction': instance.matchPrediction?.toJson(),
      'autoPath': instance.autoPath?.toJson(),
      'locations': instance.locations?.toJson(),
      'isDefended': instance.isDefended,
      'isShoveling': instance.isShoveling?.toJson(),
      'isShootingOver': instance.isShootingOver?.toJson(),
      'isDefendingTrenchOrBump': instance.isDefendingTrenchOrBump?.toJson(),
      'isDefendingNeutralZone': instance.isDefendingNeutralZone?.toJson(),
      'isDefendingAllianceZone': instance.isDefendingAllianceZone?.toJson(),
      'isStealing': instance.isStealing?.toJson(),
      'tags': instance.tags,
      'climb': instance.climb?.toJson(),
      'scoring': instance.scoring,
      'dataQuality': instance.dataQuality,
      'comments': instance.comments,
    };
