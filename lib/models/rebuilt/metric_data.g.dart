// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricData _$MetricDataFromJson(Map<String, dynamic> json) => MetricData(
      isChecked: json['isChecked'] as bool? ?? false,
      selection: json['selection'] as String?,
    );

Map<String, dynamic> _$MetricDataToJson(MetricData instance) =>
    <String, dynamic>{
      'isChecked': instance.isChecked,
      'selection': instance.selection,
    };
