import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/saved_data.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';

class DataViewerHome extends StatelessWidget {
  DataViewerHome({super.key});
  static late double scaleFactor;

  late List<Map<String, dynamic>> atlasData;

  List<Map<String, dynamic>> getDataAsMap(String layout) {
    List<String> dataFilePaths =
        getFilesInLayout(SavedData.sharedState.activeEvent, layout);
    return dataFilePaths
        .map<Map<String, dynamic>>((String path) =>
            loadFile(SavedData.sharedState.activeEvent, layout, path))
        .toList();
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
    List<String> labels = ["L1", "L2", "L3", "L4"];

    for (Map<String, dynamic> matchData in atlasData) {
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
        removedData.add(int.parse(matchData["matchNumber"]));
      }
    }

    return NRGBarChart(
        title: "Coral",
        height: 100,
        width: 200,
        removedData: removedData,
        multiData: chartData,
        multiColor: colors,
        dataLabels: labels);
  }

  @override
  Widget build(BuildContext context) {
    atlasData = getDataAsMap("Atlas");

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
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)),
          child: Container(
            color: Constants.pastelWhite,
            child: getCoralBarChart(),
          )),
    );
  }
}
