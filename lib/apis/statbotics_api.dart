import 'package:flutter/material.dart';
import 'package:lighthouse/apis/json_api.dart';

final String version = "v3";
String get baseUrl => "https://api.statbotics.io/$version";

class StatboticsApi {
  static Future<Map<String, dynamic>> fetchTeamInEvent(
      int team, String eventKey) async {
    return await fetchJsonFrom("$baseUrl/team_event/$team/$eventKey");
  }

  static Future<Map<String, dynamic>> fetchTeamInSeason(
      int team, int year) async {
    return await fetchJsonFrom("$baseUrl/team_year/$team/$year");
  }

  static Future<Map<String, double>> getTeamEPAFromEvent(
      int team, String eventKey) async {
    try {
      Map<String, dynamic> data = await fetchTeamInEvent(team, eventKey);
      return Map<String, dynamic>.from(data["epa"]["breakdown"]).map(
          (key, value) =>
              MapEntry(key, double.tryParse(value.toString()) ?? 0));
    } catch (e) {
      debugPrint(
          "Get EPA for team $team in event $eventKey failed. Error:\n${e.toString()}");
      return {};
    }
  }
}
