import "dart:async";
import "dart:collection";
import "dart:convert";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/layouts.dart";

import "package:lighthouse/widgets/game_agnostic/barchart.dart";
import "package:lighthouse/widgets/game_agnostic/checkbox.dart";
import "package:lighthouse/widgets/game_agnostic/comment_box.dart";
import "package:lighthouse/widgets/game_agnostic/dropdown.dart";
import "package:lighthouse/widgets/game_agnostic/hint_text.dart";
import "package:lighthouse/widgets/game_agnostic/rating.dart";
import "package:lighthouse/widgets/game_agnostic/guidance_start_button.dart";
import "package:lighthouse/widgets/game_agnostic/horizontal_spacer.dart";
import "package:lighthouse/widgets/game_agnostic/match_info.dart";
import "package:lighthouse/widgets/game_agnostic/match_info_hp.dart";
import "package:lighthouse/widgets/game_agnostic/multi_spinbox.dart";
import "package:lighthouse/widgets/game_agnostic/multi_three_stage_checkbox.dart";
import "package:lighthouse/widgets/game_agnostic/placeholder.dart";
import "package:lighthouse/widgets/game_agnostic/scrollable_box.dart";
import "package:lighthouse/widgets/game_agnostic/spinbox.dart";
import "package:lighthouse/widgets/game_agnostic/start_pos.dart";
import "package:lighthouse/widgets/game_agnostic/stopwatch.dart";
import "package:lighthouse/widgets/game_agnostic/team_info.dart";
import "package:lighthouse/widgets/game_agnostic/textbox.dart";
import "package:lighthouse/widgets/game_agnostic/three_stage_checkbox.dart";
import "package:lighthouse/widgets/reefscape/atlas_teleop_selection.dart";

import "package:lighthouse/widgets/reefscape/auto_timed.dart";
import "package:lighthouse/widgets/reefscape/auto_untimed.dart";
import "package:lighthouse/widgets/reefscape/hp_teleop_selection.dart";
import "package:lighthouse/widgets/reefscape/teleop_timed.dart";

// Main widget for the Data Entry page
class DataEntry extends StatefulWidget {
  const DataEntry({super.key});
  static final Map<String, dynamic> exportData = {};
  static final Map<int, Duration> stopwatchMap = {};
  static late String activeConfig;

  @override
  State<DataEntry> createState() => DataEntryState();
}

class DataEntryState extends State<DataEntry> {
  static late double deviceWidth;
  static late double deviceHeight;

  late double resizeScaleFactorWidth;
  late double resizeScaleFactorHeight;

  static final guidanceStopwatch = Stopwatch();
  GuidanceState guidanceState = GuidanceState.setup;
  late final guidanceCheckTimer =
      Timer.periodic(Duration(milliseconds: 500), checkGuidanceState);

  int currentPage = 0;
  double startDrag = 0.0;
  late PageController controller;
  static final DESharedState sharedState = DESharedState();
  bool isUnderGuidance = false;
  // This is because stopwatches on different pages need to start
  // at different times, sooooo... the stopwatches can simply look
  // at this value...
  Duration stopwatchInitialValue = Duration(seconds: 15);

  bool hasEventKeyWarningShown = false;

  @override
  void initState() {
    super.initState();
    DataEntry.exportData.clear();
    controller = PageController(initialPage: 0);
    guidanceStopwatch.reset();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    deviceWidth = MediaQuery.sizeOf(context).width;
    deviceHeight = MediaQuery.sizeOf(context).height;
    //These are such that we can resize widgets based on screen size, but we need a reference point,
    //so we are using a 90 / 200 dp phone as the reference and scaling based upon that.
    // This is 80 by 200 now because idk?? ig it works better
    resizeScaleFactorWidth = deviceWidth / 80;
    resizeScaleFactorHeight = deviceHeight / 200;
  }

  @override
  void dispose() {
    controller.dispose();
    guidanceStopwatch.stop();
    super.dispose();
  }

