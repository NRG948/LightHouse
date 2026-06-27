// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricData _$MetricDataFromJson(Map<String, dynamic> json) => MetricData(
      isChecked: json['isChecked'] as bool? ?? false,
      selection: $enumDecodeNullable(_$SelectionEnumMap, json['selection']),
    );

Map<String, dynamic> _$MetricDataToJson(MetricData instance) =>
    <String, dynamic>{
      'isChecked': instance.isChecked,
      'selection': _$SelectionEnumMap[instance.selection],
    };

const _$SelectionEnumMap = {
  Selection.poor: 'poor',
  Selection.decent: 'decent',
  Selection.great: 'great',
};
