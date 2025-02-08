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
    state.getEnabledLayouts();
    if (state.enabledLayouts.isNotEmpty) {
    state.setActiveLayout(state.enabledLayouts[0]);
    state.loadDatabase();
    state.setActiveSortKey(sortKeys[state.enabledLayouts[0]]!.keys.toList()[0]);
    state.addListener(() {setState(() {
      
    });});
    }

  }
 
  static late double scaleFactor;
  @override
  Widget build(BuildContext context) {
    
    if (state.enabledLayouts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
        ),
        body: Text("No data"));
    }

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
          child: 
          Column(children: [
            Container(
              width: 350 * scaleFactor,
              height: 550 * scaleFactor,
              decoration: BoxDecoration(color: Constants.pastelWhite,borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Column(children: [
                Text("Showing data for ${state.activeEvent}: "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Layout:"),
                    DropdownButton(
                      value: state.activeLayout,
                      items: state.enabledLayouts.map((e) {
                      return DropdownMenuItem(
                      value:e,
                      child: Text(e));}).toList(),
                    onChanged: (newValue) {setState(() {
                      state.setActiveLayout(newValue??"");
                      
                    });
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                color: Constants.pastelRed,
                amongviewAllTeams: true,

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
  List<String> enabledLayouts = [];
  late List<dynamic> data;
  SplayTreeMap<int,double> chartData = SplayTreeMap();

  void getEnabledLayouts() {
    for (String i in ["Atlas","Chronos","Human Player"]) {
      if (loadDatabaseFile(activeEvent, i) != "") {
        enabledLayouts.add(i);
      }
    }
  }
  void setActiveEvent(String event) {
    activeEvent = event;
    notifyListeners();
  }
  void setActiveLayout(String layout) {
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
      case "averagebyitems":
        for (int team in teamsInEvent) {
          List<double> dataPoints = [];
          for (dynamic match in data) {
          if (match["teamNumber"]! == team) {
            dataPoints.add(match[activeSortKey]!.length.toDouble());
          }
        }
        final average = dataPoints.sum / dataPoints.length;
        chartData.addEntries([MapEntry(team, average)]);
        }
      case "cycleTime":
        List searchTerms = [];
        if (activeSortKey.contains("Reef")) {
          searchTerms = ["AB","CD","EF","GH","IJ","KL"];
        } else if (activeSortKey.contains("CS")) {
          searchTerms = ["BargeCS","ProcessorCS"];
        } else if (activeSortKey.contains("Processor")) {
          searchTerms = ["Processor"];
        }


        for (int team in teamsInEvent) {
          List<dynamic> eventList = [];
          for (dynamic match in data) {
            if (match["teamNumber"]! == team) {
              // subEventList is a full list of events in the match
              // that is filtered later
              final List subEventList;
            
              // pulls either auto or teleop events depending on sort key
              if (activeSortKey.contains("Auto")) {
                subEventList = match["autoEventList"]!;
              } else if (activeSortKey.contains("Teleop")) {
                subEventList = match["teleopEventList"]!;
              } else {
                subEventList = [];
              }
              
              for (List event in subEventList) {
                if (searchTerms.any((e) => (event[0] == "enter$e") || (event[0] == "exit$e"))) {
                  eventList.add(event);
                }
              }
            }
          }
          List<double> timeDiffs = [];
          // Iterates through every other event (only the enter area events)
          for (int eventIndex = 0; eventIndex < eventList.length; eventIndex = eventIndex + 2) {
            // Accounts for edge case in which last enter event has no corresponding exit event
            if (eventIndex == eventList.length - 1) {continue;}
            // Gets time difference between this event (enter) and next event (exit)
            timeDiffs.add(eventList[eventIndex + 1][1] - eventList[eventIndex][1]);
          }
          if (timeDiffs.isNotEmpty) {
          chartData.addEntries([MapEntry(team, (timeDiffs.sum / timeDiffs.length))]);
          }
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
  "climbStartTime": "average",
  "autoCoralScored":"averagebyitems",
  "autoAlgaeRemoved":"averagebyitems",
},
"Chronos": {
  "Auto Reef Cycle Time" : "cycleTime",
  "Auto CS Cycle Time" : "cycleTime",
  "Teleop Reef Cycle Time" : "cycleTime",
  "Teleop CS Cycle Time" : "cycleTime",
  "Teleop Processor Cycle Time" : "cycleTime"
},
"Human Player":{}
};


