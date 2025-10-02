import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';
import 'package:lighthouse/widgets/game_agnostic/star_display.dart';
import 'package:lighthouse/widgets/reefscape/auto_reef_view.dart';

class AmongViewIndividual extends StatefulWidget {
  const AmongViewIndividual({super.key});

  @override
  State<AmongViewIndividual> createState() => _AmongViewIndividualState();
}

class _AmongViewIndividualState extends State<AmongViewIndividual>
    with TickerProviderStateMixin {
  static late double scaleFactor;
  late AVISharedState state;
  static late ValueNotifier<bool> sortCheckbox;
  late ScrollController barScrollController;
  late ScrollController matchScrollController;
  late ScrollController pitScrollController;
  late TabController matchPitController;
  late double chartWidth;
  late bool forceRunOnce;

  @override
  void initState() {
    super.initState();
    state = AVISharedState();
    barScrollController = ScrollController();
    matchScrollController = ScrollController();
    pitScrollController = ScrollController();
    sortCheckbox = ValueNotifier<bool>(false);
    forceRunOnce = true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    matchPitController = TabController(
        length: 2,
        vsync: this,
        initialIndex:
            (ModalRoute.of(context)?.settings.arguments as List<int>)[1]);
    if (forceRunOnce) {
      state.activeTeam =
          (ModalRoute.of(context)?.settings.arguments as List<int>)[0];
      state.setActiveEvent(configData["eventKey"]!);
      state.getEnabledLayouts();
      if (state.enabledLayouts.isNotEmpty) {
        state.setDQThreshold(0.0);
        state.setActiveLayout(state.enabledLayouts[0]);
        state.setActiveSortKey(
            sortKeys[state.enabledLayouts[0]]!.keys.toList()[0]);
        state.loadPitData();
        state.addListener(() {
          setState(() {});
        });
        state.updateChartData(
            sort: _AmongViewIndividualState.sortCheckbox.value);
      }
      forceRunOnce = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    chartWidth = state.matchesForTeam.length < 5
        ? 350
        : state.matchesForTeam.length * 75;
    if (state.enabledLayouts.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back)),
          ),
          body: Text("No data. i'm actually impressed that you got here",
              style: comfortaaBold(18, color: Constants.pastelBrown)));
    }

    state.activeTeam =
        (ModalRoute.of(context)?.settings.arguments as List<int>)[0];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.primaryColor(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor:
              themeColorPalettes[configData["theme"] ?? "Dark"]![0],
          title: Text(
            "Team ${state.activeTeam} - AmongView",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Constants.pastelWhite),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/data-viewer-amongview",
                  (route) => false,
                );
              },
              icon: Icon(Icons.arrow_back_ios_new)),
          actions: [AVIDQFilterDropdown(state: state)],
        ),
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgrounds[configData["theme"]] ??
                        "assets/images/background-hires-dark.png"),
                    fit: BoxFit.cover)),
            child: Center(
              child: SizedBox(
                width: 375 * scaleFactor,
                child: ListView(
                  children: [
                  Container(
                      height: 0.85 * screenHeight,
                      decoration: BoxDecoration(
                          color: Constants.pastelWhite,
                          borderRadius:
                              BorderRadius.circular(Constants.borderRadius)),
                      child: Column(children: [
                        SizedBox(height: 10,),
                            Container(
                              width: 325 * scaleFactor,
                              height: 40 * scaleFactor,
                              decoration: Constants.roundBorder(color: Constants.primaryColor()),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today,color: Constants.pastelWhite,),
                                  // Truncating to 12 characters should never be a problem
                                  // I checked, the longest-recorded FRC event key (2025sunshow) is 11 characters
                                  Text(trunc(configData["eventKey"]??"",12),style: comfortaaBold(18),),
                                  SizedBox(width: 15,),
                                  Icon(Icons.filter_alt,color: Constants.pastelWhite,),
                                  StarDisplay(starRating: AVISharedState.dataQualityThreshold)
                                ],
                              ),
                            ),
                        SizedBox(height: 5,),
                        Container(
                          width: 325 * scaleFactor,
                          height: 40 * scaleFactor,
                          decoration: Constants.roundBorder(color: Constants.primaryColor()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.dashboard,color: Constants.pastelWhite,),
                              DropdownButton(
                                  borderRadius:
                                      BorderRadius.circular(Constants.borderRadius),
                                  value: state.activeLayout,
                                  dropdownColor: Constants.primaryColor(),
                                  items: state.enabledLayouts.map((e) {
                                    return DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.toSentenceCase,
                                          style:
                                              comfortaaBold(18, color: Constants.pastelWhite),
                                        ));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      state.setActiveLayout(newValue ?? "");
                                    });
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        if (state.getSortKeys().contains(state.activeSortKey))
                          Container(
                            width: 325 * scaleFactor,
                            height: 40 * scaleFactor,
                            decoration: Constants.roundBorder(color: Constants.primaryColor()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.sort,color: Constants.pastelWhite,),
                                DropdownButton(
                                    borderRadius:
                                        BorderRadius.circular(Constants.borderRadius),
                                    value: state.activeSortKey,
                                    dropdownColor: Constants.primaryColor(),
                                    items: state.getSortKeys().map((e) {
                                      return DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e.toSentenceCase,
                                            style: comfortaaBold(12,
                                                color: Constants.pastelWhite),
                                          ));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        state.setActiveSortKey(newValue ?? "");
                                      });
                                    }),
                              ],
                            ),
                          ),
                        SizedBox(height: 5,),
                        GestureDetector(
                          onTap: () {
                            sortCheckbox.value = !sortCheckbox.value;
                            setState(() {
                              state.updateChartData(sort: sortCheckbox.value);
                            });
                          },
                          child: Container(
                            width: 325 * scaleFactor,
                            height: 40 * scaleFactor,
                            decoration: BoxDecoration(
                                color: Constants.primaryColor(),
                                borderRadius:
                                    BorderRadius.circular(Constants.borderRadius)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: sortCheckbox,
                                    builder: (a, b, c) {
                                      return Checkbox(
                                          value: b,
                                          onChanged: (value) {
                                            sortCheckbox.value = value ?? false;
                                            setState(() => state.updateChartData(
                                                sort: sortCheckbox.value));
                                          });
                                    }),
                                Icon(Icons.bar_chart,color: Constants.pastelWhite,),
                                SizedBox(width: 10,),
                                SizedBox(
                                  height: 40 * scaleFactor,
                                  child: Center(
                                      child: AutoSizeText(
                                    "Sort by Rankings",
                                    style: comfortaaBold(18 * scaleFactor),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.3 * screenHeight,
                          width: 350 * scaleFactor,
                          child: Scrollbar(
                            thumbVisibility: true,
                            interactive: true,
                            controller: barScrollController,
                            child: ListView(
                                controller: barScrollController,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  NRGBarChart(
                                    title: state.activeSortKey.toSentenceCase,
                                    height: 0.3 * screenHeight,
                                    width: chartWidth * scaleFactor,
                                    data: state.chartData,
                                    removedData: state.removedData,
                                    color: Constants.primaryColor(),
                                    hashMap: state.hashMap,
                                    amongviewMatches: state.matchesForTeam,
                                    chartOnly: true,
                                    sharedState: state,
                                  ),
                                ]),
                          ),
                        ),
                        TabBar(controller: matchPitController, tabs: [
                          Tab(
                            text: "MATCH",
                          ),
                          Tab(
                            text: "PIT",
                          )
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 400 * scaleFactor,
                            height: 0.25 * screenHeight,
                            child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: matchPitController,
                                children: [
                                  Container(
                                    height: 0.3 * screenHeight,
                                    width: 350 * scaleFactor,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Constants.borderRadius),
                                        border: Border.all(width: scaleFactor * 2)),
                                    child: (state.clickedMatch == null)
                                        ? Center(
                                          child: Text("No match selected",
                                              style: comfortaaBold(30,color: Constants.pastelGray),textAlign: TextAlign.center,),
                                        )
                                        : buildMatchData(context),
                                  ),
                                  Container(
                                      height: 0.3 * screenHeight,
                                      width: 350 * scaleFactor,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Constants.borderRadius),
                                          border:
                                              Border.all(width: scaleFactor * 2)),
                                      child: state.pitData.isEmpty
                                          ? Text("No pit data",
                                              style: comfortaaBold(10))
                                          : buildMatchData(context, pit: true))
                                ]),
                          ),
                        ),
                      ])),
                ]),
              ),
            )));
  }

  Widget buildMatchData(BuildContext context, {bool pit = false}) {
    dynamic match = {};
    if (pit) {
      match = state.pitData;
    } else {
      for (dynamic i in state.data) {
        if (i["matchType"] == getParsedMatchInfo(state.clickedMatch!)[0] &&
            i["matchNumber"] == getParsedMatchInfo(state.clickedMatch!)[1]) {
          match = i;
        }
      }
    }
    if (match == {}) {
      return Text("how did you get here? email infotech@nrg948.com",
          style: comfortaaBold(10));
    }

    List<Widget> listViewChildren = [
      Text(
        pit
            ? "Team ${match["teamNumber"]} Pit Data"
            : "Team ${match["teamNumber"]} ${match["matchType"]} ${match["matchNumber"]}",
        textAlign: TextAlign.center,
        style: comfortaaBold(18, color: Constants.pastelBrown),
      ),
    ];
    String layout = pit ? "Pit" : state.activeLayout;
    for (String i in displayKeys[layout].keys) {
      switch (displayKeys[layout][i]) {
        case "raw":
          listViewChildren.add(AutoSizeText(
            "${i.toSentenceCase}: ${match[i].toString()}",
            style:
                comfortaaBold(14 * scaleFactor, color: Constants.pastelBrown),
          ));
        case "replay":
          if (match["replay"] == true) {
            listViewChildren.add(Container(
              width: 300,
              height: 50,
              decoration: Constants.roundBorder(color: Colors.red),
              child: Center(child: Text("REPLAY",style: comfortaaBold(18),textAlign: TextAlign.center,)),
            ));
          }
        case "name_DS_DQ":
          listViewChildren.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Icon(Icons.person,color: Colors.black,),
            SizedBox(
              width: 100,
              child: AutoSizeText(
                match["scouterName"],
                maxLines: 1,
                textAlign: TextAlign.center,
                style: comfortaaBold(18,color: Colors.black),),
            ),
            Container(
              width: 80,
              height: 30,
              decoration: Constants.roundBorder(color: match["driverStation"][0] == "R" ? Constants.pastelRed : Constants.pastelBlue),
              child: Center(child: Text(match["driverStation"],style: comfortaaBold(18),textAlign: TextAlign.center,)),
            ),
            StarDisplay(starRating: match["dataQuality"].toDouble())
          ],));
        case "teleopScoring":
          listViewChildren.add(Row(
            children: [
              SizedBox(width: 5,),
              Text("Teleop",style: comfortaaBold(22,color: Colors.black),textAlign: TextAlign.start,),
            ],
          ),);
          listViewChildren.add(Center(
            child: Column(
              children: [
                Text("Coral Pickups: ${match["coralPickups"]}",style: comfortaaBold(18,color: Colors.black),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (i) {
                  return Text("L${i+1}: ${match["coralScoredL${i+1}"]}",style: comfortaaBold(22,color: Constants.reefColors[i]),);
                }))
              ],
            ),
          ));
          listViewChildren.add(Center(
            child: Column(
              children: [
                Text("Algae Removed: ${match["algaeRemove"]}",style: comfortaaBold(18,color: Colors.black),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ["Processor","Net"].map((i) {
                  return Text("$i: ${match["algaeScore$i"]}",style: comfortaaBold(22,color: Constants.reefColors[4]),);
                }).toList())
              ],
            ),
          ));       
        case "autoMatch":
          if (match["hasNoAuto"] == true) {
            listViewChildren.add(Container(
              width: 300,
              height: 40,
              decoration: Constants.roundBorder(color: Colors.red),
              child: Center(child: Text("NO AUTO",style: comfortaaBold(18),textAlign: TextAlign.center,)),
            ));
          } else {
          listViewChildren.add(AutoReefView(
                height: 170,
                width: 150,
                scouterNames: ["Auto"],
                matchNumber: null,
                dataQuality: null,
                reef: AutoReef(
                    scores: List<String>.from(match["autoCoralScored"]),
                    algaeRemoved: List<String>.from(match["autoAlgaeRemoved"]),
                    troughCount: int.tryParse("autoCoralScoredL1") ?? 0,
                    groundIntake: match["groundIntake"],
                    bargeCS: match["bargeCS"],
                    processorCS: match["processorCS"]),
                startingPosition: List<double>.from(match["startingPosition"].split(",").map((i) => double.tryParse(i) ?? 0.0).toList()),
                flipStartingPosition: match["driverStation"][0] == "R",
                hasNoAuto: false));
          }

        case "autoPit":
          for (dynamic auto in match["auto"]) {
            listViewChildren.add(AutoReefView(
                height: 170,
                width: 150,
                scouterNames: ["Auto"],
                matchNumber: match["auto"].indexOf(auto) + 1,
                dataQuality: null,
                reef: AutoReef(
                    scores: List<String>.from(auto["autoCoralScored"]),
                    algaeRemoved: List<String>.from(auto["autoAlgaeRemoved"]),
                    troughCount: int.tryParse("autoCoralScoredL1") ?? 0,
                    groundIntake: auto["groundIntake"],
                    bargeCS: auto["bargeCS"],
                    processorCS: auto["processorCS"]),
                pit: true,
                startingPosition: [0.0, 0.0],
                flipStartingPosition: false,
                hasNoAuto: false));

           
          }
      }
    }

    return Container(
      decoration: Constants.roundBorder(
        color: pit
            ? Constants.pastelWhite
            : (match["dataQuality"] ?? 0.0) >=
                    AVISharedState.dataQualityThreshold
                ? Constants.pastelWhite
                : Colors.red,
      ),
      child: Scrollbar(
        controller: pit ? pitScrollController : matchScrollController,
        interactive: true,
        thumbVisibility: true,
        thickness: 10 * scaleFactor,
        child: ListView(
          controller: pit ? pitScrollController : matchScrollController,
          children: listViewChildren,
        ),
      ),
    );
    //return Text("Showing ${getParsedMatchInfo(state.clickedMatch ?? 0)[0]} ${getParsedMatchInfo(state.clickedMatch ?? 0)[1]} for team ${state.activeTeam}");
  }
}

class AVISharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late String activeSortKey;
  static late double dataQualityThreshold;
  late int activeTeam;
  List<String> enabledLayouts = [];
  late List<int> matchesForTeam = [];
  late List<dynamic> data;
  List<int> removedData = [];
  Map pitData = {};
  SplayTreeMap<int, double> chartData = SplayTreeMap();
  LinkedHashMap<int, double>? hashMap;
  int? clickedMatch;

  void setClickedMatch(int match) {
    clickedMatch = match;
    notifyListeners();
  }

  void getEnabledLayouts() {
    for (String i in ["Atlas", "Chronos", "Human Player"]) {
      if (loadDatabaseFile(activeEvent, i) != "" &&
          !enabledLayouts.contains(i)) {
        enabledLayouts.add(i);
      }
    }
  }

  void setActiveEvent(String event) {
    activeEvent = event;
    notifyListeners();
  }

  void setActiveLayout(String layout) async {
    activeLayout = layout;
    loadDatabase();
    setActiveSortKey(sortKeys[activeLayout]!.keys.toList()[0]);
    notifyListeners();
  }

  void setDQThreshold(double threshold) {
    dataQualityThreshold = threshold;
    notifyListeners();
  }

  void setActiveSortKey(String key) {
    activeSortKey = key;
    updateChartData(sort: _AmongViewIndividualState.sortCheckbox.value);
    notifyListeners();
  }

  void updateChartData({bool? sort}) {
    chartData.clear();
    matchesForTeam.clear();
    removedData.clear();
    for (dynamic match in data) {
      if (!(matchesForTeam.contains(getParsedMatchNumber(match)))) {
        matchesForTeam.add(getParsedMatchNumber(match));
      }
      if (match["dataQuality"] < dataQualityThreshold) {
        removedData.add(getParsedMatchNumber(match));
      }
    }
    matchesForTeam.sort((a, b) => a.compareTo(b));
    switch (sortKeys[activeLayout][activeSortKey]) {
      case "raw":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(
                getParsedMatchNumber(match), match[activeSortKey]!.toDouble())
          ]);
        }
      case "climb":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(
                getParsedMatchNumber(match),
                (match["endLocation"] == "Deep Climb" ||
                        match["endLocation"] == "Shallow Climb")
                    ? 1
                    : 0)
          ]);
        }
      case "viewAllMatches":
        for (dynamic match in data) {
          chartData.addEntries([MapEntry(getParsedMatchNumber(match), 1.0)]);
        }
      case "totalraw":
        Map<String, List<String>> searchTerms = {
          "coralScoredTotal": [
            "coralScoredL1",
            "coralScoredL2",
            "coralScoredL3",
            "coralScoredL4"
          ]
        };
        for (dynamic match in data) {
          double total = 0;
          for (String term in searchTerms[activeSortKey]!) {
            total += match[term]!;
          }
          chartData.addEntries([MapEntry(getParsedMatchNumber(match), total)]);
        }
      case "rawboolean":
        for (dynamic match in data) {
          if (match[activeSortKey.removeAfterSpace]! == true) {
            chartData.addEntries([MapEntry(getParsedMatchNumber(match), 1.0)]);
          } else {
            chartData.addEntries([MapEntry(getParsedMatchNumber(match), 0.0)]);
          }
        }
      case "rawbyitems":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(getParsedMatchNumber(match),
                match[activeSortKey]!.length.toDouble())
          ]);
        }
      case "hpraw":
        for (dynamic match in data) {
          if (match["redHPTeam"]! == activeTeam &&
              activeSortKey.contains("red")) {
            chartData.addEntries([
              MapEntry(
                  getParsedMatchNumber(match), match[activeSortKey].toDouble())
            ]);
          }
          if (match["blueHPTeam"]! == activeTeam &&
              activeSortKey.contains("blue")) {
            chartData.addEntries([
              MapEntry(
                  getParsedMatchNumber(match), match[activeSortKey].toDouble())
            ]);
          }
        }
      case "cycleTime":
        List searchTerms = [];
        if (activeSortKey.contains("Reef")) {
          searchTerms = ["AB", "CD", "EF", "GH", "IJ", "KL"];
        } else if (activeSortKey.contains("CS")) {
          searchTerms = ["BargeCS", "ProcessorCS"];
        } else if (activeSortKey.contains("Processor")) {
          searchTerms = ["Processor"];
        }

        for (dynamic match in data) {
          final List fullEventList;
          final List filteredEventList = [];
          if (activeSortKey.contains("Auto")) {
            fullEventList = match["autoEventList"]!;
          } else if (activeSortKey.contains("Teleop")) {
            fullEventList = match["teleopEventList"]!;
          } else {
            fullEventList = [];
          }
          for (List event in fullEventList) {
            if (searchTerms.any(
                (e) => (event[0] == "enter$e") || (event[0] == "exit$e"))) {
              filteredEventList.add(event);
            }
          }
          List<double> timeDiffs = [];
          //  Iterates through every other event (only the enter area events)
          for (int eventIndex = 0;
              eventIndex < filteredEventList.length;
              eventIndex = eventIndex + 2) {
            // Accounts for edge case in which last enter event has no corresponding exit event
            if (eventIndex == filteredEventList.length - 1) {
              continue;
            }
            // Gets time difference between this event (enter) and next event (exit)
            timeDiffs.add(filteredEventList[eventIndex + 1][1] -
                filteredEventList[eventIndex][1]);
          }
          if (timeDiffs.isNotEmpty) {
            chartData.addEntries([
              MapEntry(getParsedMatchNumber(match),
                  (timeDiffs.sum / timeDiffs.length).fourDigits)
            ]);
          }
        }
    }
    if (sort == true) {
      List<MapEntry<int, double>> sortedEntries = chartData.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      hashMap = LinkedHashMap<int, double>.fromEntries(sortedEntries);
      matchesForTeam = hashMap != null ? hashMap!.keys.toList() : [];
    } else {
      hashMap = null;
      matchesForTeam.sort();
    }
  }

  List<String> getSortKeys() {
    return sortKeys[activeLayout]!.keys.toList();
  }

  void loadDatabase() {
    data = jsonDecode(loadDatabaseFile(activeEvent, activeLayout));
    // Creates a buffer file to avoid concurrent access errors
    List<dynamic> tempData = [];
    for (dynamic i in data) {
      if (activeLayout != "Human Player") {
        if (i["teamNumber"]! == activeTeam) {
          tempData.add(i);
        }
      } else {
        if (i["redHPTeam"]! == activeTeam) {
          tempData.add(i);
        }
        if (i["blueHPTeam"]! == activeTeam) {
          tempData.add(i);
        }
      }
    }
    data = tempData;
  }

  void loadPitData() {
    List<dynamic> allPitData = [];
    if (loadDatabaseFile(activeEvent, "Pit") == "") {
      return;
    }
    allPitData = jsonDecode(loadDatabaseFile(activeEvent, "Pit"));
    if (allPitData.isEmpty) {
      return;
    }
    for (dynamic i in allPitData) {
      if (int.parse(i["teamNumber"]) == activeTeam) {
        pitData = i;
      }
    }
  }
}

