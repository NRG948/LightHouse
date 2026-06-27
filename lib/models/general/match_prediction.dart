import 'package:json_annotation/json_annotation.dart';
part "match_prediction.g.dart";

@JsonSerializable()
class MatchPrediction {
  Alliance? alliance;

  MatchPrediction({this.alliance});

  factory MatchPrediction.fromJson(Map<String, dynamic> json) =>
      _$MatchPredictionFromJson(json);
  Map<String, dynamic> toJson() => _$MatchPredictionToJson(this);
}

enum Alliance { red, blue }
