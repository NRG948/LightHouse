import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String version = "v3";
String get baseUrl => "https://api.statbotics.io/$version";

Future<Map<String, dynamic>> fetchJsonFrom(String url) async {
  http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode >= 200 && response.statusCode < 300) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Fetch $url failed. Error:\n${e.toString()}");
      return {};
    }
  } else {
    debugPrint("Fetch $url failed. Status ${response.statusCode}");
    return {};
  }
}

Future<Map<String, dynamic>> fetchTeamInEvent(int team, String eventKey) async {
  return await fetchJsonFrom("$baseUrl/team_event/$team/$eventKey");
}

Future<Map<String, dynamic>> fetchTeamInSeason(int team, int year) async {
  return await fetchJsonFrom("$baseUrl/team_year/$team/$year");
}

String prettifyJsonString(String jsonString) {
  return prettifyJsonMap(json.decode(jsonString) as Map<String, dynamic>);
}

String prettifyJsonMap(Map<String, dynamic> jsonMap) {
  var encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(jsonMap);
}

Future<Map<String, double>> getTeamEPAFromEvent(
    int team, String eventKey) async {
  try {
    Map<String, dynamic> data = await fetchTeamInEvent(team, eventKey);
    return Map<String, dynamic>.from(data["epa"]["breakdown"])
        .map((key, value) => MapEntry(key, double.tryParse(value.toString()) ?? 0));
  } catch (e) {
    debugPrint("Get EPA for team $team in event $eventKey failed. Error:\n${e.toString()}");
    return {};
  }
}
