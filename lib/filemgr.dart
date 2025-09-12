import "dart:convert";
import "dart:io";
import "dart:math";
import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/layouts.dart";
import "package:lighthouse/pages/data_entry.dart";
import "package:path/path.dart";

import "package:path_provider/path_provider.dart";

late final Map<String, String> configData;
late String configFolder;

Future<void> initConfig() async {
  configData = {};

  if (Platform.isAndroid) {
    final directoryInstance = await getExternalStorageDirectory();
    if (directoryInstance == null) {
      return;
    }
    configFolder = directoryInstance.path;
  } else if (Platform.isIOS) {
    final directoryInstance = await getApplicationDocumentsDirectory();
    configFolder = directoryInstance.path;
  } else {
    throw UnimplementedError(
        "You're trying to run this app on something other than iOS/Android. why?");
  }
}

Future<Map<String, String>> loadConfig({bool reset = false}) async {
  configData.clear();
  late Map<String, dynamic> configJson;
  final configFile = File("$configFolder/config.nrg");
  if (!(await configFile.exists()) || reset) {
    configFile.writeAsString(jsonEncode(defaultConfig));
    configJson = defaultConfig;
  } else {
    configJson =
        jsonDecode(ensureSingleCurlyBrace(await configFile.readAsString()));
  }
  configData.addEntries(configJson.entries
      .map((entry) => MapEntry(entry.key, entry.value.toString())));
  return configData;
}

List<String> getSavedEvents() {
  final configDir = Directory(configFolder);
  return getDirectoryFileNames(configDir);
}

bool ensureSavedDataExists(String eventKey) {
  if (Directory("$configFolder/$eventKey").existsSync()) {
    return Directory("$configFolder/$eventKey")
        .listSync()
        .whereType<Directory>()
        .map((e) {
      return basename(e.path);
    }).any(["Atlas", "Chronos", "Pit", "Human Player"].contains);
  }
  return false;
}

/// Returns the file names in the directory [dir].
///
/// Calling this on the event key directory is observed to load saved layouts.
List<String> getDirectoryFileNames(Directory dir) => dir
    .listSync()
    .whereType<Directory>()
    .map((dir) => basename(dir.path))
    .toList();

List<String> getLayouts(String eventKey) {
  final eventKeyDir = Directory("$configFolder/$eventKey");
  /*
  Do not remove this debugPrint statement.

  Saved layouts will not load if it is removed.
  The exact reasons are unknown, but Colin's best guess is that listSync() is broken and will not
  return files or folders unless the directory has already been listed.

  Note: Colin's funnier message was replaced with this on 9/11/2025.
  */
  debugPrint(getDirectoryFileNames(eventKeyDir).toString());

  final List<String> layoutList = getDirectoryFileNames(eventKeyDir);
  if (layoutList.isEmpty) {
    layoutList.add("No Data");
  }

  // This is a quick fix for the database folder. It should be redesigned to better accommodate for it.
  for (String i in ["database", ".Trash"]) {
    if (layoutList.contains(i)) {
      layoutList.remove(i);
    }
  }

  return layoutList;
}

List<String> getFilesInLayout(String eventKey, String layout) {
  final layoutDir = Directory("$configFolder/$eventKey/$layout");
  if (!layoutDir.existsSync()) {
    return [];
  }
  // Do not remove debugPrint(); Refer to the comment in getLayouts().
  debugPrint(layoutDir.listSync().toString());

  return layoutDir.listSync().map((file) => basename(file.path)).toList();
}

/// Deletes all saved data stored under the current event key.
///
/// Returns true if successful, and false otherwise.
Future<bool> clearSavedData() async {
  await loadConfig();
  try {
    final directory = Directory("$configFolder/${configData["eventKey"]}");
    if (await directory.exists()) {
      await directory.delete(recursive: true);
      return true;
    } else {
      debugPrint('Error clearing data: Directory not found.');
      return false;
    }
  } catch (e) {
    debugPrint('Error clearing data: $e.');
    return false;
  }
}

