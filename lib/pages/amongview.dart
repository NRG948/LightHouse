import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';

class DataViewerAmongView extends StatefulWidget {
  const DataViewerAmongView({super.key});

  @override
  State<DataViewerAmongView> createState() => _DataViewerAmongViewState();
}

class _DataViewerAmongViewState extends State<DataViewerAmongView> {
  late AmongViewSharedState state;
  late ValueNotifier<bool> sortCheckbox;
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    state = AmongViewSharedState();
    scrollController = ScrollController();
    sortCheckbox = ValueNotifier<bool>(false);

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
  late double chartWidth;
  @override
  Widget build(BuildContext context) {
    
    if (state.enabledLayouts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
        ),
        body: Text("No data",style: comfortaaBold(18,color: Constants.pastelBrown)));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    chartWidth = state.teamsInEvent.length < 5 ? 350 : state.teamsInEvent.length * 75;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.pastelRed,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor: Constants.pastelRed,
          title: const Text(
            "AmongView",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/home-data-viewer", (route) => false,);
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
            Center(
              child: Column(
                children: [
                  Container(
                    width: 350 * scaleFactor,
                    height: 0.8 * screenHeight,
                    decoration: BoxDecoration(color: Constants.pastelWhite,borderRadius: BorderRadius.circular(Constants.borderRadius)),
                    child: Column(children: [
                      Text("Showing data for ${state.activeEvent}: ", style: comfortaaBold(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Layout:"),
                          DropdownButton(
                            value: state.activeLayout,
                            items: state.enabledLayouts.map((e) {
                            return DropdownMenuItem(
                            value:e,
                            child: Text(e,style: comfortaaBold(12,color: Colors.black),));}).toList(),
                          onChanged: (newValue) {setState(() {
                            state.setActiveLayout(newValue??"");
                            
                          });
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Text("Sort by:", style: comfortaaBold(12,color: Colors.black)),
                        DropdownButton(
                            value: state.activeSortKey,
                            items: state.getSortKeys().map((e) {
                            return DropdownMenuItem(
                            value:e,
                            child: Text(e,style: comfortaaBold(12,color: Colors.black),));}).toList(),
                          onChanged: (newValue) {setState(() {
                            state.setActiveSortKey(newValue ?? "");
                          });
                          }),
                      ],),
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
                          decoration: BoxDecoration(color: Constants.pastelGray,borderRadius: BorderRadius.circular(Constants.borderRadius)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            ValueListenableBuilder(valueListenable: sortCheckbox, builder: (a,b,c) {
                              return Checkbox(value: b, onChanged: (value) {
                                sortCheckbox.value = value ?? false;
                                setState(() => state.updateChartData(sort: sortCheckbox.value));
                              });
                            }),
                            SizedBox(
                              height: 40 * scaleFactor,
                              child: Center(child: AutoSizeText("Sort Data?",style: comfortaaBold(18 * scaleFactor),)),
                            )
                          ],),
                        ),
                      ),
                     
                      SizedBox(
                        height: 300 * scaleFactor,
                        width: 350 * scaleFactor,
                        child: Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          child: ListView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            children:[ NRGBarChart(title: state.activeSortKey.toSentenceCase, height: 300 * scaleFactor, width: chartWidth * scaleFactor,
                            data:state.chartData,
                            color: Constants.pastelRed,
                            amongviewTeams: state.teamsInEvent,
                            hashMap: state.hashMap,
                            sharedState: state,
                            chartOnly: true,
                            ),
                            ]
                          ),
                        ),
                      ),
                        
                      if (AmongViewSharedState.clickedTeam != 0)
                      GestureDetector(
                        onTap: () {
                            Navigator.pushReplacementNamed(context, "/amongview-individual",arguments: AmongViewSharedState.clickedTeam);
                          },
                        child: Container(
                          width: 325 * scaleFactor,
                          height: 250 * scaleFactor,
                          decoration: BoxDecoration(color: Constants.pastelRed,borderRadius: BorderRadius.circular(Constants.borderRadius)),
                          child: Column(children: [
                            FutureBuilder(
                              future: getTeamName(AmongViewSharedState.clickedTeam),
                              builder: (context,snapshot) {
                                if (snapshot.connectionState != ConnectionState.done) {return Text("Loading...",style: comfortaaBold(18),);}
                                return Column(
                                  children: [
                                    Text("Team ${AmongViewSharedState.clickedTeam}",style: comfortaaBold(25),),
                                    Row(
                                      children: [
                                        SizedBox(
                                         width: 250 * scaleFactor,
                                          child: AutoSizeText(snapshot.data.toString(),style: comfortaaBold(18),textAlign: TextAlign.center,)),
                                        FutureBuilder(
                                          future: getTeamPicture(AmongViewSharedState.clickedTeam),
                                          builder: (context,snapshot) {
                                            if (snapshot.connectionState != ConnectionState.done) {
                                              return Image(image: AssetImage("assets/images/unknown.png"),height: 60 * scaleFactor,width: 60 * scaleFactor,fit: BoxFit.fill,);
                                            }
                                            return Image(image: snapshot.data!,height:60 * scaleFactor,width: 60 * scaleFactor,
                                            fit: BoxFit.fill,);
                                          }
                                        )
                                      ],
                                    ),
                                  ],
                                ); 
                                //Text("Team ${AmongViewSharedState.clickedTeam} - ${snapshot.data}",style: comfortaaBold(18),);
                              }
                            )
                          ],),
                        ),
                      )
                      
                      ]
                    ),
                  ),
                ],
              ),
            )
        )),
    );}
}
class AmongViewSharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late String activeSortKey;
  List<String> enabledLayouts = [];
  late List<dynamic> data;
  List<int> teamsInEvent = [];
  SplayTreeMap<int,double> chartData = SplayTreeMap();
  LinkedHashMap<int,double>? hashMap;
  static int clickedTeam = 0;


  void setClickedTeam(int team) {
    clickedTeam = team;
    notifyListeners();
  }

  // // Singleton pattern to allow notifying listeners despite static properties
  // static final AmongViewSharedState _instance = AmongViewSharedState._internal();
  // factory AmongViewSharedState() => _instance;
  // AmongViewSharedState._internal();


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
    chartData.clear();
    teamsInEvent.clear();
    for (dynamic i in data) {
      if (activeLayout != "Human Player") {
      if (!(teamsInEvent.contains(i["teamNumber"]!))) {
        teamsInEvent.add(i["teamNumber"]!);
      }
      } else {
        if (!teamsInEvent.contains(i["redHPTeam"]!)) {
          teamsInEvent.add(i["redHPTeam"]!);
        }
        if (!teamsInEvent.contains(i["blueHPTeam"]!)) {
          teamsInEvent.add(i["blueHPTeam"]!);
        }
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
        chartData.addEntries([MapEntry(team, average.fourDigits)]);
        }
      case "viewAllTeams":
        for (int team in teamsInEvent) {
          chartData.addEntries([MapEntry(team, 1.0)]);
        }
      case "averageboolean":
        for (int team in teamsInEvent) {
          List<double> dataPoints = [];
          for (dynamic match in data) {
            if (match["teamNumber"]! == team) {
              dataPoints.add(match[activeSortKey.removeAfterSpace]! == true ? 1 : 0);
            }
        }
        final average = dataPoints.sum / dataPoints.length;
        chartData.addEntries([MapEntry(team, average.fourDigits)]);
        }
      
       case "hpaverage":
        for (int team in teamsInEvent) {
        List<double> dataPoints = [];
        for (dynamic match in data) {
          if (match["redHPTeam"]! == team && activeSortKey.contains("red")) {
            dataPoints.add(match[activeSortKey]!.toDouble());
          }
          if (match["blueHPTeam"]! == team && activeSortKey.contains("blue")) {
            dataPoints.add(match[activeSortKey]!.toDouble());
          }
        }
        final average = dataPoints.sum / dataPoints.length;
        chartData.addEntries([MapEntry(team, average.fourDigits)]);
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
        chartData.addEntries([MapEntry(team, average.fourDigits)]);
        }
      case "totalaverage":
        Map<String,List<String>> searchTerms = {
          "coralScoredTotal": ["coralScoredL1","coralScoredL2","coralScoredL3","coralScoredL4"]
        };
        for (int team in teamsInEvent) {
          List<double> dataPoints = [];
          for (dynamic match in data) {
            double sumOfItems = 0;
            for (String term in searchTerms[activeSortKey]!) {
              sumOfItems += match[term]!;
            }
            dataPoints.add(sumOfItems);
          }
          final average = dataPoints.sum / dataPoints.length;
          chartData.addEntries([MapEntry(team, average.fourDigits)]);
        }
      case "cycleTime":
        List searchTerms = [];
        List<double> timeDiffs = [];
        if (activeSortKey.contains("Reef")) {
          if (activeSortKey.contains("Auto")) {
            searchTerms = ["AB","CD","EF","GH","IJ","KL"];
          } else {
            searchTerms = ["Reef"];
          }
        } else if (activeSortKey.contains("CS")) {
          if (activeSortKey.contains("Auto")) {
            searchTerms = ["BargeCS","ProcessorCS"];
          } else {
            searchTerms = ["CoralStation"];
          }
        } else if (activeSortKey.contains("Processor")) {
          searchTerms = ["Processor"];
        }
        for (int team in teamsInEvent) {
          
          for (dynamic match in data) {
            List<dynamic> eventList = [];
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
            if (eventList.isNotEmpty) {
            for (int eventIndex = 0; eventIndex < eventList.length; eventIndex = eventIndex + 2) {
            // Accounts for edge case in which last enter event has no corresponding exit event
            if (eventIndex == eventList.length - 1) {continue;}
            // Gets time difference between this event (enter) and next event (exit)
            timeDiffs.add(eventList[eventIndex + 1][1] - eventList[eventIndex][1]);
          }
            }
          }
          
          // Iterates through every other event (only the enter area events)
          
          if (timeDiffs.isNotEmpty) {
          chartData.addEntries([MapEntry(team, (timeDiffs.sum / timeDiffs.length).fourDigits)]);
          }
        }
      case "coralIntakeAverage":
        for (int team in teamsInEvent) {
          List<double> dataPoints = [];
          for (dynamic match in data) {
            int totalIntakeCoral = 0;
            if (match["teamNumber"]! == team) {
              List eventLists = match["teleopEventList"];
              for (List entry in eventLists) {
                if (entry[0] == "intakeCoral") {
                  totalIntakeCoral += 1;
                }
              }
              dataPoints.add(totalIntakeCoral.toDouble());
            }
          }
          final average = dataPoints.sum / dataPoints.length;
          chartData.addEntries([MapEntry(team, average.fourDigits)]);
        }
    }
    if (sort == true) {
      List<MapEntry<int, double>> sortedEntries = chartData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      hashMap = LinkedHashMap<int,double>.fromEntries(sortedEntries);
      teamsInEvent = hashMap != null ? hashMap!.keys.toList() : [];
    } else {
      hashMap = null;
      teamsInEvent.sort();
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
  "viewAllTeams":"viewAllTeams",
  "coralPickups": "average",
  "coralScoredTotal": "totalaverage",
  "coralScoredL1": "average",
  "coralScoredL2": "average",
  "coralScoredL3": "average",
  "coralScoredL4": "average",
  "algaePickups": "average",
  "algaeRemove": "average",
  "algaeScoreProcessor": "average",
  "algaeScoreNet": "average",
  "climbStartTime": "average",
  "bargeCS used in auto (% of matches)" : "averageboolean",
  "processorCS used in auto (% of matches)": "averageboolean",
  "hasNoAuto (% of matches)" : "averageboolean",
  "groundIntake in auto (% of matches)" : "averageboolean",
  "autoCoralScored":"averagebyitems",
  "autoAlgaeRemoved":"averagebyitems",
},
"Chronos": {
  "Auto Reef Cycle Time" : "cycleTime",
  "Auto CS Cycle Time" : "cycleTime",
  "Teleop Reef Cycle Time" : "cycleTime",
  "Teleop CS Cycle Time" : "cycleTime",
  "Teleop Processor Cycle Time" : "cycleTime", 
  "Coral Intake Average" : "coralIntakeAverage"
},
"Human Player":{
  "redScore": "hpaverage",
  "blueScore": "hpaverage",
  "redMiss": "hpaverage",
  "blueMiss": "hpaverage",
  "redNetAlgae": "hpaverage",
  "blueNetAlgae": "hpaverage"
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

Future<String> getTeamName(int teamNumber) async {
    dynamic teamPage;
    try {
      teamPage = jsonDecode(await rootBundle.loadString(
          "assets/text/teams${(teamNumber ~/ 500) * 500}-${(teamNumber ~/ 500) * 500 + 500}.txt"));
    } catch (e) {
      return Future.value("");
    }
    bool foundTeam = false;
    for (dynamic teamObject in teamPage) {
      if (teamObject["key"] == "frc$teamNumber") {
          return Future.value(teamObject["nickname"]);
      }
    }
    if (!foundTeam) {
      return Future.value("");
    }
  }

  Future<AssetImage> getTeamPicture(int teamNumber){
    return Future.value(AssetImage("assets/images/unknown.png"));
  }