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
  ..autoPath = AutoPathData.fromJson(json['autoPath'] as Map<String, dynamic>)
  ..crossedMidline = json['crossedMidline'] as bool?
  ..locations = json['locations'] == null
      ? null
      : LocationTrackerData.fromJson(json['locations'] as Map<String, dynamic>)
  ..isDefended = json['isDefended'] as bool?
  ..isShoveling = json['isShoveling'] == null
      ? null
      : MetricData.fromJson(json['isShoveling'] as Map<String, dynamic>)
  ..isFeeding = json['isFeeding'] == null
      ? null
      : MetricData.fromJson(json['isFeeding'] as Map<String, dynamic>)
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
  ..rating = (json['rating'] as num?)?.toDouble()
  ..comments = json['comments'] as String?;

Map<String, dynamic> _$AtlasDataToJson(AtlasData instance) => <String, dynamic>{
      'scouterName': instance.scouterName,
      'teamNumber': instance.teamNumber,
      'matchNumber': instance.matchNumber,
      'isReplay': instance.isReplay,
      'matchType': instance.matchType,
      'driverStation': instance.driverStation,
      'autoPath': instance.autoPath,
      'crossedMidline': instance.crossedMidline,
      'locations': instance.locations,
      'isDefended': instance.isDefended,
      'isShoveling': instance.isShoveling,
      'isFeeding': instance.isFeeding,
      'isDefendingTrenchOrBump': instance.isDefendingTrenchOrBump,
      'isDefendingNeutralZone': instance.isDefendingNeutralZone,
      'isDefendingAllianceZone': instance.isDefendingAllianceZone,
      'isStealing': instance.isStealing,
      'tags': instance.tags,
      'climb': instance.climb,
      'rating': instance.rating,
      'comments': instance.comments,
    };
