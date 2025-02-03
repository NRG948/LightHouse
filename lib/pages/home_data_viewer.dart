import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/saved_data.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';
import 'package:lighthouse/widgets/game_agnostic/scrollable_box.dart';
import 'package:path/path.dart';

class DataViewerHome extends StatefulWidget {
  const DataViewerHome({super.key});

  @override
  State<DataViewerHome> createState() => _DataViewerHomeState();
}

class _DataViewerHomeState extends State<DataViewerHome> {
  late double scaleFactor;
  late List<Map<String, dynamic>> atlasData;
  late List<Map<String, dynamic>> chronosData;
  late List<Map<String, dynamic>> humanPlayerData;
  late List<Map<String, dynamic>> pitData;

  int currentTeamNumber = 0;
  late List<int> teamsInDatabase;

  List<int> getTeamsInDatabase() {
    SplayTreeSet<int> teams = SplayTreeSet();

    for (Map<String, dynamic> matchData
        in atlasData + chronosData + humanPlayerData) {
      teams.add(int.parse(matchData["teamNumber"]));
    }
    // Include pit data?

    return teams.toList();
  }

  List<Map<String, dynamic>> getDataAsMap(String layout) {
    assert(configData["eventKey"] != null);
    List<String> dataFilePaths =
        getFilesInLayout(configData["eventKey"]!, layout);
    return dataFilePaths
        .map<Map<String, dynamic>>(
            (String path) => loadFileIntoSavedData(configData["eventKey"]!, layout, path))
        .toList();
  }

  Widget getTeamSelectDropdown() {
    return DropdownButtonFormField(
        value: currentTeamNumber,
        dropdownColor: Constants.pastelWhite,
        padding: EdgeInsets.all(10),
        decoration: InputDecoration(
            label: Text('Team Number',
                style: comfortaaBold(12,
                    color: Colors.black, customFontWeight: FontWeight.w900)),
            iconColor: Colors.black),
        items: teamsInDatabase
            .map((int team) => DropdownMenuItem(
                value: team,
                child: Text("$team",
                    style: comfortaaBold(12, color: Colors.black))))
            .toList(),
        onChanged: (num) {
          setState(() {
            currentTeamNumber = num!;
          });
        });
  }

  Widget getFunctionalMatches() {
    int disabledMatches = 0;
    int totalMatches = 0;

    for (Map<String, dynamic> matchData in atlasData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        if (matchData["robotDisabled"] == "true") {
          disabledMatches++;
        }
        totalMatches++;
      }
    }

