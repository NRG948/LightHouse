import "dart:convert";
import "dart:io";
import "dart:math";
import "package:flutter/material.dart";
import "package:lighthouse/pages/data_entry.dart";

import "package:path_provider/path_provider.dart";

final Map<String, String> configData = {};
late String configFolder;

Future<void> initConfig() async {
  
  if(Platform.isAndroid) {
  final directoryInstance = await getExternalStorageDirectory();
  if (directoryInstance == null) {print("wtf"); return;}
  configFolder = directoryInstance.path;
  } else if (Platform.isIOS) {
  final directoryInstance = await getApplicationDocumentsDirectory();
  configFolder = directoryInstance.path;
  } else {
    throw UnimplementedError("You're trying to run this app on something other than iOS/Android. why?");
  }
}



Future<void> loadConfig() async {
  configData.clear();
  late Map<String,dynamic> configJson;
  final configFile = File("$configFolder/config.nrg");
  if (!(await configFile.exists())) {
    configFile.writeAsString(defaultConfig);
    configJson = jsonDecode(defaultConfig);
  } else {
    configJson = jsonDecode(await configFile.readAsString());
  }
  configData.addEntries(
      configJson.entries.map((entry) => MapEntry(entry.key, entry.value.toString()))
    );
}
// TODO: Change naming scheme
// Probably smth like {matchType}_{matchNum}_{driverStation}_{scouterName}_{random 3 digit failsafe ID}.json
// will automatically use smarter naming scheme if all of these keys are present
// int return type is for future error handling
Future<int> saveExport() async {
  final exportDataEncoded = jsonEncode(DataEntry.exportData);
  final eventKeyDirectory = Directory("$configFolder/${configData["eventKey"]}");
  if (!(await eventKeyDirectory.exists())) {
    await eventKeyDirectory.create();
  }

  final exportName = Random().nextInt(99999);
  final exportFile = File("$configFolder/${configData["eventKey"]}/nrg_$exportName.json");
  exportFile.writeAsString(exportDataEncoded);
  return 0;
}

Future<int> saveConfig() async {
  final configFile = File("$configFolder/config.nrg");
  configFile.writeAsString(jsonEncode(configData));
  return 0;
}

List<String> getFiles()  {
  final eventKeyDirectory = Directory("$configFolder/${configData["eventKey"]}");
  if (!(eventKeyDirectory.existsSync())) { return ["No matches recorded for ${configData["eventKey"]}. Why not create one?"];}
  List<FileSystemEntity> eventKeyFiles = eventKeyDirectory.listSync().toList();
  return eventKeyFiles.whereType<File>().map((file) => file.uri.pathSegments.last).toList();
}

final String defaultConfig = """{
    "eventKey": "2025nrg",
    "enabledLayouts": "barebonesNRG"
}""";