// These keys are used by the chart to determine how to parse data
Map<String, dynamic> sortKeys = {
  "Atlas": {
    "viewAllMatches": "viewAllMatches",
    "coralPickups": "raw",
    "coralScoredTotal": "totalraw",
    "coralScoredL1": "raw",
    "coralScoredL2": "raw",
    "coralScoredL3": "raw",
    "coralScoredL4": "raw",
    "algaePickups": "raw",
    "algaeRemove": "raw",
    "algaeScoreProcessor": "raw",
    "algaeScoreNet": "raw",
    "climbStartTime": "raw",
    "climbedInMatch": "climb",
    "bargeCS Used in Auto": "rawboolean",
    "processorCS Used in Auto": "rawboolean",
    "hasNoAuto": "rawboolean",
    "groundIntake in Auto": "rawboolean",
    "autoCoralScored": "rawbyitems",
    "autoAlgaeRemoved": "rawbyitems",
  },
  "Chronos": {
    "Auto Reef Cycle Time": "cycleTime",
    "Auto CS Cycle Time": "cycleTime",
    "Teleop Reef Cycle Time": "cycleTime",
    "Teleop CS Cycle Time": "cycleTime",
    "Teleop Processor Cycle Time": "cycleTime",
  },
  "Human Player": {
    "redScore": "hpraw",
    "blueScore": "hpraw",
    "redMiss": "hpraw",
    "blueMiss": "hpraw",
    "redNetAlgae": "hpraw",
    "blueNetAlgae": "hpraw"
  }
};

