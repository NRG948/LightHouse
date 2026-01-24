import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/filemgr.dart";

// used by all active widgets to save data short-term, before serialization to json
class DataEntry {
  static final Map<String, dynamic> exportData = {};
  static late String activeConfig;
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
