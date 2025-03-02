import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lighthouse/pages/data_entry.dart';
import 'package:lighthouse/pages/saved_data.dart';

// Main widget for the Sync page
class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => SyncPageState();
}

class SyncPageState extends State<SyncPage> {
  late http.Response response;
  static late double sizeScaleFactor;
  late double screenWidth;
  late double screenHeight;

  // Fetch data from the server
  Future<void> fetchData(String requestedFileType) async {
    response = await http.get(Uri.parse("http://169.254.9.48/81"));
    if (response.statusCode == 200) {
      // Handle successful response
    } else {
      debugPrint(response.statusCode.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    sizeScaleFactor = screenWidth / 400;
    debugPrint("size scale factor: $sizeScaleFactor");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor: Constants.pastelRed,
          title: const Text(
            "Sync",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home-scouter");
              },
              icon: Icon(Icons.home)),
        ),
        body: Container(
          height: screenHeight,
          width: 400 * sizeScaleFactor,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                ),
                ServerConnectStatus(),
                SizedBox(
                  height: 10,
                ),
                UploadButton(),
                SizedBox(height: 10),
                DownloadButton()
              ],
            ),
          ),
        ));
  }
}

// Widget for the upload button
class UploadButton extends StatefulWidget {
  const UploadButton({super.key});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  late Future<List<dynamic>> uploadQueue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uploadQueue = getUploadQueue();
    return FutureBuilder(
        future: uploadQueue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Placeholder();
          }
          return Container(
            width: 350 * SyncPageState.sizeScaleFactor,
            height: 100 * SyncPageState.sizeScaleFactor,
            decoration: BoxDecoration(
                color: Constants.pastelWhite,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: TextButton(
                onPressed: () {
                  openUploadDialog(context, snapshot.data ?? []);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200 * SyncPageState.sizeScaleFactor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        color: Constants.pastelGray
                      ),
                      child: Center(child: Text("UPLOAD", style: comfortaaBold(25)))),
                    Text(
                        "Upload ${(snapshot.data ?? []).length} items to server",
                        style: comfortaaBold(18,color: Constants.pastelBrown,bold: false))
                  ],
                )),
          );
        });
  }

  // Open the upload dialog
  void openUploadDialog(BuildContext context, List<dynamic> queue) {
    showDialog(
        context: context,
        builder: (context) {
          return UploadDialog(queue: queue);
        });
  }
}

// Dialog for uploading files
class UploadDialog extends StatefulWidget {
  final List<dynamic> queue;
  const UploadDialog({super.key, required this.queue});

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  late String currentFile;
  Map<String, String> uploadedFiles = {};
  final List<dynamic> filesToKeep = [];

  @override
  void initState() {
    super.initState();
    uploadFiles();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.queue.isEmpty) {
    Navigator.pop(context);
      Future.delayed(Duration.zero,() {
        if (mounted) {
          showDialog(context: context, builder: (context) {
            return AlertDialog(content: Text("No files to upload",
            style: comfortaaBold(18,color: Constants.pastelBrown),),
            );
          });
        }
      });
      return Placeholder();
      }
    return Center(
      child: Container(
        width: 350 * SyncPageState.sizeScaleFactor,
        height: 400 * SyncPageState.sizeScaleFactor,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: ListView(
          children: buildUploadedFiles(),
        ),
      ),
    );
  }

  // Upload files to the server
  void uploadFiles() async {
    if (widget.queue.isEmpty) {
      print("queue is empty");
      currentFile = "";
      return;
    }
    currentFile = widget.queue[0];
    for (String file in widget.queue) {
      setState(() {
        currentFile = file;
      });
      String code = await uploadFile(file);
      // If file was uploaded successfully or doesn't exist, remove it from the upload queue
      if (!(code == "OK" || code == "File Missing")) {
        filesToKeep.add(file);
      }

      setState(() {
        uploadedFiles.addEntries([MapEntry(file, code)]);
      });
    }
    currentFile = "";
    // Clears upload queue (except for files that returned an error)
    setUploadQueue(filesToKeep);
    if (mounted) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/sync");
    }
    
  }

  // Build the list of uploaded files
  List<Widget> buildUploadedFiles() {
    final List<Widget> list = uploadedFiles.keys.map((key) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 350 * SyncPageState.sizeScaleFactor,
              color: uploadedFiles[key] == "OK" ? null : Colors.red,
              child: AutoSizeText(
                "${key.split("/").last} uploaded, status ${uploadedFiles[key]}",
                maxLines: 1,
              )),
        ],
      );
    }).toList();
    if (currentFile != "") {
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AutoSizeText("Uploading ${currentFile.split("/").last}"),
            SizedBox(
              height: 20 * SyncPageState.sizeScaleFactor,
              width: 20 * SyncPageState.sizeScaleFactor,
              child: CircularProgressIndicator(),
            )
          ],
        ),
      );
    }
    return list;
  } 

  // Upload a single file to the server
  Future<String> uploadFile(String fileName) async {
    await Future.delayed(Duration(milliseconds: 200));
    String fileContent = await loadFileForUpload(fileName);
    if (fileContent == "") {
      return Future.value("File Missing");
    }
    late String api;
    if (fileName.contains("Atlas")) {
      api = "atlas";
    } else if (fileName.contains("Chronos")) {
      api = "chronos";
    } else if (fileName.contains("Pit")) {
      api = "pit";
    } else if (fileName.contains("Human Player")) {
      api = "hp";
    } else {
      api = "none";
    }
    try {
      final response = await http.post(
        (Uri.tryParse("${configData["serverIP"]!}/api/$api") ?? Uri.base),
        headers: {"Content-Type": "application/json"},
        body: fileContent);
    return Future.value(
        responseCodes[response.statusCode] ?? response.statusCode.toString()); }
    catch (_) {
      print ("here");
      return Future.value("ERROR");
    }
  }
}

