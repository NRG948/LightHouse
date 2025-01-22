import "dart:convert";
import "dart:io";
import "dart:math";
import "package:flutter/material.dart";
import "package:lighthouse/pages/data_entry.dart";
import "package:path/path.dart";

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

List<String> getSavedEvents() {
  final configDir = Directory(configFolder);
  return configDir.listSync().whereType<Directory>().map((dir) {return basename(dir.path);}).toList();
}

List<String> getLayouts(String eventKey) {
  final eventKeyDir = Directory("$configFolder/$eventKey");
  // DO NOT REMOVE THIS DEBUGPRINT STATEMENT!!!
  // saved layouts won't load if you remove this print statement, idk why
  // tf2 coconut core
  // my best guess is that the listSync() method is broken and won't return files/folders
  // unless you've already tried to list that directory
  // essentially shrodinger's folder
  debugPrint(eventKeyDir.listSync().whereType<Directory>().map((dir) {return basename(dir.path);}).toString());
  final List<String> layoutList = eventKeyDir.listSync().whereType<Directory>().map((dir) {return basename(dir.path);}).toList();
  if (layoutList.isEmpty) {layoutList.add("No Data");}
  return layoutList;
}

List<String> getFilesInLayout(String eventKey, String layout) {
  final layoutDir = Directory("$configFolder/$eventKey/$layout");
  // DO NOT REMOVE THIS DEBUGPRINT STATEMENT!!!
  // Refer to the comment in getLayouts()
  debugPrint(layoutDir.listSync().toString());
  return layoutDir.listSync().map((file) {return basename(file.path);}).toList();
}

Future<int> saveExport() async {
  final random = Random();
  
  final layoutDirectory = Directory("$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}");
  if (!(await layoutDirectory.exists())) {
    await layoutDirectory.create(recursive: true);
  }
  late String exportName;
  switch (DataEntry.activeConfig) {
    case "Atlas":
    case "Chronos":
       exportName = "${DataEntry.exportData["teamNumber"]}_${DataEntry.exportData["matchType"]}_${DataEntry.exportData["matchNumber"]}_${random.nextInt(9999)}";
    case "Pit":
    case "Human Player":
      exportName = "${DataEntry.exportData["teamNumber"]}_${DataEntry.activeConfig.split(" ")[0]}_${random.nextInt(9999)}}";
    default:
      exportName = "${random.nextInt(9999)}";
  }
  final exportFile = File("$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}/$exportName.json");
  addToUploadQueue("$configFolder/${configData["eventKey"]}/${DataEntry.activeConfig}/$exportName.json");
  DataEntry.exportData["layout"] = DataEntry.activeConfig;
  DataEntry.exportData["exportName"] = exportName;
  DataEntry.exportData["timestamp"] = DateTime.now().toString();
  final exportDataEncoded = jsonEncode(DataEntry.exportData);
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

Map<String, dynamic> loadFile(String eventKey, String layout, String fileName) {
  return jsonDecode(File("$configFolder/$eventKey/$layout/$fileName").readAsStringSync());
}

final Map<String, String> defaultConfig = {
    "eventKey": "2025nrg",
    "scouterName": "barebonesNRG"
};
