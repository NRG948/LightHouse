import 'dart:collection';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';

class AmongViewIndividual extends StatefulWidget {
  const AmongViewIndividual({super.key});

  @override
  State<AmongViewIndividual> createState() => _AmongViewIndividualState();
}

class _AmongViewIndividualState extends State<AmongViewIndividual> {
  
  late double scaleFactor;
  late int activeTeam;
  late AVISharedState state;
  @override
  void initState() {
    super.initState();
    state = AVISharedState();
    
    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state.activeTeam = ModalRoute.of(context)?.settings.arguments as int;
    state.setActiveEvent(configData["eventKey"]!);
    state.getEnabledLayouts();
    state.setActiveLayout(state.enabledLayouts[0]);
    state.loadDatabase();
    state.setActiveSortKey(sortKeys[state.enabledLayouts[0]]!.keys.toList()[0]);
    state.addListener(() {setState(() {
    });});
    }

  @override
  Widget build(BuildContext context) {

    if (state.enabledLayouts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
        ),
        body: Text("No data"));
    }

    state.activeTeam = ModalRoute.of(context)?.settings.arguments as int;
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
            Navigator.pushNamedAndRemoveUntil(context, "/data-viewer-amongview", (route) => false,);
          }, icon: Icon(Icons.arrow_back_ios_new)),
         
        ),
        body: Container(
            width: screenWidth,
            height: screenHeight,
      
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
            child: Text(state.activeTeam.toString()))
        
    );
  }
}
class AVISharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late String activeSortKey;
  late int activeTeam;
  List<String> enabledLayouts = [];
  late List<dynamic> data;
  SplayTreeMap<int,double> chartData = SplayTreeMap();
  LinkedHashMap<int,double>? hashMap;
  static int clickedTeam = 0;


  void setClickedTeam(int team) {
    clickedTeam = team;
    notifyListeners();
  }

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
  
  void updateChartData({bool? sort}) {
    // chartData.clear();
    // teamsInEvent.clear();
    // for (dynamic i in data) {
    //   if (!(teamsInEvent.contains(i["teamNumber"]!))) {
    //     teamsInEvent.add(i["teamNumber"]!);
    //   }
    // }
    // // Sorts from smallest to largets
    // teamsInEvent.sort((a,b) => a.compareTo(b));
    // switch (sortKeys[activeLayout][activeSortKey]) {
    //   case "average":
    //     for (int team in teamsInEvent) {
    //     List<double> dataPoints = [];
    //     for (dynamic match in data) {
    //       if (match["teamNumber"]! == team) {
    //         dataPoints.add(match[activeSortKey]!.toDouble());
    //       }
    //     }
    //     final average = dataPoints.sum / dataPoints.length;
    //     chartData.addEntries([MapEntry(team, average.fourDigits)]);
    //     }
    //   case "averagebyitems":
    //     for (int team in teamsInEvent) {
    //       List<double> dataPoints = [];
    //       for (dynamic match in data) {
    //       if (match["teamNumber"]! == team) {
    //         dataPoints.add(match[activeSortKey]!.length.toDouble());
    //       }
    //     }
    //     final average = dataPoints.sum / dataPoints.length;
    //     chartData.addEntries([MapEntry(team, average.fourDigits)]);
    //     }
    //   case "cycleTime":
    //     List searchTerms = [];
    //     if (activeSortKey.contains("Reef")) {
    //       searchTerms = ["AB","CD","EF","GH","IJ","KL"];
    //     } else if (activeSortKey.contains("CS")) {
    //       searchTerms = ["BargeCS","ProcessorCS"];
    //     } else if (activeSortKey.contains("Processor")) {
    //       searchTerms = ["Processor"];
    //     }


    //     for (int team in teamsInEvent) {
    //       List<dynamic> eventList = [];
    //       for (dynamic match in data) {
    //         if (match["teamNumber"]! == team) {
    //           // subEventList is a full list of events in the match
    //           // that is filtered later
    //           final List subEventList;
            
    //           // pulls either auto or teleop events depending on sort key
    //           if (activeSortKey.contains("Auto")) {
    //             subEventList = match["autoEventList"]!;
    //           } else if (activeSortKey.contains("Teleop")) {
    //             subEventList = match["teleopEventList"]!;
    //           } else {
    //             subEventList = [];
    //           }
              
    //           for (List event in subEventList) {
    //             if (searchTerms.any((e) => (event[0] == "enter$e") || (event[0] == "exit$e"))) {
    //               eventList.add(event);
    //             }
    //           }
    //         }
    //       }
    //       List<double> timeDiffs = [];
    //       // Iterates through every other event (only the enter area events)
    //       for (int eventIndex = 0; eventIndex < eventList.length; eventIndex = eventIndex + 2) {
    //         // Accounts for edge case in which last enter event has no corresponding exit event
    //         if (eventIndex == eventList.length - 1) {continue;}
    //         // Gets time difference between this event (enter) and next event (exit)
    //         timeDiffs.add(eventList[eventIndex + 1][1] - eventList[eventIndex][1]);
    //       }
    //       if (timeDiffs.isNotEmpty) {
    //       chartData.addEntries([MapEntry(team, (timeDiffs.sum / timeDiffs.length).fourDigits)]);
    //       }
    //     }
    // }
    // if (sort == true) {
    //   List<MapEntry<int, double>> sortedEntries = chartData.entries.toList()
    //   ..sort((a, b) => b.value.compareTo(a.value));
    //   hashMap = LinkedHashMap<int,double>.fromEntries(sortedEntries);
    //   teamsInEvent = hashMap != null ? hashMap!.keys.toList() : [];
    // } else {
    //   hashMap = null;
    //   teamsInEvent.sort();
    // }
  }

  List<String> getSortKeys() {
    return sortKeys[activeLayout]!.keys.toList();
  }
  void loadDatabase() {
    data = jsonDecode(loadDatabaseFile(activeEvent, activeLayout));
    for (dynamic i in data) {
      
    }
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
"Human Player":{
  "redScore": "average",
  "blueScore": "average",
  "redMiss": "average",
  "blueMiss": "average",
  "redNetAlgae": "average",
  "blueNetAlgae": "average"
}
};


class AmongViewBarChart extends StatefulWidget {
  const AmongViewBarChart({super.key});

  @override
  State<AmongViewBarChart> createState() => _AmongViewBarChartState();
}

class _AmongViewBarChartState extends State<AmongViewBarChart> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
}
