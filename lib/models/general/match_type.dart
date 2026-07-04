import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MatchType {
  qualification,
  playoff,
  finals,
}
