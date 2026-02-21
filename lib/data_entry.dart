import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/filemgr.dart";

/// used by all active widgets to save data short-term, before serialization to json
class DataEntry {
  static final Map<String, dynamic> exportData = {};
  static late String activeConfig;

  static final RegExp splitPattern = RegExp(r'[\/\\\.]+');

  /// Deletes all entries in exportData.
  static void clear() {
    exportData.clear();
  }

  /// Splits a path into segments.
  static List<String> _split(String path) =>
      path.split(splitPattern).where((e) => e.isNotEmpty).toList();

  /// Deletes the value at the given path.
  ///
  /// Returns true if something was deleted.
  static bool delete(String path) {
    final parts = _split(path);
    if (parts.isEmpty) return false;

    if (parts.length == 1) {
      return exportData.remove(parts.first) != null;
    }

    final parent = getValueAt(
        parts.sublist(0, parts.length - 1).join('/'));

    if (parent is! Map<String, dynamic>) return false;

    return parent.remove(parts.last) != null;
  }

  /// Returns the value at the given path without creating anything.
  ///
  /// Returns null if the path does not exist or is blocked.
  static dynamic? getValueAt(String path) {
    final parts = _split(path);
    if (parts.isEmpty) return null;

    dynamic current = exportData;

    for (final part in parts) {
      if (current is! Map<String, dynamic>) return null;
      if (!current.containsKey(part)) return null;
      current = current[part];
    }

    return current;
  }

  /// Exports the data to the given path if the path is not blocked.
  ///
  ///
  /// For example, after
  /// ```dart
  /// path = "a/b/c";
  /// export(data, path);
  /// ```
  /// then
  /// ```dart
  /// exportData[a][b][c] == data
  /// ```
  /// given that both ```exportData[a]``` and ```exportData[a][b]``` were either ```null``` or of type ```Map<String, dynamic>```.
  static bool export(dynamic data, String path) {
    final parts = _split(path);
    if (parts.isEmpty) return false;

    if (parts.length == 1) {
      exportData[parts.first] = data;
      return true;
    }

    final parent = createDirectoryAtPathIfNonexistent(
        parts.sublist(0, parts.length - 1).join('/'));

    if (parent == null) return false;

    parent[parts.last] = data;
    return true;
  }

  /// Creates a chain of nested maps of type ```Map<String, dynamic>``` according to the path and returns the most inner map.
  ///
  ///
  /// If a non ```Map<String, dynamic>``` object blocks the path, the method will return null.
  ///
  /// For example:
  /// ```dart
  /// exportData = {
  ///   "N": {
  ///     "R": {
  ///       "G": {},
  ///       "H": 948
  ///     }
  ///   }
  /// };
  /// ```
  ///
  /// A directory exists at that path:
  /// ```dart
  /// print(createDirectoryAtPathIfNonexistent("N/R")); 
  /// // <String, dynamic>{"G": {}, "H": 948}
  /// // No changes to exportData
  /// ```
  ///
  /// The path is blocked:
  /// ```dart
  /// print(createDirectoryAtPathIfNonexistent("N/R/H")); 
  /// // null
  /// // No changes to exportData
  /// ```
  ///
  /// A new directory is created:
  /// ```dart
  /// print(createDirectoryAtPathIfNonexistent("N/R/I")); 
  /// // <String, dynamic>{}
  ///
  /// exportData == {
  ///   "N": {
  ///     "R": {
  ///       "G": {},
  ///       "H": 948,
  ///       "I": {}
  ///     }
  ///   }
  /// }
  /// ```
  static Map<String, dynamic>? createDirectoryAtPathIfNonexistent(
      String path) {
    final parts = _split(path);
    Map<String, dynamic> current = exportData;

    for (final part in parts) {
      if (!current.containsKey(part)) {
        current[part] = <String, dynamic>{};
      } else if (current[part] is! Map<String, dynamic>) {
        return null;
      }

      current = current[part] as Map<String, dynamic>;
    }

    return current;
  }

  /// Whether a map of type ```Map<String, dynamic>``` exists at the given path.
  ///
  ///
  /// For example:
  /// ```dart
  /// exportData = {
  ///   "N": {
  ///     "R": {
  ///       "G": {},
  ///       "H": 948
  ///     }
  ///   }
  /// };
  ///
  /// print(doesDirectoryAtPathExist("N/R/G")); // true
  /// print(doesDirectoryAtPathExist("N/R/H")); // false
  /// print(doesDirectoryAtPathExist("N/R/I")); // false
  /// ```
  static bool doesDirectoryAtPathExist(String path) {
    final value = getValueAt(path);
    return value is Map<String, dynamic>;
  }
}

void saveJson(BuildContext context) async {
  HapticFeedback.mediumImpact();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "Are you sure you want to save? Please make sure your data is accurate."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No")),
            TextButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  List<String> missingFields = dataVerification();
                  if (missingFields.isEmpty) {
                    if (await saveExport() == 0) {
                      if (["Atlas", "Chronos", "Human Player"]
                          .contains(DataEntry.exportData["layout"])) {
                        configData["currentMatch"] =
                            "${DataEntry.exportData["matchNumber"]}";
                        configData["currentMatchType"] =
                            DataEntry.exportData["matchType"];
                        saveConfig();
                      }
                      if (["Atlas", "Chronos"]
                          .contains(DataEntry.exportData["layout"])) {
                        configData["currentDriverStation"] =
                            "${DataEntry.exportData["driverStation"]}";
                        saveConfig();
                      }
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Successfully saved"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          "/home-scouter",
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text("OK"))
                              ],
                            );
                          });
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("MISSING DATA:\n$missingFields"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                },
                child: Text("Yes")),
          ],
        );
      });
}

List<String> dataVerification() {
  List<String> missingFields = [];
  for (String i in missingFieldMap[DataEntry.activeConfig]!) {
    if (DataEntry.exportData[i] == null ||
        DataEntry.exportData[i] == "" ||
        DataEntry.exportData[i] == 0.0 ||
        DataEntry.exportData[i] == 0) {
      missingFields.add(i);
    }
  }
  return missingFields;
}

Map<String, List<String>> missingFieldMap = {
  "Atlas": [
    "scouterName",
    "matchNumber",
    "teamNumber",
    "matchType",
    "driverStation",
    "dataQuality"
  ],
  "Chronos": [
    "scouterName",
    "matchNumber",
    "teamNumber",
    "matchType",
    "driverStation",
    "dataQuality"
  ],
  "Pit": ["interviewerName", "teamNumber", "humanPlayerPreference"],
  "Human Player": [
    "scouterName",
    "matchNumber",
    "redHPTeam",
    "blueHPTeam",
    "matchType",
    "dataQuality"
  ]
};

void showReturnDialog(BuildContext context) {
  HapticFeedback.mediumImpact();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
            "Are you sure you want to return home? \n Non-saved data CANNOT be recovered!"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No")),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home-scouter", (Route<dynamic> route) => false);
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

enum GuidanceState { setup, auto, teleop, endgame }

extension DurationExtensions on Duration {
  double get deciseconds =>
      double.parse((inMilliseconds / 1000).toStringAsFixed(1));
}