/// Creates the event key directory if one does not exist.
Future<void> ensureEventKeyDirectoryExists() async {
  final eventKeyDirectory =
      Directory("$configFolder/${configData["eventKey"]}");
  if (!(await eventKeyDirectory.exists())) {
    await eventKeyDirectory.create(recursive: true);
  }
}

Future<int> saveExport() async {
  final random = Random();

  final layoutDirectory = Directory(
      "$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}");
  if (!(await layoutDirectory.exists())) {
    await layoutDirectory.create(recursive: true);
  }
  late String exportName;
  switch (DataEntry.activeConfig) {
    case "Atlas":
    case "Chronos":
      exportName =
          "${DataEntry.exportData["teamNumber"]}_${DataEntry.exportData["matchType"]}_${DataEntry.exportData["matchNumber"]}_${random.nextInt(9999)}";
    case "Pit":
      exportName =
          "${DataEntry.exportData["teamNumber"]}_Pit_${random.nextInt(9999)}";
    case "Human Player":
      exportName =
          "${DataEntry.exportData["redHPTeam"]}_${DataEntry.exportData["blueHPTeam"]}_HumanPlayer_${random.nextInt(9999)}";
    default:
      exportName = "${random.nextInt(9999)}";
  }
  final exportFile = File(
      "$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}/$exportName.json");
  addToUploadQueue(
      "$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}/$exportName.json");
  DataEntry.exportData["layout"] = DataEntry.activeConfig;
  DataEntry.exportData["exportName"] = exportName;
  DataEntry.exportData["timestamp"] = DateTime.now().toString();
  final exportDataEncoded = jsonEncode(DataEntry.exportData);
  exportFile.writeAsString(exportDataEncoded);
  return 0;
}

void addToUploadQueue(String file) async {
  final queueFile = File("$configFolder/uploadQueue.nrg");
  if (!(await queueFile.exists()) || queueFile.readAsStringSync() == "") {
    queueFile.writeAsString(jsonEncode([file]));
  } else {
    final List<dynamic> queue = jsonDecode(queueFile.readAsStringSync());
    queue.add(file);
    queueFile.writeAsString(jsonEncode(queue));
  }
}

Future<List<dynamic>> getUploadQueue() async {
  final queueFile = File("$configFolder/uploadQueue.nrg");
  if (!(await queueFile.exists())) {
    return [];
  }
  final queueString = await queueFile.readAsString();
  final List<dynamic> queue = jsonDecode(queueString);
  return queue;
}

void setUploadQueue(List<dynamic> queue) {
  final queueFile = File("$configFolder/uploadQueue.nrg");
  // This should never run, since this function is only called after
  // the queue is confirmed to not be empty, meaning that uploadQueue.nrg
  // *must* exist
  if (!(queueFile.existsSync())) {
    throw UnimplementedError("what the fart -catie");
  }
  String queueString = "";
  if (queue.isNotEmpty) {
    // Start of a list
    queueString = "[";
    // very scuffed way of recreating a List<String>
    for (dynamic i in queue) {
      // Adds item to list with quotes
      queueString += "\"$i\",";
    }
    // Removes final comma
    queueString = queueString.substring(0, queueString.length - 1);
    // End of list
    queueString += "]";
  } else {
    queueString = "";
  }
  queueFile.writeAsStringSync(queueString);
}

Future<int> saveConfig() async {
  debugPrint(ensureSingleCurlyBrace(jsonEncode(configData)));
  final configFile = File("$configFolder/config.nrg");
  configFile.writeAsString(ensureSingleCurlyBrace(jsonEncode(configData)));
  return 0;
}

String ensureSingleCurlyBrace(String input) {
  // Trim any trailing spaces first
  input = input.trim();

  // If the string ends with two or more curly braces, trim it to just one
  while (input.endsWith('}}')) {
    input = input.substring(0, input.length - 1);
  }

  // Ensure at least one curly brace at the end
  if (!input.endsWith('}')) {
    input += '}';
  }

  return input;
}

