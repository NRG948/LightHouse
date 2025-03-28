import "dart:async";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/device_id.dart";
import "package:lighthouse/filemgr.dart";
import 'package:http/http.dart' as http;
import "package:lighthouse/pages/sync.dart";
import "package:material_symbols_icons/material_symbols_icons.dart";

// a stateful widget that allows users to modify application settings.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final List<Widget> settingsList;
  @override
  void initState() {
    super.initState();
    settingsList = settingsMap.keys.map<Widget>((setting) {
      switch (settingsMap[setting]) {
        case "text":
          return SettingsTextBox(setting: setting);
        case "bool":
          return SettingsCheckbox(setting: setting);
        case "tba":
          return TBACheckbox();
        case "serverIP":
          return ServerTestWidget(width: 400,);
        default:
          return Placeholder();
      }
    }).toList();
    // Adds a button to save settings.
    //settingsList.add(SaveSettingsButton());
    // Adds a button to reset configuration.
    settingsList.add(Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),
      color: Constants.pastelWhite),
      child: TextButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            loadConfig(reset: true); //resets setting to default values
            Navigator.pushReplacementNamed(
                context, "/settings"); //reloads the setting page
          },
          child: Text("Reset Configuration",style: comfortaaBold(18,color: Colors.black),)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Creates a list of setting widgets based on configData keys.
    final screenWidth = MediaQuery.of(context).size.width; //gets screen width
    final screenHeight =
        MediaQuery.of(context).size.height; //gets screen height
    return PopScope(
      canPop: false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // App bar with back navigation and title.
          appBar: AppBar(
            iconTheme: IconThemeData(color: Constants.pastelWhite),
            backgroundColor: Constants.pastelRed,
            title: const Text(
              "Settings",
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.w900,
                  color: Constants.pastelWhite),
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                showDialog(context: context, builder: (context) {return DeviceIDDialog();},);
              }, icon: Icon(Symbols.qr_code)),
              if (configData["debugMode"] == "true")
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(configData.toString()),
                          );
                        });
                  },
                  icon: Icon(Icons.javascript))
            ],
            leading: IconButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
              if (configData["downloadTheBlueAllianceInfo"] == "true") {
                  
                  await showTBADownloadDialog(context);
                }
              // Ensures widget is still part of the tree before proceeding.
              if (!mounted) {
                return;
              } 
              if (await saveConfig() == 0) {
                // Saves settings and checks if the operation was successful.
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Successfully saved."), //confirmation message
                        actions: [
                          TextButton(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pushNamed(context,
                                    "/home-scouter"); //navigates back to home
                              },
                              child: Text("OK"))
                        ],
                      );
                    });
              } // navigates back to home
                },
                icon: Icon(Icons.home)),
          ),
          // Background container with image.
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)), // covers the entire background
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  itemCount: settingsList.length, // Number of settings widgets.
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: settingsList[index], // Displays each setting widget.
                    );
                  },
                ),
              ),
            ),
          )),
    );
  }
}

class TBACheckbox extends StatefulWidget {
  final String setting = "downloadTheBlueAllianceInfo";
  const TBACheckbox({
    super.key,
  });

  @override
  State<TBACheckbox> createState() => _TBACheckboxState();
}

class _TBACheckboxState extends State<TBACheckbox> {
  ValueNotifier enabled = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    if (!(configData.containsKey(widget.setting))) {
      configData[widget.setting] = "false";
    }
    enabled.value = configData[widget.setting] == "true";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        enabled.value = !enabled.value;
        configData[widget.setting] = enabled.value ? "true" : "false";
      },
      child: Container(
        height: 50,
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            color: Constants.pastelWhite),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(valueListenable: enabled, builder: (context,isChecked,child) {
              return Checkbox(value: isChecked, onChanged: 
             (e) {
              setState(() {
                enabled.value = !enabled.value;
                configData[widget.setting] = enabled.value ? "true" : "false";
              });  
             });
            }),
            SizedBox(
              width: 30,
              height: 30,
              child: Image(image:AssetImage("assets/images/tba_lamp.png")),
            ),
            SizedBox(width: 10,),
            SizedBox(
              width: 250,
              child: AutoSizeText("Download Event Info",style: comfortaaBold(20,color: Colors.black),maxLines: 2,))
          ],
        ),
      ),
    );
  }
}

class SettingsTextBox extends StatefulWidget {
  final String setting;
  const SettingsTextBox({
    super.key,
    required this.setting
  });

  @override
  State<SettingsTextBox> createState() => _SettingsTextBoxState();
}

class _SettingsTextBoxState extends State<SettingsTextBox> {

  @override
  void initState() {
    super.initState();
    if (!(configData.containsKey(widget.setting))) {
            configData[widget.setting] = "";
          }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110, //sets the height of the setting container
        width: 400, // sets the width of the setting container
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        //margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          spacing: 8.0, // Space between child widgets.
          children: [
            // Displays the setting name with a custom style.
            Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(settingsIconMap[widget.setting]),
                    SizedBox(width:5),
                    Text(widget.setting.toSentenceCase,
                        style: comfortaaBold(20,color: Colors.black)),
                  ],
                )),
            // TextField for modifying the setting value.
            TextField(
              controller:
                  TextEditingController(text: configData[widget.setting] ?? ""),
              onChanged: (text) {
                configData[widget.setting] = text;
              },
              decoration: InputDecoration(
                  labelText: "Enter Text",
                  labelStyle: comfortaaBold(20,color: Colors.black),
                  border:
                      OutlineInputBorder()), // Adds a border around the text field.
            )
          ],
        ));
  }
}

