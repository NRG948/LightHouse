import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class PageData {
  Map<String, dynamic> toJson();
}