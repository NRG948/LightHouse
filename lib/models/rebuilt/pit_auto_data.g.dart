// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pit_auto_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PitAutoData _$PitAutoDataFromJson(Map<String, dynamic> json) => PitAutoData(
      path: AutoPathData.fromJson(json['path'] as Map<String, dynamic>),
      fuelScored: (json['fuelScored'] as num).toInt(),
      crossedMidline: json['crossedMidline'] as bool,
    );

Map<String, dynamic> _$PitAutoDataToJson(PitAutoData instance) =>
    <String, dynamic>{
      'path': instance.path,
      'fuelScored': instance.fuelScored,
      'crossedMidline': instance.crossedMidline,
    };
