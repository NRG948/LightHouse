import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
                ServerTestWidget(width: 360),
                SizedBox(
                  height: 10,
                ),
                UploadButton(),
                SizedBox(height: 10),
                DownloadButton(),
                SizedBox(
                  height: 10,
                ),
                StartSync()
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
            return Container(
              width: 350 * SyncPageState.sizeScaleFactor,
              height: 100 * SyncPageState.sizeScaleFactor,
              decoration: BoxDecoration(
                  color: Constants.pastelWhite,
                  borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Text(
                "Loading...",
                style: comfortaaBold(18, color: Colors.black),
              ),
            );
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
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius),
                            color: Constants.pastelGray),
                        child: Center(
                            child: Text("UPLOAD", style: comfortaaBold(25)))),
                    Text(
                        "Upload ${(snapshot.data ?? []).length} items to server",
                        style: comfortaaBold(18,
                            color: Constants.pastelBrown, bold: false))
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
      Future.delayed(Duration.zero, () {
        if (mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "No files to upload",
                    style: comfortaaBold(18, color: Constants.pastelBrown),
                  ),
                );
              });
        }
      });
      return Container(
        width: 300 * SyncPageState.sizeScaleFactor,
        height: 300 * SyncPageState.sizeScaleFactor,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Text(
          "Loading...",
          style: comfortaaBold(18, color: Colors.black),
        ),
      );
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
              child: CircularProgressIndicator(color: Colors.black),
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
          responseCodes[response.statusCode] ?? response.statusCode.toString());
    } catch (_) {
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 200 * SyncPageState.sizeScaleFactor,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                  color: Constants.pastelGray),
              child: Center(child: Text("DOWNLOAD", style: comfortaaBold(25)))),
          Text("Download Items from server",
              style:
                  comfortaaBold(18, color: Constants.pastelBrown, bold: false))
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
          style: comfortaaBold(10, color: Colors.black)));
    }
    statuses.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Downloading $currentlyDownloading",
            style: comfortaaBold(10, color: Colors.black)),
        CircularProgressIndicator(color: Colors.black)
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

class ServerTestWidget extends StatefulWidget {
  final double width;
  const ServerTestWidget({super.key, required this.width});

  @override
  State<ServerTestWidget> createState() => _ServerTestWidgetState();
}

class _ServerTestWidgetState extends State<ServerTestWidget> {
  late double scaleFactor;
  late TextEditingController controller;
  late Future<String> responseCode;
  @override
  void initState() {
    controller = TextEditingController(text: configData["serverIP"]);
    responseCode = testConnection();
    super.initState();
    scaleFactor = widget.width / 400;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400 * scaleFactor,
      height: 150 * scaleFactor,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          color: Constants.pastelWhite),
      child: Column(
        children: [
          SizedBox(
            height: 5 * scaleFactor,
          ),
          SizedBox(
            height: 25 * scaleFactor,
            width: 250 * scaleFactor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.language,
                  color: Colors.black,
                  size: 25 * scaleFactor,
                ),
                Text(
                  "Server IP",
                  style: comfortaaBold(18 * scaleFactor, color: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5 * scaleFactor,
          ),
          SizedBox(
            width: 400 * scaleFactor,
            height: 50 * scaleFactor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300 * scaleFactor,
                  height: 200 * scaleFactor,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
                        filled: true,
                        fillColor: Constants.pastelRed,
                        contentPadding: EdgeInsets.only(
                            left: 5 * scaleFactor, right: 5 * scaleFactor)),
                    style: comfortaaBold(15 * scaleFactor),
                    onChanged: (e) {
                      configData["serverIP"] = e;
                      saveConfig();
                    },
                  ),
                ),
                Container(
                  width: 50 * scaleFactor,
                  height: 50 * scaleFactor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                    color: Constants.pastelRed,
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          responseCode = testConnection();
                        });
                      },
                      icon: Icon(
                        Icons.network_ping,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10 * scaleFactor,
          ),
          FutureBuilder(
              future: responseCode,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                    height: 40 * scaleFactor,
                    width: 250 * scaleFactor,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Constants.borderRadius),
                        color: Constants.pastelGray),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: 20 * scaleFactor,
                            width: 20 * scaleFactor,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Constants.pastelBlue),
                            )),
                        Text(
                          "Waiting for response...",
                          style: comfortaaBold(15 * scaleFactor),
                        )
                      ],
                    ),
                  );
                }
                return Container(
                  height: 40 * scaleFactor,
                  width: 250 * scaleFactor,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius),
                      color: snapshot.data! == "Code 200 - OK"
                          ? Constants.pastelGreen
                          : Constants.pastelRedSuperDark),
                  child: Center(
                      child: AutoSizeText(
                    snapshot.data!,
                    style: comfortaaBold(18 * scaleFactor),
                    textAlign: TextAlign.center,
                    minFontSize: (12 * scaleFactor).truncate().toDouble(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                );
              })
        ],
      ),
    );
  }

  Future<String> testConnection() async {
    while (configData["serverIP"] == null) {
      await Future.delayed(Duration(milliseconds: 200));
    }
    String serverIP = configData["serverIP"]!.removeTrailingSlashes;
    controller.text = controller.text.removeTrailingSlashes;

    final uri = Uri.tryParse(serverIP);
    if (uri == null) {
      return "ERROR: Invalid URL";
    }
    late final dynamic response;
    try {
      response = await http.get(Uri.parse("$uri/api/atlas"));
    } catch (e) {
      return "ERROR - $e";
    }
    return "Code ${response.statusCode.toString()} - ${responseCodes[response.statusCode]}";
  }
}

class StartSync extends StatefulWidget {
  const StartSync({super.key});

  @override
  State<StartSync> createState() => _StartSyncState();
}

class _StartSyncState extends State<StartSync> {
  late double scaleFactor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaleFactor = MediaQuery.of(context).size.width / 400;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100 * scaleFactor,
        width: 350 * scaleFactor,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            color: Constants.pastelWhite),
        child: Center(
          child: Container(
            height: 70 * scaleFactor,
            width: 300 * scaleFactor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              color: Constants.pastelBlue
            ),
            child: Text("hi"),
          ),
        ));
  }
}
