import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/apis/tba_api.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/device_id.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/sync.dart";
import "package:lighthouse/themes.dart";

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
        case "dropdown":
          return SettingsDropdown(
            setting: setting,
          );
        case "serverIP":
          return ServerTestWidget(
            width: 400,
          );
        default:
          return Placeholder();
      }
    }).toList();

    settingsList.add(ResetConfigurationButton());
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
            iconTheme: IconThemeData(color: context.colors.titleText),
            backgroundColor: context.colors.backgroundPrimary,
            title: Text(
              "Settings",
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.w900,
                  color: context.colors.titleText),
            ),
            centerTitle: true,
            actions: [
              AuthButton(),
              if (configData["debugMode"] == "true")
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: context.colors.container,
                              content: Text(
                                configData.toString(),
                                style: comfortaaBold(15,
                                    color: context.colors.containerText),
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.javascript,
                        color: context.colors.containerText))
            ],
            leading: IconButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  if (configData["downloadTheBlueAllianceInfo"] == "true") {
                    TbaApi.downloadAndSaveData(context);
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
                            backgroundColor: context.colors.container,
                            content: Text(
                              "Successfully saved.",
                              style: comfortaaBold(17,
                                  color: context.colors.containerText),
                            ), //confirmation message
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.pushReplacementNamed(context,
                                        "/home-scouter"); //navigates back to home
                                  },
                                  child: Text("OK",
                                      style: comfortaaBold(15,
                                          color: context.colors.accent1)))
                            ],
                          );
                        });
                  } // navigates back to home
                },
                icon: Icon(Icons.home, color: context.colors.titleText)),
          ),
          // Background container with image.
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: context.backgroundDecoration,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  itemCount: settingsList.length, // Number of settings widgets.
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child:
                          settingsList[index], // Displays each setting widget.
                    );
                  },
                ),
              ),
            ),
          )),
    );
  }
}

class ResetConfigurationButton extends StatelessWidget {
  const ResetConfigurationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          color: context.colors.container),
      child: TextButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            loadConfig(reset: true); //resets setting to default values
            ThemeController.setTheme(
                configData["theme"] ?? LightHouseThemes.themes.keys.first);
            Navigator.pushReplacementNamed(
                context, "/settings"); //reloads the setting page
          },
          child: Text(
            "Reset Configuration",
            style: comfortaaBold(18, color: context.colors.containerText),
          )),
    );
  }
}

class SettingsDropdown extends StatefulWidget {
  final String setting;
  const SettingsDropdown({super.key, required this.setting});

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    if (settingsDropdownMap[widget.setting]!
        .contains(configData[widget.setting])) {
      selectedValue =
          configData[widget.setting] ?? settingsDropdownMap[widget.setting]![0];
    } else {
      selectedValue = settingsDropdownMap[widget.setting]![0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 100,
      decoration: Constants.roundBorder(color: context.colors.container),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 150,
            height: 50,
            decoration: Constants.roundBorder(color: context.colors.muted),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  settingsIconMap[widget.setting] ?? Icons.data_object,
                  color: context.colors.container,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.setting.toSentenceCase,
                  style: comfortaaBold(18, color: context.colors.container),
                )
              ],
            ),
          ),
          Center(
            child: DropdownButton<String>(
                style: comfortaaBold(18, color: context.colors.containerText),
                dropdownColor: context.colors.container,
                value: selectedValue,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                items: (settingsDropdownMap[widget.setting] ?? []).map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: comfortaaBold(18,
                          color: context.colors.containerText),
                    ),
                  );
                }).toList(),
                onChanged: (newvalue) {
                  if (newvalue == null) {
                    return;
                  }
                  setState(() {
                    selectedValue = newvalue;
                    configData[widget.setting] = newvalue;
                    if (widget.setting == "theme") {
                      ThemeController.setTheme(configData[widget.setting] ??
                          LightHouseThemes.themes.keys.first);
                    }
                  });
                }),
          )
        ],
      ),
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
        decoration: Constants.roundBorder(color: context.colors.container),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(
                valueListenable: enabled,
                builder: (context, isChecked, child) {
                  return Checkbox(
                      value: isChecked,
                      activeColor: context.colors.accent1,
                      checkColor: context.colors.container,
                      onChanged: (e) {
                        setState(() {
                          enabled.value = !enabled.value;
                          configData[widget.setting] =
                              enabled.value ? "true" : "false";
                        });
                      });
                }),
            SizedBox(
              width: 30,
              height: 30,
              child: Image(
                image: AssetImage("assets/images/tba_lamp.png"),
                color: context.colors.containerText,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 250,
                child: AutoSizeText(
                  "Download Event Info",
                  style: comfortaaBold(20, color: context.colors.containerText),
                  maxLines: 2,
                ))
          ],
        ),
      ),
    );
  }
}

class SettingsTextBox extends StatefulWidget {
  final String setting;
  const SettingsTextBox({super.key, required this.setting});

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
            color: context.colors.container,
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
                    Icon(
                      settingsIconMap[widget.setting],
                      color: context.colors.containerText,
                    ),
                    SizedBox(width: 5),
                    Text(widget.setting.toSentenceCase,
                        style: comfortaaBold(20,
                            color: context.colors.containerText)),
                  ],
                )),
            // TextField for modifying the setting value.
            TextField(
              controller:
                  TextEditingController(text: configData[widget.setting] ?? ""),
              onChanged: (text) {
                configData[widget.setting] = text;
              },
              style: comfortaaBold(20, color: context.colors.containerText),
              decoration: InputDecoration(
                  labelText: "Enter Text",
                  labelStyle:
                      comfortaaBold(20, color: context.colors.containerText),
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
            color: context.colors.container),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(
                valueListenable: enabled,
                builder: (context, isChecked, child) {
                  return Checkbox(
                      activeColor: context.colors.accent1,
                      checkColor: context.colors.container,
                      value: isChecked,
                      onChanged: (e) {
                        setState(() {
                          enabled.value = !enabled.value;
                          configData[widget.setting] =
                              enabled.value ? "true" : "false";
                        });
                      });
                }),
            Icon(settingsIconMap[widget.setting],
                color: context.colors.containerText),
            SizedBox(
                width: 200,
                child: AutoSizeText(
                  widget.setting.toSentenceCase,
                  style: comfortaaBold(20, color: context.colors.containerText),
                  maxLines: 2,
                ))
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          color: context.colors.container),
      child: TextButton(
          onPressed: () async {
            HapticFeedback.mediumImpact();
            if (configData["downloadTheBlueAllianceInfo"] == "true") {
              TbaApi.downloadAndSaveData(context);
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
                      content:
                          Text("Successfully saved."), //confirmation message
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
          child: Text(
            "Save",
            style: comfortaaBold(18, color: Colors.black),
          )),
    );
  }
}