    return Text(
        "Functional Matches: ${totalMatches - disabledMatches}/$totalMatches",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Colors.black));
  }

  Widget getPreferredStrategy() {
    Map<String, int> frequencyMap = {};

    for (Map<String, dynamic> matchData in chronosData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        frequencyMap[matchData["generalStrategy"]] =
            (frequencyMap[matchData["generalStrategy"]] ?? 0) + 1;
      }
    }

    return Text(
        "Preferred Strategy: ${frequencyMap.isNotEmpty ? frequencyMap.entries.reduce((a, b) => a.value > b.value ? a : b).key : "None"}",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Colors.black));
  }

  Widget getDisableReasonCommentBox() {
    List<List<String>> comments = [];

    for (Map<String, dynamic> matchData in atlasData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        if (matchData["robotDisableReason"] != "0") {
          comments.add([
            matchData["scouterName"],
            matchData["robotDisableReason"],
            matchData["matchNumber"]
          ]);
        }
      }
    }

    return ScrollableBox(
        width: 240,
        height: 110,
        title: "Disable Reason",
        comments: comments,
        sort: Sort.LENGTH_MAX);
  }

  Widget getCommentBox() {
    List<List<String>> comments = [];
    for (Map<String, dynamic> matchData in atlasData + chronosData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        comments.add([
          matchData["scouterName"],
          matchData["comments"],
          matchData["matchNumber"]
        ]);
      }
    }

    return ScrollableBox(
        width: 400,
        height: 150,
        title: "Comments",
        comments: comments,
        sort: Sort.LENGTH_MAX);
  }

  Widget getClimbStartTimeBarChart() {
    SplayTreeMap<int, double> chartData = SplayTreeMap();
    List<int> removedData = [];
    Color color = Constants.pastelRed;
    String label = "AVERAGE CLIMB TIME";

    for (Map<String, dynamic> matchData in atlasData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        chartData[int.parse(matchData["matchNumber"])] =
            double.parse(matchData["climbStartTime"]);
        if (matchData["robotDisabled"] == "true" ||
            matchData["attemptedClimb"] == "0") {
          // TODO: Fix json boolean value formatting.
          removedData.add(int.parse(matchData["matchNumber"]));
        }
      }
    }

    return NRGBarChart(
        title: "Climb Time",
        height: 160,
        width: 190,
        removedData: removedData,
        data: chartData,
        color: color,
        dataLabel: label);
  }

  Widget getAlgaeBarChart() {
    SplayTreeMap<int, List<double>> chartData = SplayTreeMap();
    List<int> removedData = [];
    List<Color> colors = [Constants.pastelBlue, Constants.pastelBlueAgain];
    List<String> labels = ["AVERAGE NET", "AVERAGE PROCESSOR"];

    for (Map<String, dynamic> matchData in atlasData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        // Get algae scored for processor and barge in teleop.
        List<double> scoreDistribution = [
          double.parse(matchData["algaescoreProcessor"]),
          double.parse(matchData["algaescoreNet"])
        ];
        chartData[int.parse(matchData["matchNumber"])] = scoreDistribution;

        // Get matches where robot disabled
        if (matchData["robotDisabled"] == "true") {
          // TODO: Fix json boolean value formatting.
          removedData.add(int.parse(matchData["matchNumber"]));
        }
      }
    }

    return NRGBarChart(
        title: "Algae",
        height: 200,
        width: 190,
        removedData: removedData,
        multiData: chartData,
        multiColor: colors,
        dataLabels: labels);
  }

  Widget getCoralBarChart() {
    SplayTreeMap<int, List<double>> chartData = SplayTreeMap();
    List<int> removedData = [];
    List<Color> colors = [
      Constants.pastelReddishBrown,
      Constants.pastelRedMuted,
      Constants.pastelRed,
      Constants.pastelYellow
    ];
    List<String> labels = [
      "AVERAGE L1",
      "AVERAGE L2",
      "AVERAGE L3",
      "AVERAGE L4"
    ];

    for (Map<String, dynamic> matchData in atlasData) {
      if (int.parse(matchData["teamNumber"]) == currentTeamNumber) {
        // Get coral scored for each level in auto and teleop.
        List<double> scoreDistribution = [0, 0, 0, 0];
        for (String reefBranch in matchData["autoCoralScored"]) {
          scoreDistribution[int.parse(reefBranch[1]) - 1] += 1;
        }
        for (int i = 1; i <= 4; i++) {
          scoreDistribution[i - 1] += int.parse(matchData["coralScoredL$i"]);
        }
        chartData[int.parse(matchData["matchNumber"])] = scoreDistribution;

        // Get matches where robot disabled
        if (matchData["robotDisabled"] == "true") {
          // TODO: Fix json boolean value formatting.
          removedData.add(int.parse(matchData["matchNumber"]));
        }
      }
    }

    return NRGBarChart(
        title: "Coral",
        height: 200,
        width: 190,
        removedData: removedData,
        multiData: chartData,
        multiColor: colors,
        dataLabels: labels);
  }

  @override
  Widget build(BuildContext context) {
    atlasData = getDataAsMap("Atlas");
    chronosData = getDataAsMap("Chronos");
    humanPlayerData = getDataAsMap("Unknown");
    pitData = getDataAsMap("Unknown");
    teamsInDatabase = getTeamsInDatabase();
    if (currentTeamNumber == 0) {
      currentTeamNumber = teamsInDatabase[0];
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    loadConfig();
    return Scaffold(
      backgroundColor: Constants.pastelRed,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Switch Mode")),
            ListTile(
                leading: Icon(Icons.home),
                title: Text("Scouter Home"),
                onTap: () {
                  Navigator.pushNamed(context, "/home-scouter");
                }),
            ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text("Data Viewer Home"),
                onTap: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Constants.pastelRed,
        title: const Text(
          "LightHouse",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.javascript_outlined),
            onPressed: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: Text(jsonEncode(configData).toString()));
                  });
            }),
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              })
        ],
      ),
      body: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)),
          child: Column(
            spacing: 10,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.borderRadius))),
                  child: getTeamSelectDropdown()),
              Row(
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Constants.pastelWhite,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius))),
                    child: getCoralBarChart(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Constants.pastelWhite,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius))),
                    child: getAlgaeBarChart(),
                  ),
                ],
              ),
              Row(spacing: 10, children: [
                Container(
                    decoration: BoxDecoration(
                        color: Constants.pastelWhite,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius))),
                    child: getClimbStartTimeBarChart()),
                Container(
                  padding: EdgeInsets.all(10),
                  width: 190,
                  height: 160,
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.borderRadius))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [getFunctionalMatches(), getPreferredStrategy()],
                  ),
                )
              ]),
              Container(
                decoration: BoxDecoration(
                    color: Constants.pastelWhite,
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constants.borderRadius))),
                child: getCommentBox(),
              ),
              Row(
                spacing: 10,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Constants.pastelWhite,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constants.borderRadius))),
                      child: getDisableReasonCommentBox())
                ],
              )
            ],
          )),
    );
  }
}
