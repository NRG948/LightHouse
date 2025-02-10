import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';

class AmongViewIndividual extends StatefulWidget {
  const AmongViewIndividual({super.key});

  @override
  State<AmongViewIndividual> createState() => _AmongViewIndividualState();
}

class _AmongViewIndividualState extends State<AmongViewIndividual> {
  late double scaleFactor;
  late AVISharedState state;
  late ValueNotifier<bool> sortCheckbox;
  late ScrollController scrollController;
  late double chartWidth;
  late bool forceRunOnce;

  @override
  void initState() {
    super.initState();
    state = AVISharedState();
    scrollController = ScrollController();
    sortCheckbox = ValueNotifier<bool>(false);
    forceRunOnce = true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (forceRunOnce) {
      state.activeTeam = ModalRoute.of(context)?.settings.arguments as int;
      state.setActiveEvent(configData["eventKey"]!);
      state.getEnabledLayouts();
      if (state.enabledLayouts.isNotEmpty) {
        state.setActiveLayout(state.enabledLayouts[0]);
        state.setActiveSortKey(
            sortKeys[state.enabledLayouts[0]]!.keys.toList()[0]);
        state.addListener(() {
          setState(() {});
        });
        state.updateChartData();

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
          body: Text("No data. i'm actually impressed that you got here"));
    }

    state.activeTeam = ModalRoute.of(context)?.settings.arguments as int;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.pastelRed,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor: Constants.pastelRed,
          title: Text(
            "Team ${state.activeTeam} - AmongView",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Colors.white),
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
        ),
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
            child: Column(children: [
              Container(
                  width: 350 * scaleFactor,
                  height: 0.8 * screenHeight,
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                  child: Column(children: [
                    Text("Showing data for ${state.activeEvent}: "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Layout:"),
                        DropdownButton(
                            value: state.activeLayout,
                            items: state.enabledLayouts.map((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                state.setActiveLayout(newValue ?? "");
                              });
                            }),
                      ],
                    ),
                    if (state.getSortKeys().contains(state.activeSortKey))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Sort by"),
                          DropdownButton(
                              value: state.activeSortKey,
                              items: state.getSortKeys().map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  state.setActiveSortKey(newValue ?? "");
                                });
                              }),
                        ],
                      ),
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
                            color: Constants.pastelGray,
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            SizedBox(
                              height: 40 * scaleFactor,
                              child: Center(
                                  child: AutoSizeText(
                                "Sort Data?",
                                style: comfortaaBold(18 * scaleFactor),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.25 * screenHeight,
                      width: 350 * scaleFactor,
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              NRGBarChart(
                                title: state.activeSortKey.toSentenceCase,
                                height: 300 * scaleFactor,
                                width: chartWidth * scaleFactor,
                                data: state.chartData,
                                color: Constants.pastelRed,
                                hashMap: state.hashMap,
                                amongviewMatches: state.matchesForTeam,
                                chartOnly: true,
                                sharedState: state,
                              ),
                            ]),
                      ),
                    ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                        height: 0.35 * screenHeight,
                        width: 350 * scaleFactor,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),border:Border.all(width: scaleFactor * 2)),
                        child: (state.clickedMatch == null) ? Text("No match selected") :
                        buildMatchData(context),
                      ),
                   )
                  ]))
            ])));
  }

  Widget buildMatchData(BuildContext context) {
    Widget matchData = ListView(
      children: [
        Text('')
      ],
    );

    return Text("Showing ${getParsedMatchInfo(state.clickedMatch ?? 0)[0]} ${getParsedMatchInfo(state.clickedMatch ?? 0)[1]} for team ${state.activeTeam}");
  }
}

class AVISharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late String activeSortKey;
  late int activeTeam;
  List<String> enabledLayouts = [];
  late List<int> matchesForTeam = [];
  late List<dynamic> data;
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

  void setActiveSortKey(String key) {
    activeSortKey = key;
    updateChartData();
    notifyListeners();
  }

  void updateChartData({bool? sort}) {
    chartData.clear();
    matchesForTeam.clear();
    for (dynamic i in data) {
      if (!(matchesForTeam.contains(getParsedMatchNumber(i)))) {
        matchesForTeam.add(getParsedMatchNumber(i));
      }
    }
    matchesForTeam.sort((a, b) => a.compareTo(b));

    switch (sortKeys[activeLayout][activeSortKey]) {
      case "raw":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(getParsedMatchNumber(match), match[activeSortKey]!.toDouble())
          ]);
        }
      case "rawbyitems":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(
                getParsedMatchNumber(match), match[activeSortKey]!.length.toDouble())
          ]);
        }
      case "hpraw":
        for (dynamic match in data) {
          if (match["redHPTeam"]! == activeTeam &&
              activeSortKey.contains("red")) {
            chartData.addEntries([
              MapEntry(getParsedMatchNumber(match), match[activeSortKey].toDouble())
            ]);
          }
          if (match["blueHPTeam"]! == activeTeam &&
              activeSortKey.contains("blue")) {
            chartData.addEntries([
              MapEntry(getParsedMatchNumber(match), match[activeSortKey].toDouble())
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
            if (searchTerms.any((e) => (event[0] == "enter$e") || (event[0] == "exit$e"))) {
              filteredEventList.add(event);
            }
          }
          List<double> timeDiffs = [];
          //  Iterates through every other event (only the enter area events)
          for (int eventIndex = 0; eventIndex < filteredEventList.length; eventIndex = eventIndex + 2) {
          // Accounts for edge case in which last enter event has no corresponding exit event
          if (eventIndex == filteredEventList.length - 1) {continue;}
          // Gets time difference between this event (enter) and next event (exit)
            timeDiffs.add(filteredEventList[eventIndex + 1][1] - filteredEventList[eventIndex][1]);
          }
            if (timeDiffs.isNotEmpty) {
            chartData.addEntries([MapEntry(getParsedMatchNumber(match), (timeDiffs.sum / timeDiffs.length).fourDigits)]);
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
}

int getParsedMatchNumber(dynamic match) {
  return match["matchType"]! == "Qualifications" ? match["matchNumber"] // Leave match number if Quals
  : match["matchType"]! == "Playoffs" ? int.parse("991${match["MatchNumber"]}") // Add 991 if Playoffs
  : int.parse("992${match["MatchNumber"]}"); // Add 992 if Finals
}

List<dynamic> getParsedMatchInfo(int parsedMatch) {
  return parsedMatch.toString().startsWith("991") 
  ? ["Playoffs",int.parse(parsedMatch.toString().substring(3))] : 
  parsedMatch.toString().startsWith("992") ? ["Finals",int.parse(parsedMatch.toString().substring(3))] 
  : ["Qualifications",parsedMatch] ;
}

Map<String, dynamic> sortKeys = {
  "Atlas": {
    "coralScoredL1": "raw",
    "autoBargeCS": "raw",
    "coralPickupsStation": "raw",
    "coralPickupsGround": "raw",
    "coralScoredL2": "raw",
    "coralScoredL3": "raw",
    "coralScoredL4": "raw",
    "algaeremoveL2": "raw",
    "algaeremoveL3": "raw",
    "algaescoreProcessor": "raw",
    "algaescoreNet": "raw",
    "algaemissProcessor": "raw",
    "algaemissNet": "raw",
    "autoProcessorCS": "raw",
    "climbStartTime": "raw",
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