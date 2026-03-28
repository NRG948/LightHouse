// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'three_stage_checkbox_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreeStageCheckboxData _$ThreeStageCheckboxDataFromJson(
        Map<String, dynamic> json) =>
    ThreeStageCheckboxData(
      stage: $enumDecode(_$CheckboxStageEnumMap, json['stage']),
    );

Map<String, dynamic> _$ThreeStageCheckboxDataToJson(
        ThreeStageCheckboxData instance) =>
    <String, dynamic>{
      'stage': _$CheckboxStageEnumMap[instance.stage]!,
    };

const _$CheckboxStageEnumMap = {
  CheckboxStage.able: 'able',
  CheckboxStage.unable: 'unable',
  CheckboxStage.preferred: 'preferred',
};
