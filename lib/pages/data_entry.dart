import "dart:async";
import "dart:collection";
import "dart:convert";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/layouts.dart";
import "package:lighthouse/widgets/game_agnostic/barchart.dart";

import "package:lighthouse/widgets/game_agnostic/checkbox.dart";
import "package:lighthouse/widgets/game_agnostic/dropdown.dart";
import "package:lighthouse/widgets/game_agnostic/guidance_start_button.dart";
import "package:lighthouse/widgets/game_agnostic/horizontal_spacer.dart";
import "package:lighthouse/widgets/game_agnostic/match_info.dart";
import "package:lighthouse/widgets/game_agnostic/mcq.dart";
import "package:lighthouse/widgets/game_agnostic/multi_spinbox.dart";
import "package:lighthouse/widgets/game_agnostic/multi_three_stage_checkbox.dart";
import "package:lighthouse/widgets/game_agnostic/placeholder.dart";
import "package:lighthouse/widgets/game_agnostic/scrollable_box.dart";
import "package:lighthouse/widgets/game_agnostic/spinbox.dart";
import "package:lighthouse/widgets/game_agnostic/stopwatch-horizontal.dart";
import "package:lighthouse/widgets/game_agnostic/stopwatch.dart";
import "package:lighthouse/widgets/game_agnostic/textbox.dart";
import "package:lighthouse/widgets/game_agnostic/three_stage_checkbox.dart";

import "package:lighthouse/widgets/reefscape/auto_untimed.dart";

class DataEntry extends StatefulWidget {
  const DataEntry({super.key});
  static final Map<String, dynamic> exportData = {};
  static late String activeConfig;
  @override
  State<DataEntry> createState() => DataEntryState();
}

class DataEntryState extends State<DataEntry> {
  late double deviceWidth;
  late double deviceHeight;

  late double resizeScaleFactorWidth;
  late double resizeScaleFactorHeight;

  final guidanceStopwatch = Stopwatch();
  GuidanceState guidanceState = GuidanceState.setup;
  late final guidanceCheckTimer =
      Timer.periodic(Duration(milliseconds: 500), checkGuidanceState);

  int currentPage = 0;
  double startDrag = 0.0;
  late PageController controller;

  bool isUnderGuidance = false;
  // This is because stopwatches on different pages need to start 
  // at different times, sooooo... the stopwatches can simply look
  // at this value...
  Duration stopwatchInitialValue = Duration(seconds: 15);
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
    resizeScaleFactorWidth = deviceWidth / 90;
    resizeScaleFactorHeight = deviceHeight / 200;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> createWidgetList(List<dynamic> widgets, [double? desireHeight]) {
    final widgetList = widgets.map((widgetData) {
      final type = widgetData["type"]!;
      if (type == "row") {
        double height = double.parse(widgetData["height"] ?? "20") *
            resizeScaleFactorHeight;
        return SizedBox(
          width: 90 * resizeScaleFactorWidth,
          height: height,
          child: Row(
              spacing: 0,
              children: createWidgetList(widgetData["children"]!, height)),
        );
      }
      final title = widgetData["title"] ?? "NO TITLE";
      final jsonKey = widgetData["jsonKey"];
      if (jsonKey is List<String>) {
        for (String key in jsonKey) {
          if (!(DataEntry.exportData.containsKey(key))) {
            DataEntry.exportData[key] = "0";
          }
        }
      } else if (jsonKey != "" &&
          jsonKey != null &&
          !(DataEntry.exportData.containsKey(jsonKey))) {
        DataEntry.exportData[jsonKey] = "0";
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
          return NRGStopwatchHorizontal();
        case "multispinbox":
          return NRGMultiSpinbox(
              title: title,
              jsonKey: jsonKey,
              height: height,
              width: width,
              boxNames: widgetData["boxNames"] ??
                  [
                    ["NO OPTIONS SPECIFIED"]
                  ]);
        case "textbox":
          return NRGTextbox(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "checkbox":
          return NRGCheckbox(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "numberbox":
          return NRGTextbox(
              title: title,
              jsonKey: jsonKey,
              numeric: true,
              height: height,
              width: width);
        case "dropdown":
          if (!(widgetData.containsKey("options"))) {
            return Text(
                "Widget $title doesn't have dropdown options specified.");
          }
          final options = widgetData["options"]!.split(",");
          return NRGDropdown(
              title: title,
              jsonKey: jsonKey,
              options: options,
              height: height,
              width: width);
        case "placeholder":
          return NRGPlaceholder(
              title: title, jsonKey: jsonKey, height: height, width: width);
        case "rsAutoUntimed":
          return RSAutoUntimed(width: width);
        case "rsAutoUntimedPit":
          return RSAutoUntimed(width: width, pit:true);
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
        case "mcq": 
          return NRGMCQ(
            title: title,
            height: height,
            width: width,
            jsonKey: jsonKey,
          );
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
        case "scrollable-box":
          return ScrollableBox(
              width: width,
              height: height,
              title: title,
              comments: comments,
              sort: sortType);
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
              right: 2 * resizeScaleFactorWidth),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widgetList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(child: widgetList[index],)
              );
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
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.pastelRed,
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
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.fill)),
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward &&
                    notification.metrics.pixels <= 0.0) {
                  showReturnDialog(context);
                }
                if (notification.direction == ScrollDirection.reverse &&
                    notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent) {
                  saveJson(context);
                }
                return true;
              },
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                children: createWidgetPages(layoutJSON["pages"]),
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            ),
          )),
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
              isUnderGuidance = false;
              currentPage = index;
              // this tells the stopwatches what they should start
              // counting down from. 
              switch (currentPage) {
                case 1: {
                  stopwatchInitialValue = Duration(seconds: 15);
                }
                case 2: {
                  stopwatchInitialValue = Duration(minutes: 2, seconds: 15);
                }
              }

              controller.animateToPage(index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            });
          },
          unselectedIconTheme: IconThemeData(color: Constants.pastelWhite, size: 25),
          unselectedItemColor: Constants.pastelWhite,
          selectedIconTheme: IconThemeData(color: Constants.pastelWhite, size: 35),
          selectedItemColor: Constants.pastelWhite,
          currentIndex: currentPage,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constants.pastelYellow,
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
    if (guidanceStopwatch.elapsed.inSeconds >= 135 + Constants.startDelay) {
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
                  if (await saveExport() == 0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Successfully saved"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/home-scouter");
                                  },
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

void showReturnDialog(BuildContext context) {
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
