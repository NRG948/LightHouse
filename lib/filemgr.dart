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
    configFile.writeAsString(jsonEncode(defaultConfig));
    configJson = defaultConfig;
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
  final random = Random();
  final exportDataEncoded = jsonEncode(DataEntry.exportData);
  final layoutDirectory = Directory("$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}");
  if (!(await layoutDirectory.exists())) {
    await layoutDirectory.create(recursive: true);
  }
  late String exportName;
  switch (DataEntry.activeConfig) {
    case "AtlaScout":
    case "ChronoScout":
       exportName = "${DataEntry.exportData["teamNumber"]}_${DataEntry.exportData["matchType"]}_${DataEntry.exportData["matchNumber"]}_${random.nextInt(9999)}";
    case "PitScout":
    case "HPScout":
      exportName = "${DataEntry.exportData["teamNumber"]}_${DataEntry.activeConfig.split(" ")[0]}_${random.nextInt(9999)}}";
    default:
      exportName = "${random.nextInt(9999)}";
  }
  final exportFile = File("$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}/$exportName.json");
  addToUploadQueue("$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}/$exportName.json");
  exportFile.writeAsString(exportDataEncoded);
  return 0;
}

void addToUploadQueue(String file) async {
  final queueFile = File("$configFolder/uploadQueue.nrg");
  if (!(await queueFile.exists())) {
    queueFile.writeAsString(jsonEncode([file]));
  } else {
    final List<String> queue = jsonDecode(queueFile.readAsStringSync());
    queue.add(file);
    queueFile.writeAsString(jsonEncode(queue));
  }
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

final Map<String, String> defaultConfig = {
    "eventKey": "2025nrg",
    "scouterName": "barebonesNRG"
};
