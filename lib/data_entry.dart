import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/themes.dart";
import "package:lighthouse/utils/schemas/atlas_schema.dart";
import "package:lighthouse/utils/schemas/pit_schema.dart";

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
                  List<String> missingFields = getMissingFields();
                  if (missingFields.isEmpty) {
                    List<String> schemaErrors = validateExportDataSchema();
                    if (schemaErrors.isEmpty) {
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
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("SCHEMA VALIDATION ERRORS:",
                                      style: comfortaaBold(17,
                                          color: context.colors.containerText)),
                                  const SizedBox(height: 8),
                                  ...schemaErrors.take(10).map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          e,
                                          style: comfortaaBold(13,
                                              color:
                                                  context.colors.containerText),
                                        ),
                                      )),
                                  if (schemaErrors.length > 10)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                          "...and ${schemaErrors.length - 10} more",
                                          style: comfortaaBold(13,
                                              color: context
                                                  .colors.containerText)),
                                    ),
                                ],
                              ),
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

List<String> validateExportDataSchema() {
  final schema = switch (DataEntry.activeConfig) {
    "Atlas" => atlasJsonSchema,
    "Pit" => pitJsonSchema,
    _ => null,
  };
  if (schema == null) return [];

  final data = Map<String, dynamic>.from(DataEntry.exportData);
  data["layout"] = DataEntry.activeConfig;
  data["exportName"] = "${data["teamNumber"]}_validation";
  data["timestamp"] = DateTime.now().toString();

  final result = schema.validate(data);
  if (result.isValid) return [];

  return result.errors.map((e) => e.toString()).toList();
}

List<String> getMissingFields() {
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
  "Pit": ["teamNumber"],
};

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