// Widget for the download button
class DownloadButton extends StatefulWidget {
  const DownloadButton({super.key});

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350 * SyncPageState.sizeScaleFactor,
      height: 100 * SyncPageState.sizeScaleFactor,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DownloadDialog();
              });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
                      width: 200 * SyncPageState.sizeScaleFactor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        color: Constants.pastelGray
                      ),
                      child: Center(child: Text("DOWNLOAD", style: comfortaaBold(25)))),
          Text("Download Items from server", style: comfortaaBold(18,color: Constants.pastelBrown,bold: false))
        ]),
      ),
    );
  }
}

// Dialog for downloading files
class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key});

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  Map<String, String> downloadStatuses = {};
  String currentlyDownloading = "";

  @override
  void initState() {
    super.initState();
    downloadDatabases();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350 * SyncPageState.sizeScaleFactor,
        height: 500 * SyncPageState.sizeScaleFactor,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          children: showDownloadStatuses(),
        ),
      ),
    );
  }

  // Show the download statuses
  List<Widget> showDownloadStatuses() {
    List<Widget> statuses = [];
    for (String status in downloadStatuses.keys) {
      statuses.add(Text(
          "Database $status downloaded w/ code ${downloadStatuses[status]}",
          style: comfortaaBold(10)));
    }
    statuses.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Downloading $currentlyDownloading", style: comfortaaBold(10)),
        CircularProgressIndicator()
      ],
    ));
    return statuses;
  }

  // Download databases from the server
  void downloadDatabases() async {
    for (String layout in ["Atlas", "Chronos", "Pit", "Human Player"]) {
      currentlyDownloading = layout;
      int code = await downloadDatabase(layout);
      setState(() {
        downloadStatuses.addEntries(
            [MapEntry(layout, responseCodes[code] ?? code.toString())]);
      });
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  // Download a single database from the server
  Future<int> downloadDatabase(String layout) async {
    await Future.delayed(Duration(milliseconds: 100));
    late String api;
    if (layout == "Atlas") {
      api = "atlas";
    } else if (layout == "Chronos") {
      api = "chronos";
    } else if (layout == "Pit") {
      api = "pit";
    } else if (layout == "Human Player") {
      api = "hp";
    } else {
      api = "none";
    }
    final response = await http.get(
      (Uri.tryParse("${configData["serverIP"]!}/api/$api") ?? Uri.base),
      headers: {"Content-Type": "application/json"},
    );
    saveDatabaseFile(configData["eventKey"] ?? "", layout, response.body);
    return Future.value(0);
  }
}

// Widget to display the server connection status
class ServerConnectStatus extends StatefulWidget {
  const ServerConnectStatus({super.key});

  @override
  State<ServerConnectStatus> createState() => _ServerConnectStatusState();
}

class _ServerConnectStatusState extends State<ServerConnectStatus> {
  final controller = TextEditingController();
  late Future<String> responseCode;

  @override
  void initState() {
    super.initState();
    controller.text = configData["serverIP"] ?? "";
    responseCode = testConnection(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350 * SyncPageState.sizeScaleFactor,
      height: 150 * SyncPageState.sizeScaleFactor,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 250 * SyncPageState.sizeScaleFactor,
                  height: 50 * SyncPageState.sizeScaleFactor,
                  child: TextField(
                    autocorrect: false,
                    controller: controller,
                    decoration: InputDecoration(
                      fillColor: Constants.pastelRed,
                      filled: true,
                      labelText: "Server IP",
                    ),
                  ),
                ),
                Container(
                    width: 50 * SyncPageState.sizeScaleFactor,
                    height: 50 * SyncPageState.sizeScaleFactor,
                    decoration: BoxDecoration(
                        color: Constants.pastelRed,
                        borderRadius:
                            BorderRadius.circular(Constants.borderRadius)),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            configData["serverIP"] = controller.text;
                            saveConfig();
                            responseCode = testConnection(controller.text);
                          });
                        },
                        child: Text("GO", style: comfortaaBold(10)))),
              ],
            ),
            FutureBuilder(
                future: responseCode,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Attempting Connection...",
                          style: comfortaaBold(18,
                              color: Constants.pastelBrown),
                        ),
                        CircularProgressIndicator()
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Recieved code ${snapshot.data}",
                          style: comfortaaBold(18,
                              color: Constants.pastelBrown),
                        ),
                        Container(
                          width: 30 * SyncPageState.sizeScaleFactor,
                          height: 30 * SyncPageState.sizeScaleFactor,
                          decoration: BoxDecoration(
                              color: snapshot.data == "200"
                                  ? Colors.lightGreen
                                  : Colors.red,
                              shape: BoxShape.circle),
                        )
                      ],
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  // Test the connection to the server
  Future<String> testConnection(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return "";
    }
    late final dynamic response;
    try {response = await http.get(uri);}
    catch (_) {
      print(_);
      return "problem";
    }
    return response.statusCode.toString();
  }
}