// This map is used by the individual match viewer and pit scouting viewer to figure out how to display items
// Necessary for more complex data types like event lists
Map<String, dynamic> displayKeys = {
  "Atlas": {
    // Name, driver station, data quality
    "name_DS_DQ" : "name_DS_DQ",
    "replay": "replay",
    "autoMatch": "autoMatch",
    "teleopScoring" : "teleopScoring",
    "endLocation": "raw",
    "attemptedClimb": "raw",

    // TODO: Find a way to add a "seconds" label to this maybe?
    // we could spaghetti-code this w/ an if-else statement
    // or have a more elegant solution
    "climbStartTime": "raw",

    "robotDisabled": "raw",
    "robotDisableReason": "raw",
    "comments": "raw",
    "crossedMidline": "raw",
    "timestamp": "raw"
  },
  "Chronos": {
    "scouterName": "raw",
    "replay": "raw",
    "driverStation": "raw",

    // TODO: Change this
    "startingPosition": "raw",

    // TODO: Change these
    "autoEventList": "raw",
    "teleopEventList": "raw",

    "generalStrategy": "raw",
    "dataQuality": "raw",
    "comments": "raw",
    "timestamp": "raw"
  },
  "Human Player": {
    "scouterName": "raw",
    "redHPTeam": "raw",
    "blueHPTeam": "raw",
    "replay": "raw",
    "redScore": "raw",
    "blueScore": "raw",
    "redMiss": "raw",
    "blueMiss": "raw",
    "redNetAlgae": "raw",
    "blueNetAlgae": "raw",
    "dataQuality": "raw",
    "timestamp": "raw"
  },
  "Pit": {
    "teamName": "raw",
    "intervieweeName": "raw",
    "interviewerName": "raw",
    "auto": "autoPit",
    "robotHeight": "raw",
    "robotLength": "raw",
    "robotWidth": "raw",
    "robotWeight": "raw",
    "robotDrivetrain": "raw",
    "robotMechanisms": "raw",
    "coralScoringAbilityL1": "raw",
    "coralScoringAbilityL2": "raw",
    "coralScoringAbilityL3": "raw",
    "coralScoringAbilityL4": "raw",
    "canIntakeStation": "raw",
    "canIntakeGround": "raw",
    "canRemoveAlgaeL2": "raw",
    "canRemoveAlgaeL3": "raw",
    "canScoreProcessor": "raw",
    "canScorenet": "raw",
    "canClimbShallow": "raw",
    "canClimbDeep": "raw",
    "averageClimbTime": "raw",
    "driveExperience": "raw",
    "humanPlayerPreference": "raw",
    "generalStrategyPreference": "raw",
    "averageCoralCycles": "raw",
    "averageAlgaeCycles": "raw",
    "idealAlliancePartnerQualities": "raw",
    "otherComments": "raw",
    "layout": "raw",
    "exportName": "raw",
    "timestamp": "raw"
  }
};

