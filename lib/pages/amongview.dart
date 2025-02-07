import 'dart:collection';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';

class DataViewerAmongView extends StatefulWidget {
  const DataViewerAmongView({super.key});

  @override
  State<DataViewerAmongView> createState() => _DataViewerAmongViewState();
}

class _DataViewerAmongViewState extends State<DataViewerAmongView> {
  static late AmongViewSharedState state;
  @override
  void initState() {
    super.initState();
    state = AmongViewSharedState();
    if (configData["activeEvent"] == "") {return;}
    state.setActiveEvent(configData["eventKey"]!);
    state.setActiveLayout("Atlas");
    state.loadDatabase();
    state.setActiveSortKey(sortKeys["Atlas"]!.keys.toList()[0]);
    state.addListener(() {setState(() {
      
    });});

  }
 
  static late double scaleFactor;
  @override
  Widget build(BuildContext context) {
    

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    return Scaffold(
      backgroundColor: Constants.pastelRed,
      
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.pastelWhite),
        backgroundColor: Constants.pastelRed,
        title: const Text(
          "LightHouse",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pushNamed(context, "/home-data-viewer");
        }, icon: Icon(Icons.home)),
       
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
              height: 550 * scaleFactor,
              decoration: BoxDecoration(color: Constants.pastelWhite,borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Column(children: [
                Text("Showing data for ${state.activeEvent}: "),
                Row(
                  children: [
                    Text("Layout:"),
                    DropdownButton(
                      value: state.activeLayout,
                      items: ["Atlas","Chronos","Human Player"].map((e) {
                      return DropdownMenuItem(
                      value:e,
                      child: Text(e));}).toList(),
                    onChanged: (newValue) {setState(() {
                      state.activeLayout = newValue ?? "";
                    });
                    }),
                  ],
                ),
                Row(children: [
                  Text("Sort by"),
                  DropdownButton(
                      value: state.activeSortKey,
                      items: state.getSortKeys().map((e) {
                      return DropdownMenuItem(
                      value:e,
                      child: Text(e));}).toList(),
                    onChanged: (newValue) {setState(() {
                      state.setActiveSortKey(newValue ?? "");
                    });
                    }),
                ],),
                NRGBarChart(title: "Data", height: 300 * scaleFactor, width: 350 * scaleFactor,
                data:state.chartData,
                color: Colors.red,

                )
                
                ]
              ),
            )
          ],)
      ));}
}
class AmongViewSharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late String activeSortKey;
  late List<dynamic> data;
  SplayTreeMap<int,double> chartData = SplayTreeMap();


  void setActiveEvent(String event) {
    activeEvent = event;
    notifyListeners();
  }
  void setActiveLayout(String layout) {
    activeLayout = layout;
    notifyListeners();
  }
  void setActiveSortKey(String key) {
    activeSortKey = key;
    updateChartData();
    notifyListeners();
  }
  void updateChartData() {
    chartData.clear();
    List<int> teamsInEvent = [];
    for (dynamic i in data) {
      if (!(teamsInEvent.contains(i["teamNumber"]!))) {
        teamsInEvent.add(i["teamNumber"]!);
      }
    }
    // Sorts from smallest to largets
    teamsInEvent.sort((a,b) => a.compareTo(b));
    switch (sortKeys[activeLayout][activeSortKey]) {
      case "average":
        for (int team in teamsInEvent) {
        List<double> dataPoints = [];
        for (dynamic match in data) {
          if (match["teamNumber"]! == team) {
            dataPoints.add(match[activeSortKey]!.toDouble());
          }
        }
        final average = dataPoints.sum / dataPoints.length;
        chartData.addEntries([MapEntry(team, average)]);
        }

    }
  }
  List<String> getSortKeys() {
    return sortKeys[activeLayout]!.keys.toList();
  }
  void loadDatabase() {
    data = jsonDecode(loadDatabaseFile(activeEvent, activeLayout));
  }
  
}

Map<String,dynamic> sortKeys = {
"Atlas": {
  "coralScoredL1": "average",
  "autoBargeCS": "average",
  "coralPickupsStation": "average",
  "coralPickupsGround": "average",
  "coralScoredL2": "average",
  "coralScoredL3": "average",
  "coralScoredL4": "average",
  "algaeremoveL2": "average",
  "algaeremoveL3": "average",
  "algaescoreProcessor": "average",
  "algaescoreNet": "average",
  "algaemissProcessor": "average",
  "algaemissNet": "average",
  "autoProcessorCS": "average",
  "climbStartTime": "average"
},
"Chronos": [],
"Human Player":[]
};