List<String> getFiles() {
  final eventKeyDirectory =
      Directory("$configFolder/${configData["eventKey"]}");
  if (!(eventKeyDirectory.existsSync())) {
    return [
      "No matches recorded for ${configData["eventKey"]}. Why not create one?"
    ];
  }
  List<FileSystemEntity> eventKeyFiles = eventKeyDirectory.listSync().toList();
  return eventKeyFiles
      .whereType<File>()
      .map((file) => file.uri.pathSegments.last)
      .toList();
}

Map<String, dynamic> loadFileIntoSavedData(
  String eventKey,
  String layout,
  String fileName,
) {
  return jsonDecode(
      File("$configFolder/$eventKey/$layout/$fileName").readAsStringSync());
}

int saveFileFromSavedData(String eventKey, String layout, String fileName,
    Map<String, dynamic> content) {
  try {
    final file = File("$configFolder/$eventKey/$layout/$fileName");
    file.writeAsString(jsonEncode(content));
    return 0;
  } catch (_) {
    return 1;
  }
}

Future<String> loadFileForUpload(String fileName) async {
  final file = File(fileName);
  if (!(await file.exists())) {
    return "";
  }
  return await file.readAsString();
}

Future<int> saveDatabaseFile(
    String eventKey, String layout, String content) async {
  final databaseDirectory = Directory("$configFolder/$eventKey/database");
  if (!(databaseDirectory.existsSync())) {
    await databaseDirectory.create(recursive: true);
  }
  final dbFile = File("$configFolder/$eventKey/database/$layout.json");
  await dbFile.writeAsString(content);
  return Future.value(0);
}

String loadDatabaseFile(String eventKey, String layout) {
  final dbFile = File("$configFolder/$eventKey/database/$layout.json");
  if (!(dbFile.existsSync())) {
    return "";
  }
  return dbFile.readAsStringSync();
}

int deleteFile(String eventKey, String layout, String fileName) {
  File fileToDelete = File("$configFolder/$eventKey/$layout/$fileName");
  if (!fileToDelete.existsSync()) {
    return 1;
  }
  fileToDelete.deleteSync();
  return 0;
}

void saveTBAFile(String eventKey, String content, String type) async {
  File tbaMatchesFile = File("$configFolder/$eventKey/tba_$type.nrg");
  await ensureEventKeyDirectoryExists();
  tbaMatchesFile.writeAsString(content);
}

Future<String> loadTBAFile(String eventKey, String type) async {
  File tbaMatchesFile = File("$configFolder/$eventKey/tba_$type.nrg");
  await ensureEventKeyDirectoryExists();
  if (!(await tbaMatchesFile.exists())) {
    return "";
  }
  return await tbaMatchesFile.readAsString();
}

final Map<String, String> defaultConfig = {
  "eventKey": "2025nrg",
  "scouterName": "Scouter",
  "serverIP": "http://169.254.9.48:8080",
  "downloadTheBlueAllianceInfo": "false",
  "debugMode": "false",
  "flipField": "false",
  "currentMatch": "0",
  "currentDriverStation": "Red 1",
  "currentMatchType": "Qualifications",
  "autofillLastMatch": "false",
  "theme": "Light"
};

final Map<String, String> settingsMap = {
  "eventKey": "text",
  "scouterName": "text",
  "serverIP": "serverIP",
  "downloadTheBlueAllianceInfo": "tba",
  "debugMode": "bool",
  "flipField": "bool",
  "autofillLastMatch": "bool",
  "theme": "dropdown"
};

final Map<String, List<String>> settingsDropdownMap = {
  "theme": backgrounds.keys.toList()
};

final Map<String, IconData> settingsIconMap = {
  "eventKey": Icons.calendar_today,
  "scouterName": Icons.person,
  "serverIP": Icons.language,
  "debugMode": Icons.bug_report,
  "flipField": Icons.cached_rounded,
  "autofillLastMatch": Icons.password_rounded,
  "theme": Icons.color_lens
};