// This is a rlly stupid solution to the fact that the BarChart widget only takes an <int,double> map
// Essentially it just adds a four-digit identifier code (1111 for playoffs, 2222 for finals)
// if the match is anything other than a qual match
// in order for this to work, it's VERY important that match numbers are limited to 999 or less
// which shouldn't be a problem but still

int getParsedMatchNumber(dynamic match) {
  return match["matchType"]! == "Qualifications"
      ? match["matchNumber"] // Leave match number if Quals
      : match["matchType"]! == "Playoffs"
          ? int.parse("1111${match["matchNumber"]}") // Add 1111 if Playoffs
          : int.parse("2222${match["matchNumber"]}"); // Add 2222 if Finals
}

List<dynamic> getParsedMatchInfo(int parsedMatch, {bool? truncated}) {
  List<dynamic> infoList = parsedMatch.toString().startsWith("1111")
      ? ["Playoffs", int.parse(parsedMatch.toString().substring(4))]
      : parsedMatch.toString().startsWith("2222")
          ? ["Finals", int.parse(parsedMatch.toString().substring(4))]
          : ["Qualifications", parsedMatch];
  if (truncated == true) {
    return ["${infoList[0].toString().substring(0, 1)}${infoList[1]}"];
  } else {
    return infoList;
  }
}