class SettingsCheckbox extends StatefulWidget {
  final String setting;

  const SettingsCheckbox({super.key, required this.setting});

  @override
  State<SettingsCheckbox> createState() => _SettingsCheckboxState();
}

class _SettingsCheckboxState extends State<SettingsCheckbox> {
  ValueNotifier enabled = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    if (!(configData.containsKey(widget.setting))) {
      configData[widget.setting] = "false";
    }
    enabled.value = configData[widget.setting] == "true";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        enabled.value = !enabled.value;
        configData[widget.setting] = enabled.value ? "true" : "false";
      },
      child: Container(
        height: 50,
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            color: Constants.pastelWhite),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(valueListenable: enabled, builder: (context,isChecked,child) {
              return Checkbox(value: isChecked, onChanged: 
             (e) {
              setState(() {
                enabled.value = !enabled.value;
                configData[widget.setting] = enabled.value ? "true" : "false";
              });  
             });
            }),
            Icon(settingsIconMap[widget.setting]),
            SizedBox(
              width: 200,
              child: AutoSizeText(widget.setting.toSentenceCase,style: comfortaaBold(20,color: Colors.black),maxLines: 2,))
          ],
        ),
      ),
    );
  }
}

// a stateful widget that saves the user's settings
class SaveSettingsButton extends StatefulWidget {
  const SaveSettingsButton({super.key});

  @override
  State<SaveSettingsButton> createState() => _SaveSettingsButtonState();
}

class _SaveSettingsButtonState extends State<SaveSettingsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),
      color: Constants.pastelWhite),
      child: TextButton(
          onPressed: () async {
            HapticFeedback.mediumImpact();
            if (configData["downloadTheBlueAllianceInfo"] == "true") {
                
                await showTBADownloadDialog(context);
              }
            // Ensures widget is still part of the tree before proceeding.
            if (!mounted) {
              return;
            } 
            if (await saveConfig() == 0) {
              // Saves settings and checks if the operation was successful.
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("Successfully saved."), //confirmation message
                      actions: [
                        TextButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushNamed(context,
                                  "/home-scouter"); //navigates back to home
                            },
                            child: Text("OK"))
                      ],
                    );
                  });
            }
          },
          child: Text("Save",style: comfortaaBold(18,color: Colors.black),)),
    );
  }
}

Future<bool> showTBADownloadDialog(BuildContext context) async {
  showDialog(context: context, builder: (context) {
    return TBADownloadDialog();
  });
  int? code = await TBADownloadDialog.responseCode.future;
  debugPrint("Recieved code $code");
  return Future.value(true);
}

class TBADownloadDialog extends StatefulWidget {
  const TBADownloadDialog({super.key});
  static Completer<int?> responseCode = Completer<int?>();

  void setResponseCode(int code) {
    if (!responseCode.isCompleted) {
    responseCode.complete(code);
    }
  }

  @override
  State<TBADownloadDialog> createState() => _TBADownloadDialogState();
}

class _TBADownloadDialogState extends State<TBADownloadDialog> {

  String progressIndicator = "Downloading TBA Match data for ${configData["eventKey"]}...";
  @override
  void initState() {
    super.initState();
    downloadTBAInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 600,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),
        color: Constants.pastelWhite),
        child: Row(
          children: [
            CircularProgressIndicator(color: Colors.black,),
            AutoSizeText(progressIndicator,style: comfortaaBold(10,color: Colors.black),),
          ],
        ),
      ),
    );
  }
  
  void downloadTBAInfo() async {
    http.Response responseMatches = await http.get(Uri.parse("https://www.thebluealliance.com/api/v3/event/${configData["eventKey"]}/matches/simple"),
    headers: {"X-TBA-Auth-Key":Constants.tbaAPIKey});
    http.Response responseEventInfo = await http.get(Uri.parse("https://www.thebluealliance.com/api/v3/event/${configData["eventKey"]}/simple"),
    headers: {"X-TBA-Auth-Key":Constants.tbaAPIKey});

    if (responseMatches.statusCode == 200) {
      saveTBAFile(configData["eventKey"]!,responseMatches.body,"matches");
      progressIndicator = "Downloaded Matches.";
    } else {
      setState(() {
        progressIndicator = "MATCH ERROR ${responseMatches.statusCode}: ${responseMatches.body}";
        
      });
      await Future.delayed(Duration(seconds: 1));
    }

      if (responseEventInfo.statusCode == 200) {
      saveTBAFile(configData["eventKey"]!,responseEventInfo.body,"event_info");
      progressIndicator += "\nDownloaded Event Info.";
    } else {
      setState(() {
        progressIndicator += "\nEVENT INFO ERROR ${responseEventInfo.statusCode}: ${responseEventInfo.body}";
        
      });
      await Future.delayed(Duration(seconds: 1));
    }
    widget.setResponseCode(responseMatches.statusCode);
  }
}