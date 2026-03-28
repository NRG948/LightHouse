import 'package:json_annotation/json_annotation.dart';

part "three_stage_checkbox_data.g.dart";

@JsonSerializable()
class ThreeStageCheckboxData {
  CheckboxStage stage;

  ThreeStageCheckboxData({required this.stage});

  factory ThreeStageCheckboxData.fromJson(Map<String, dynamic> json) => _$ThreeStageCheckboxDataFromJson(json);
  Map<String, dynamic> toJson() => _$ThreeStageCheckboxDataToJson(this);
}

enum CheckboxStage {
  able, 
  unable, 
  preferred, 
}