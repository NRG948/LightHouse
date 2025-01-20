import "dart:collection";
import "dart:convert";
import "dart:ffi";

import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/layouts.dart";
import "package:lighthouse/widgets/game_agnostic/barchart.dart";

import "package:lighthouse/widgets/game_agnostic/checkbox.dart";
import "package:lighthouse/widgets/game_agnostic/dropdown.dart";
import "package:lighthouse/widgets/game_agnostic/horizontal_spacer.dart";
import "package:lighthouse/widgets/game_agnostic/mcq.dart";
import "package:lighthouse/widgets/game_agnostic/multi_spinbox.dart";
import "package:lighthouse/widgets/game_agnostic/multi_three_stage_checkbox.dart";
import "package:lighthouse/widgets/game_agnostic/placeholder.dart";
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
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  late double deviceWidth;
  late double deviceHeight;

  late double resizeScaleFactorWidth;
  late double resizeScaleFactorHeight;

  int currentPage = 0;
  late PageController controller;
  @override
  void initState() {
    super.initState();
    DataEntry.exportData.clear();
    controller = PageController(initialPage: 0);
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
        double height = double.parse(widgetData["height"] ?? "20") * resizeScaleFactorHeight;
        return SizedBox(
          width: 90 * resizeScaleFactorWidth,
          height: height, 
          child: Row(
              spacing: 0, children: createWidgetList(widgetData["children"]!, height)),
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
      if (desireHeight != null){
        height = desireHeight;
      } else {
        height = double.parse(widgetData["height"] ?? "20") * resizeScaleFactorHeight;
      }
      //We need to check this because flutter has a "default" # of pixels (regardless of device size)
      //that is sets text boxes / dropdowns to. So we need to allow for that. 
      if (height < 85) {
        height = 85;
      }
      final width = double.parse(widgetData["width"] ?? "70") * resizeScaleFactorWidth;

      final SplayTreeMap<int, double> chartData =
          widgetData["chartData"] ?? SplayTreeMap();
      final List<int> chartRemovedData = widgetData["chartRemovedData"] ?? [];
      final Color color = widgetData["color"] ?? Colors.transparent;
      final List<Color> multiColor = widgetData["multiColor"] ?? [];
      final SplayTreeMap<int, List<double>> multiChartData =
          widgetData["multiChartData"] ?? SplayTreeMap();
      
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
          return NRGStopwatch();
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
          return RSAutoUntimed(width: 400);
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
        case "mcq": 
          return NRGMCQ(
            title: title,
            height: height,
            width: width, 
            jsonKey: jsonKey,
          );
        case "three-stage-checkbox": 
          return NRGThreeStageCheckbox(
            title: title, 
            jsonKey: jsonKey, 
            height: height, 
            width: width
          ); 
        case "multi-three-stage-checkbox": 
          return NRGMultiThreeStageCheckbox(
            title: title, 
            jsonKey: jsonKey, 
            height: height, 
            width: width, 
            boxNames: 
              widgetData["boxNames"] ??
                  [
                    ["NO OPTIONS SPECIFIED"]
                  ]
          );
      }
      return Text("type $type isn't a valid type");
    }).toList();
    return widgetList;
  }

  ///returns a list of the BottomNavigationBarItems that each of the pages gives it.
  List<BottomNavigationBarItem> createNavBar(List<dynamic> pages) {
    return pages.map((page) {
      String title = page["title"];
      Icon icon = page["icon"];
      return BottomNavigationBarItem(icon: icon, label: title);
    }).toList();
  }

  List<Widget> createWidgetPages(List<Map<String, dynamic>> pages) {
    return pages.map((page) {
      final widgetList = createWidgetList(page["widgets"]);
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 2 * resizeScaleFactorHeight, left: 2 * resizeScaleFactorWidth, right: 2 * resizeScaleFactorWidth),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widgetList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: widgetList[index],
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
    print(DataEntry.activeConfig);
    final layoutJSON = layoutMap.containsKey(DataEntry.activeConfig)
        ? layoutMap[DataEntry.activeConfig]!
        : {};
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.pastelRed,
            title: Text(
              DataEntry.activeConfig,
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("Are you sure you want to return home? \n Non-saved data CANNOT be recovered!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, 
                          child: Text("No")
                        ), 
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);
                          }, 
                          child: Text("Yes"), 
                        ), 
                      ],
                    ); 
                  }, 
                ); 
              },
                icon: Icon(Icons.home)),
            actions: [
              IconButton(
                icon: Icon(Icons.javascript),
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
              SaveJsonButton()
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
              currentPage = index;
              controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.decelerate);
            });
          },
          unselectedIconTheme: IconThemeData(color: Colors.black),
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.black),
          selectedItemColor: Colors.black,
          currentIndex: currentPage,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constants.pastelYellow,
          items: createNavBar(layoutJSON["pages"])),
    );
  }
}

class SaveJsonButton extends StatelessWidget {
  const SaveJsonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          if (await saveExport() == 0) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("Successfully saved."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/home");
                          },
                          child: Text("OK"))
                    ],
                  );
                });
          }
        },
        child: Text("Save"));
  }
}
