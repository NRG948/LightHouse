import 'dart:convert';

class DataParser {
  static int? toInt(dynamic value) {
    if (value == null) return null;
    String cleanValue = value.toString().replaceAll(RegExp(r'\s+'), '');
    if (cleanValue.isEmpty) return null;
    return double.tryParse(cleanValue)?.toInt();
  }

  static double? toDouble(dynamic value) {
    if (value == null) return null;
    String cleanValue = value.toString().replaceAll(' ', '');
    if (cleanValue.isEmpty) return null;
    bool isPercent = cleanValue.endsWith('%');
    if (isPercent) {
      cleanValue = cleanValue.replaceAll('%', '');
      double? parsed = double.tryParse(cleanValue);
      return parsed != null ? parsed / 100 : null;
    }
    return double.tryParse(cleanValue);
  }

  static List<dynamic>? toList(dynamic value) {
    if (value is List) return value;
    if (value is Iterable) return value.toList();
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return decoded;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static String asString(dynamic value) {
    if (value == null) return "";
    String result = value.toString();
    if (result.toLowerCase() == "null") return "";
    return result;
  }

  static bool? toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value) {
        case "true":
          return true;
        case "false":
          return false;
        default:
          double? parsed = double.tryParse(value);
          return parsed == null ? null : parsed != 0;
      }
    }
    return null;
  }

  static bool isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;
    return false;
  }

  static Map<String, dynamic>? toMap(dynamic value) {
    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
