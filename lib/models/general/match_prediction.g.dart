// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchPrediction _$MatchPredictionFromJson(Map<String, dynamic> json) =>
    MatchPrediction(
      alliance: $enumDecodeNullable(_$AllianceEnumMap, json['alliance']),
    );

Map<String, dynamic> _$MatchPredictionToJson(MatchPrediction instance) =>
    <String, dynamic>{
      'alliance': _$AllianceEnumMap[instance.alliance],
    };

const _$AllianceEnumMap = {
  Alliance.red: 'red',
  Alliance.blue: 'blue',
};
