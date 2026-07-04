import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/models/rebuilt/atlas_data.dart";
import "package:lighthouse/models/rebuilt/pit_data.dart";
import "package:lighthouse/themes.dart";

// used by all active widgets to save data short-term, before serialization to json
class DataEntry {
  static final Map<String, dynamic> exportData = {};
  static late String activeConfig;
}

void saveJson(Object model, BuildContext context) async {
  HapticFeedback.mediumImpact();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.colors.container,
          content: Text(
            "Are you sure you want to save? Please make sure your data is accurate.",
            style: comfortaaBold(17, color: context.colors.containerText),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No",
                    style: comfortaaBold(15, color: context.colors.accent1))),
            TextButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  List<String> missingFields = dataVerification(model);
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

                      if (!context.mounted) return;

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: context.colors.container,
                              content: Text("Successfully saved",
                                  style: comfortaaBold(17,
                                      color: context.colors.containerText)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          "/home-scouter",
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text("OK",
                                        style: comfortaaBold(15,
                                            color: context.colors.accent1)))
                              ],
                            );
                          });
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: context.colors.container,
                            content: Text("MISSING DATA:\n$missingFields",
                                style: comfortaaBold(17,
                                    color: context.colors.containerText)),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK",
                                      style: comfortaaBold(15,
                                          color: context.colors.accent1)))
                            ],
                          );
                        });
                  }
                },
                child: Text("Yes",
                    style: comfortaaBold(15, color: context.colors.accent1))),
          ],
        );
      });
}

List<String> dataVerification(Object model) {
  switch (model) {
    case AtlasData data:
      {
        return verifyAtlasData(data);
      }
    case PitData data:
      {
        return verifyPitData(data);
      }
    default:
      {
        return [];
      }
  }
}

List<String> verifyAtlasData(AtlasData data) {
  List<String> missingFields = [];
  if (data.scouterName == null || data.scouterName!.isEmpty) {
    missingFields.add("Scouter Name");
  }
  if (data.matchNumber == null || data.matchNumber == 0) {
    missingFields.add("Match Number");
  }
  if (data.teamNumber == null || data.teamNumber == 0) {
    missingFields.add("Team Number");
  }
  if (data.matchType == null) {
    missingFields.add("Match Type");
  }
  if (data.driverStation == null) {
    missingFields.add("Driver Station");
  }
  if (data.dataQuality == null || data.dataQuality == 0) {
    missingFields.add("Data Quality");
  }
  return missingFields;
}

List<String> verifyPitData(PitData data) {
  List<String> missingFields = [];
  if (data.teamNumber == null || data.teamNumber == 0) {
    missingFields.add("Team Number");
  }
  return missingFields;
}

void showReturnDialog(BuildContext context) {
  HapticFeedback.mediumImpact();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: context.colors.container,
        content: Text(
            "Are you sure you want to return home? \n Non-saved data CANNOT be recovered!",
            style: comfortaaBold(17, color: context.colors.containerText)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No",
                  style: comfortaaBold(15, color: context.colors.accent1))),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home-scouter", (Route<dynamic> route) => false);
            },
            child: Text("Yes",
                style: comfortaaBold(15, color: context.colors.accent1)),
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
