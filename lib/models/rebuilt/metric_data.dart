import 'package:json_annotation/json_annotation.dart';
part "metric_data.g.dart";

@JsonSerializable()
class MetricData {
  bool isChecked;
  String? selection;

  MetricData({this.isChecked = false, this.selection});
  
  factory MetricData.fromJson(Map<String, dynamic> json) =>
      _$MetricDataFromJson(json);
  Map<String, dynamic> toJson() => _$MetricDataToJson(this);
}
