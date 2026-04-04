import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

String prettifyJsonString(String jsonString) {
  return prettifyJsonMap(json.decode(jsonString) as Map<String, dynamic>);
}

String prettifyJsonMap(Map<String, dynamic> jsonMap) {
  var encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(jsonMap);
}
