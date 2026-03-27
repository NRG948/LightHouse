// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_path_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutoPathData _$AutoPathDataFromJson(Map<String, dynamic> json) => AutoPathData(
      path: (json['path'] as List<dynamic>?)
          ?.map((e) => PointData.fromJson(e as Map<String, dynamic>))
          .toList(),
      attemptedClimb: json['attemptedClimb'] as bool? ?? false,
    )
      ..climbSuccessful = json['climbSuccessful'] as bool?
      ..climbLevel = json['climbLevel'] as String?;

Map<String, dynamic> _$AutoPathDataToJson(AutoPathData instance) =>
    <String, dynamic>{
      'path': instance.path,
      'attemptedClimb': instance.attemptedClimb,
      'climbSuccessful': instance.climbSuccessful,
      'climbLevel': instance.climbLevel,
    };