  // Create a list of widgets based on the provided widget data
  List<Widget> createWidgetList(List<dynamic> widgets, [double? desireHeight]) {
    final widgetList = widgets.map((widgetData) {
      final type = widgetData["type"]!;
      if (type == "row") {
        double height = double.parse(widgetData["height"] ?? "20") *
            resizeScaleFactorHeight;
        return SizedBox(
          width: 70 * resizeScaleFactorWidth,
          height: height,
          child:
              Row(children: createWidgetList(widgetData["children"]!, height)),
        );
      }
      final title = widgetData["title"] ?? "NO TITLE";
      final jsonKey = widgetData["jsonKey"];
      if (jsonKey is List<String>) {
        for (String key in jsonKey) {
          if (!(DataEntry.exportData.containsKey(key))) {
            //DataEntry.exportData[key] = "0";
          }
        }
      } else if (jsonKey != "" &&
          jsonKey != null &&
          !(DataEntry.exportData.containsKey(jsonKey))) {
        //DataEntry.exportData[jsonKey] = "0";
      }

      double height;
      if (desireHeight != null) {
        height = desireHeight;
      } else {
        height = double.parse(widgetData["height"] ?? "20") *
            resizeScaleFactorHeight;
      }
      //We need to check this because flutter has a "default" # of pixels (regardless of device size)
      //that is sets text boxes / dropdowns to. So we need to allow for that.
      // Hard-coding this to make checkboxes smaller
      if (height < 85 && (type != "checkbox")) {
        height = 85;
      }
      final width =
          double.parse(widgetData["width"] ?? "70") * resizeScaleFactorWidth;

      final SplayTreeMap<int, double> chartData =
          widgetData["chartData"] ?? SplayTreeMap();
      final List<int> chartRemovedData = widgetData["chartRemovedData"] ?? [];
      final Color color = widgetData["color"] ?? Colors.transparent;
      final List<Color> multiColor = widgetData["multiColor"] ?? [];
      final SplayTreeMap<int, List<double>> multiChartData =
          widgetData["multiChartData"] ?? SplayTreeMap();
      final List<List<String>> comments = widgetData["comments"] ?? [[]];
      final Sort sortType = widgetData["sortType"] ?? Sort.EARLIEST;
      final bool clearable = widgetData["clearable"] ?? false;

      switch (type) {
        case "spacer":
          return NRGHorizontalSpacer(width: width);
        case "spinbox":
          return NRGSpinbox(
            title: title,
            height: height,
            width: width,
            jsonKey: jsonKey,
          );
        case "stopwatch":
          return NRGStopwatch(
            pageController: controller,
            pageIndex: currentPage,
            dataEntryState: this,
          );
        case "stopwatch-horizontal":
          return NRGStopwatch(
            pageController: controller,
            pageIndex: currentPage,
            dataEntryState: this,
            horizontal: true,
          );
        case "multispinbox":
          final List<String>? otherJsonKeys = widgetData["otherJsonKey"];
          return NRGMultiSpinbox(
            title: title,
            jsonKey: jsonKey,
            height: height,
            width: width,
            boxNames: widgetData["boxNames"] ??
                [
                  ["NO OPTIONS SPECIFIED"]
                ],
            updateOtherFields: otherJsonKeys,
            sharedState: sharedState,
          );
        case "textbox":
          final int maxLines = widgetData["maxLines"] ?? 1;
          final double fontSize = widgetData["fontSize"] ?? 20.0;
          final String? autoFill = widgetData["autoFill"];
          return NRGTextbox(
            title: title,
            jsonKey: jsonKey,
            height: height,
            width: width,
            maxLines: maxLines,
            fontSize: fontSize,
            autoFill: autoFill,
          );
        case "checkbox":
          return NRGCheckbox(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "checkbox_vertical":
          return NRGCheckbox(
              title: title,
              jsonKey: jsonKey,
              height: height,
              width: width,
              vertical: true);
        case "numberbox":
          final int maxLines = widgetData["maxLines"] ?? 1;
          final double fontSize = widgetData["fontSize"] ?? 20.0;
          return NRGTextbox(
            title: title,
            jsonKey: jsonKey,
            numeric: true,
            height: height,
            width: width,
            fontSize: fontSize,
            maxLines: maxLines,
          );
        case "dropdown":
          if (!(widgetData.containsKey("options"))) {
            return Text(
                "Widget $title doesn't have dropdown options specified.");
          }
          final options = widgetData["options"]!.split(",");
          bool compactTitle = widgetData["compactTitle"] ?? false;
          return NRGDropdown(
              title: title,
              jsonKey: jsonKey,
              options: options,
              height: height,
              width: width,
              compactTitle: compactTitle,);
        case "placeholder":
          return NRGPlaceholder(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "rsAutoUntimed":
          return RSAutoUntimed(width: deviceHeight < 740 ? 325 : width);
        case "rsAutoTimed":
          return RSAutoTimed(width: width);
        case "rsTeleopTimed":
          return RSTeleopTimed(width: width);
        case "rsAutoUntimedPit":
          return RSAutoUntimed(width: width, isPitAuto: true);
        case "barchart":
          return NRGBarChart(
              title: title,
              height: height,
              width: width,
              data: chartData,
              removedData: chartRemovedData,
              color: color,
              multiColor: multiColor,
              multiData: multiChartData);
        case "matchInfo":
          return MatchInfo(width: width);
        case "matchInfoHP":
          return MatchInfoHumanPlayer(
            width: width,
          );
        case "rating":
          return NRGRating(
            title: title,
            height: height,
            width: width,
            jsonKey: jsonKey,
            clearable: clearable,
          );
        case "startPos":
          return NRGStartPos(height: height, width: width);
        case "three-stage-checkbox":
          return NRGThreeStageCheckbox(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "multi-three-stage-checkbox":
          return NRGMultiThreeStageCheckbox(
              title: title,
              jsonKey: jsonKey,
              height: height,
              width: width,
              boxNames: widgetData["boxNames"] ??
                  [
                    ["NO OPTIONS SPECIFIED"]
                  ]);
        case "guidance-start":
          return NRGGuidanceButton(
            height: height,
            width: width,
            startGuidance: startGuidanceStopwatch,
          );
        case "comment-box":
          return NRGCommentBox(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "scrollable-box":
          return ScrollableBox(
              width: width, height: height, title: title, comments: comments);
        case "atlas-teleop":
          return AtlasTeleopSelection(width: width, height: height);
        case "hp-teleop":
          return HPTeleopSelection(height: height, width: width);
        case "team_info":
          return TeamInfo();
        case "hint-text":
          return HintText(text: title);
      }
      return Text("type $type isn't a valid type");
    }).toList();
    return widgetList;
  }

  ///returns a list of the BottomNavigationBarItems that each of the pages gives it.
  List<BottomNavigationBarItem> createNavBar(List<dynamic> pages) {
    return pages.map((page) {
      String title = page["title"];
      Icon icon = Icon(page["icon"]);
      return BottomNavigationBarItem(
        icon: icon,
        label: title,
      );
    }).toList();
  }

  List<Widget> createWidgetPages(List<Map<String, dynamic>> pages) {
    return pages.map((page) {
      final widgetList = createWidgetList(page["widgets"]);
      return Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 2 * resizeScaleFactorHeight,
            left: 2 * resizeScaleFactorWidth,
            right: 2 * resizeScaleFactorWidth,
            //bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: widgetList.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: widgetList[index],
                  ));
            },
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    DataEntry.activeConfig =
        (ModalRoute.of(context)?.settings.arguments as String?)!;
    final layoutJSON = layoutMap.containsKey(DataEntry.activeConfig)
        ? layoutMap[DataEntry.activeConfig]!
        : {};

    if (!hasEventKeyWarningShown &&
        defaultConfig["eventKey"] == configData["eventKey"]) {
      hasEventKeyWarningShown = true;
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                    padding: EdgeInsets.all(Constants.borderRadius),
                    child: Text(
                        "You are using the default event key! Go to Settings to change your event key.")),
              );
            });
      });
    }

    return PopScope(
      canPop: false,
      child: GestureDetector(
        // Allows keyboard to be closed when anywhere else is clicked on screen
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            // Prevents background image from being resized when keyboard opens
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor:themeColorPalettes[configData["theme"] ?? "Light"]![0] ,
              title: FittedBox(
                child: AutoSizeText(
                  "${DataEntry.activeConfig} - ${createNavBar(layoutJSON["pages"])[currentPage].label}",
                  style: TextStyle(
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.w900,
                      color: Constants.pastelWhite),
                  minFontSize: 4,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    showReturnDialog(context);
                  },
                  icon: Icon(Icons.home, color: Constants.pastelWhite)),
              actions: [
                if (configData["debugMode"] == "true")
                  IconButton(
                    icon: Icon(Icons.javascript, color: Constants.pastelWhite),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext) {
                            return Dialog(
                              child: Text(jsonEncode(DataEntry.exportData)),
                            );
                          });
                    },
                  ),
                IconButton(
                    onPressed: () {
                      saveJson(context);
                    },
                    icon: Icon(
                      Icons.save,
                      color: Constants.pastelWhite,
                    ))
              ],
            ),
            bottomNavigationBar: buildBottomNavBar(layoutJSON),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgrounds[configData["theme"]] ?? "assets/images/background-hires.png"),
                      fit: BoxFit.fill)),
              child: NotificationListener<OverscrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.axis == Axis.vertical) {
                    return true;
                  }
                  print(notification.overscroll);
                  if (notification.overscroll < -25) {
                    showReturnDialog(context);
                  }
                  if (notification.overscroll > 25) {
                    saveJson(context);
                  }
                  return true;
                },
                child: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    // Forces overscroll to trigger OverscrollNotification instead
                    // of allowing overscroll itself
                    // Forces overscroll to trigger OverscrollNotification instead
                    // of allowing overscroll itself
                    physics: ClampingScrollPhysics(),
                    children: createWidgetPages(layoutJSON["pages"]),
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;

                        // this tells the stopwatches what they should start
                        // counting down from.
                        switch (currentPage) {
                          case 1:
                            {
                              stopwatchInitialValue = Duration(seconds: 15);
                            }
                          case 2:
                            {
                              stopwatchInitialValue =
                                  Duration(minutes: 2, seconds: 15);
                            }
                        }
                      });
                    },
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget? buildBottomNavBar(Map<dynamic, dynamic> layoutJSON) {
    if (layoutJSON["pages"].length < 2) {
      return null;
    }
    return Theme(
      data: ThemeData(splashFactory: NoSplash.splashFactory),
      child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              if (currentPage != index) {
                HapticFeedback.mediumImpact();
              }

              isUnderGuidance = false;
              currentPage = index;

              controller.animateToPage(index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            });
          },
          unselectedIconTheme:
              IconThemeData(color: Constants.pastelWhite, size: 25),
          unselectedItemColor: Constants.pastelWhite,
          selectedIconTheme:
              IconThemeData(color: Constants.pastelWhite, size: 35),
          selectedItemColor: Constants.pastelWhite,
          currentIndex: currentPage,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: themeColorPalettes[configData["theme"] ?? "Light"]![1],
          items: createNavBar(layoutJSON["pages"])),
    );
  }

  ///Causes the [guidanceStopwatch] to be reset and start!
  ///
  ///Also resets the [guidanceState] :)
  void startGuidanceStopwatch() {
    isUnderGuidance = true;
    guidanceStopwatch.reset();
    guidanceStopwatch.start();
    guidanceState = GuidanceState.setup;
    guidanceCheckTimer;
  }

  void checkGuidanceState(Timer guidanceTimer) {
    if (guidanceStopwatch.elapsed.inSeconds >= 150 + Constants.startDelay) {
      guidanceStopwatch.stop();
      if (guidanceState != GuidanceState.endgame) {
        guidanceState = GuidanceState.endgame;
        guidanceTimer.cancel();
        isUnderGuidance = false;
        // This must come *after* guidanceState is set to what it should be.
        controller.animateToPage(guidanceState.index,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      }
    } else if (guidanceStopwatch.elapsed.inSeconds >=
        15 + Constants.startDelay) {
      if (guidanceState != GuidanceState.teleop) {
        isUnderGuidance = true;
        guidanceState = GuidanceState.teleop;
        stopwatchInitialValue = Duration(minutes: 2, seconds: 15);
        controller.animateToPage(guidanceState.index,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      }
    } else {
      if (guidanceState != GuidanceState.auto) {
        guidanceState = GuidanceState.auto;
        stopwatchInitialValue = Duration(seconds: 15);
        isUnderGuidance = true;
        // This must come *after* guidanceState is set to what it should be.
        controller.animateToPage(guidanceState.index,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      }
    }
  }
}

void saveJson(BuildContext context) async {
  HapticFeedback.mediumImpact();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "Are you sure you want to save? Please make sure your data is accurate."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No")),
            TextButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  List<String> missingFields = dataVerification();
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
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Successfully saved"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          "/home-scouter",
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text("OK"))
                              ],
                            );
                          });
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("MISSING DATA:\n$missingFields"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                },
                child: Text("Yes")),
          ],
        );
      });
}

List<String> dataVerification() {
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
  "Chronos": [
    "scouterName",
    "matchNumber",
    "teamNumber",
    "matchType",
    "driverStation",
    "dataQuality"
  ],
  "Pit": ["interviewerName", "teamNumber", "humanPlayerPreference"],
  "Human Player": [
    "scouterName",
    "matchNumber",
    "redHPTeam",
    "blueHPTeam",
    "matchType",
    "dataQuality"
  ]
};

void showReturnDialog(BuildContext context) {
  HapticFeedback.mediumImpact();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
            "Are you sure you want to return home? \n Non-saved data CANNOT be recovered!"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No")),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home-scouter", (Route<dynamic> route) => false);
            },
            child: Text("Yes"),
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