class AVIDQFilterDropdown extends StatefulWidget {
  final AVISharedState state;
  const AVIDQFilterDropdown({super.key, required this.state});

  @override
  State<AVIDQFilterDropdown> createState() => _AVIDQFilterDropdownState();
}

class _AVIDQFilterDropdownState extends State<AVIDQFilterDropdown> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return dqFilterDialog();
          }),
      child: Container(
        width: 50,
        height: 30,
        decoration: Constants.roundBorder(),
        child: Row(children: [
          Icon(
            Icons.star,
            color: Constants.primaryColor(),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Constants.primaryColor(),
          )
        ]),
      ),
    );
  }

  Widget dqFilterDialog() {
    return Center(
      child: Container(
        width: 250,
        height: 500,
        decoration: Constants.roundBorder(),
        child: Column(
          children: [
            Text(
              "Filter By:",
              style: comfortaaBold(25, color: Colors.black),
            ),
            Column(
                children: List.generate(11, (i) {
              double starRating = (i * 0.5);
              bool selected = starRating ==
                  AVISharedState
                      .dataQualityThreshold; // Checks if this star rating threshold is currently active
              return GestureDetector(
                onTap: () {
                  widget.state.setDQThreshold(starRating);
                  widget.state.updateChartData(
                      sort: _AmongViewIndividualState.sortCheckbox.value);
                  Navigator.pop(context);
                },
                child: Container(
                  color: selected ? Constants.pastelGray : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: selected
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      if (selected) Icon(Icons.check),
                      StarDisplay(
                        starRating: starRating,
                        iconSize: 40,
                      )
                    ],
                  ),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }
}
