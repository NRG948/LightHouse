import "dart:collection";
import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/widgets/game_agnostic/barchart.dart";
import "package:lighthouse/widgets/game_agnostic/scrollable_box.dart";
import "package:lighthouse/widgets/reefscape/auto_reef_view.dart";
import "package:lighthouse/widgets/reefscape/scrollable_auto_reefs.dart";

class TonyDataViewerPage extends StatefulWidget {
  const TonyDataViewerPage({super.key});

  @override
  State<TonyDataViewerPage> createState() => _TonyDataViewerPageState();
}

class _TonyDataViewerPageState extends State<TonyDataViewerPage> {
  late double verticalScaleFactor;
  late double horizontalScaleFactor;
  late double marginSize;
  late List<Map<String, dynamic>> atlasData;
  late List<Map<String, dynamic>> chronosData;
  late List<Map<String, dynamic>> humanPlayerData;
  late List<Map<String, dynamic>> pitData;

  int currentTeamNumber = 0;
  late Set<int> teamsInDatabase;

  Set<int> getTeamsInDatabase() {
    SplayTreeSet<int> teams = SplayTreeSet();

    for (Map<String, dynamic> matchData in atlasData) {
      teams.add(matchData["teamNumber"]);
    }
    /*
    for (Map<String, dynamic> matchData in chronosData) {
      teams.add(matchData["teamNumber"]);
    }
    */

    // for (Map<String, dynamic> matchData in pitData) {
    //   teams.add(int.tryParse(matchData["teamNumber"]) ?? 0);
    // }

    for (Map<String, dynamic> matchData in humanPlayerData) {
      teams.add(matchData["redHPTeam"]);
      teams.add(matchData["blueHPTeam"]);
    }

    return teams.toSet();
  }

  List<Map<String, dynamic>> getDataAsMapFromSavedMatches(String layout) {
    assert(configData["eventKey"] != null);
    List<String> dataFilePaths =
        getFilesInLayout(configData["eventKey"]!, layout);
    return dataFilePaths
        .map<Map<String, dynamic>>((String path) =>
            loadFileIntoSavedData(configData["eventKey"]!, layout, path))
        .toList();
  }

  List<Map<String, dynamic>> getDataAsMapFromDatabase(String layout) {
    assert(configData["eventKey"] != null);
    var file = loadDatabaseFile(configData["eventKey"]!, layout);
    if (file == "") return [];
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        jsonDecode(loadDatabaseFile(configData["eventKey"]!, layout))
            .map((item) => Map<String, dynamic>.from(item)));
    return data;
  }

  Widget getTeamSelectDropdown() {
    return DropdownButtonFormField(
        value: currentTeamNumber,
        dropdownColor: Constants.pastelWhite,
        padding: EdgeInsets.all(marginSize),
        decoration: InputDecoration(
            label: Text('Team Number',
                style: comfortaaBold(12,
                    color: Constants.pastelBrown,
                    customFontWeight: FontWeight.w900)),
            iconColor: Constants.pastelBrown),
        items: teamsInDatabase
            .map((int team) => DropdownMenuItem(
                value: team,
                child: Text("$team",
                    style: comfortaaBold(12, color: Constants.pastelBrown))))
            .toList(),
        onChanged: (n) {
          setState(() {
            currentTeamNumber = n!;
          });
        });
  }

  Widget getFunctionalMatches() {
    int disabledMatches = 0;
    int totalMatches = 0;

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        if (matchData["robotDisabled"]) {
          disabledMatches++;
        }
        totalMatches++;
      }
    }

    return Text(
        "Functional Matches: ${totalMatches - disabledMatches}/$totalMatches",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getPreferredStrategy() {
    Map<String, int> frequencyMap = {};

    for (Map<String, dynamic> matchData in chronosData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        frequencyMap[matchData["generalStrategy"]] =
            (frequencyMap[matchData["generalStrategy"]] ?? 0) + 1;
      }
    }

    return Text(
        "Preferred Strategy: ${frequencyMap.isNotEmpty ? frequencyMap.entries.reduce((a, b) => a.value > b.value ? a : b).key : "None"}",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getHumanPlayerAccuracy() {
    int totalAlgae = 0;
    int algaeScored = 0;

    for (Map<String, dynamic> matchData in humanPlayerData) {
      if (matchData["redHPTeam"] == currentTeamNumber) {
        algaeScored += matchData["redScore"] as int;
        totalAlgae += matchData["redScore"] as int;
        totalAlgae += matchData["redMiss"] as int;
      }

      if (matchData["blueHPTeam"] == currentTeamNumber) {
        algaeScored += matchData["blueScore"] as int;
        totalAlgae += matchData["blueScore"] as int;
        totalAlgae += matchData["blueMiss"] as int;
      }
    }

    return Text("HP Net Accuracy: $algaeScored/$totalAlgae",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getDefenseMatches() {
    Map<String, List<int>> matches = {
      "Not Effective": [],
      "Somewhat Effective": [],
      "Very Effective": [],
    };

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber &&
          matchData["crossedMidline"]) {
        if (matches.keys.contains(matchData["defenseRating"])) {
          matches[matchData["defenseRating"]]!.add(matchData["matchNumber"]);
        }
      }
    }

    List<Widget> row = [];
    for (String key in matches.keys) {
      row.add(Expanded(
        child: Column(
          spacing: 8,
          children: [
            Center(
              child: Text(key,
                  textAlign: TextAlign.center,
                  style: comfortaaBold(12, color: Constants.pastelBrown)),
            ),
            Expanded(
              child: ListView.separated(
                  itemCount: matches[key]!.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 12, color: Constants.pastelWhite),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Constants.pastelRed,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(50, 0, 0, 0),
                                offset: Offset.fromDirection(pi / 2, 5),
                                blurRadius: 2,
                              )
                            ],
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: Text("${matches[key]![index]}",
                              style: comfortaaBold(24,
                                  color: Constants.pastelWhite)),
                        ));
                  }),
            ),
          ],
        ),
      ));
    }

    return Container(
        width: 240,
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          spacing: 8,
          children: [
            Text("Defense Matches",
                style: comfortaaBold(20, color: Constants.pastelBrown)),
            Expanded(
              child: Row(
                spacing: 8,
                children: row,
              ),
            ),
          ],
        ));
  }

  Widget getDisableReasonCommentBox() {
    List<List<String>> comments = [];

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        if (matchData["robotDisableReason"] != "") {
          comments.add([
            matchData["scouterName"],
            matchData["robotDisableReason"],
            matchData["matchNumber"].toString(),
            "atlas",
            matchData["dataQuality"].toString()
          ]);
        }
      }
    }

    return ScrollableBox(
        width: 240 * horizontalScaleFactor,
        height: 200 * verticalScaleFactor,
        title: "Disable Reason",
        comments: comments);
  }

  Widget getCommentBox() {
    List<List<String>> comments = [];
    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber &&
          matchData["comments"].isNotEmpty) {
        comments.add([
          matchData["scouterName"],
          matchData["comments"],
          matchData["matchNumber"].toString(),
          "atlas",
          matchData["dataQuality"].toString()
        ]);
      }
    }
    // Pit data not included in comments. That is in a separate section.
    for (Map<String, dynamic> matchData in humanPlayerData) {
      if ((matchData["redHPTeam"] == currentTeamNumber ||
              matchData["blueHPTeam"] == currentTeamNumber) &&
          matchData["comments"] !=
              null && // TODO: Temporary fix for null comments. They should default to empty strings.
          matchData["comments"].isNotEmpty) {
        comments.add([
          matchData["scouterName"],
          matchData["comments"],
          matchData["matchNumber"].toString(),
          "pit",
          matchData["dataQuality"].toString()
        ]);
      }
    }

    return ScrollableBox(
        width: 400 * horizontalScaleFactor,
        height: 220 * verticalScaleFactor,
        title: "Comments",
        comments: comments);
  }

  Widget getMatchesOnDefense() {
    if (atlasData.isEmpty) {
      return Container();
    }

    List<int> matches = [];

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber &&
          matchData["crossedMidline"]) {
        matches.add(matchData["matchNumber"]);
      }
    }

    return Text("Matches on Defense: ${matches.join(", ")}",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getSuccessfulClimbRate() {
    if (atlasData.isEmpty) {
      return Container();
    }

    int successfulClimbs = 0;
    int attemptedClimbs = 0;

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber &&
          matchData["attemptedClimb"]) {
        attemptedClimbs++;
        if (["Deep Climb", "Shallow Climb"]
            .contains(matchData["endLocation"])) {
          successfulClimbs++;
        }
      }
    }

    return Text("Climb Rate: $successfulClimbs/$attemptedClimbs",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getAtlasClimbStartTimeAverage() {
    if (atlasData.isEmpty) {
      return Container();
    }

    double totalTime = 0;
    int matches = 0;

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber &&
          matchData["attemptedClimb"] &&
          ["Deep Climb", "Shallow Climb"].contains(matchData["endLocation"])) {
        matches++;
        if (matchData["climbStartTime"] is num &&
            matchData["climbStartTime"] != 0) {
          totalTime += matchData["climbStartTime"];
        }
      }
    }

    return Text(
        "Average Climb Time: ${matches == 0 ? 0 : (totalTime / matches).toStringAsFixed(3)}",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getChronosClimbStartTimeAverage() {
    if (chronosData.isEmpty) {
      return Container();
    }

    double totalTime = 0;
    int matches = 0;

    for (Map<String, dynamic> matchData in chronosData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        double startingTime = -1;
        double endingTime = 135; // Assumes climb stop at end of match

        List<List<dynamic>> teleopEvents =
            List<List<dynamic>>.from(matchData["teleopEventList"]);
        for (List<dynamic> event in teleopEvents) {
          if (event[0] == "enterClimbArea") {
            startingTime = event[1];
          } else if (event[0] == "exitClimbArea") {
            endingTime = event[1];
          }
          // Takes the last one right now. Might want to take the first starting time and the last ending time.
        }

        if (startingTime != -1 &&
            (matchData["endLocation"] == "Deep Climb" ||
                matchData["endLocation"] == "Shallow Climb")) {
          totalTime += endingTime - startingTime;
          matches++;
        }
      }
    }

    return Text(
        "Average Climb Time: ${matches == 0 ? 0 : (totalTime / matches).toStringAsFixed(3)}",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getClimbStartTimeBarChart() {
    // THIS USES OUTDATED JSON KEYS. UPDATE BEFORE USING.
    if (chronosData.isEmpty) {
      return Container();
    }

    SplayTreeMap<int, double> chartData = SplayTreeMap();
    List<int> removedData = [];
    Color color = Constants.pastelRed;
    String label = "AVERAGE CLIMB TIME";

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        chartData[matchData["matchNumber"]] =
            matchData["climbStartTime"].toDouble();
        if (matchData["robotDisabled"] || !matchData["attemptedClimb"]) {
          removedData.add(matchData["matchNumber"]);
        }
      }
    }

    return NRGBarChart(
        title: "Climb Time",
        height: 150 * verticalScaleFactor,
        width: 190 * horizontalScaleFactor,
        removedData: removedData,
        data: chartData,
        color: color,
        dataLabel: label);
  }

  Widget getAlgaeBarChart() {
    if (atlasData.isEmpty) {
      return Container();
    }

    SplayTreeMap<int, List<double>> chartData = SplayTreeMap();
    List<int> removedData = [];
    List<Color> colors = [Constants.pastelBlue, Constants.pastelBlueDark];
    List<String> labels = ["PROC", "NET"];

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        // Get algae scored for processor and barge in teleop.
        List<double> scoreDistribution = [
          matchData["algaeScoreProcessor"].toDouble(),
          matchData["algaeScoreNet"].toDouble()
        ];
        chartData[matchData["matchNumber"]] = scoreDistribution;

        // Get matches where robot disabled
        if (matchData["robotDisabled"]) {
          removedData.add(matchData["matchNumber"]);
        }
      }
    }

    return NRGBarChart(
        title: "Algae",
        height: 180 * verticalScaleFactor,
        width: 190 * horizontalScaleFactor,
        removedData: removedData,
        multiData: chartData,
        multiColor: colors,
        dataLabels: labels);
  }

  Widget getCoralBarChart() {
    if (atlasData.isEmpty) {
      return Container();
    }

    SplayTreeMap<int, List<double>> chartData = SplayTreeMap();
    List<int> removedData = [];
    List<Color> colors = [
      Constants.pastelBrown,
      Constants.pastelRedDark,
      Constants.pastelRed,
      Constants.pastelYellow
    ];
    List<String> labels = ["L1", "L2", "L3", "L4"];

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        // Get coral scored for each level in auto and teleop.
        List<double> scoreDistribution = [0, 0, 0, 0];

        for (String reefBranch in fixAutoCoralScoredData(
            matchData["autoCoralScored"].toString())) {
          try {
            scoreDistribution[int.parse(reefBranch[1]) - 1] += 1;
          } catch (_) {
            // Check if string is list
            try {
              List<String> reefBranchList = jsonDecode(reefBranch);
              for (String innerReefBranch in reefBranchList) {
                scoreDistribution[int.parse(innerReefBranch[1]) - 1] += 1;
              }
            } catch (_) {}
          }
        }
        for (int i = 1; i <= 4; i++) {
          scoreDistribution[i - 1] += matchData["coralScoredL$i"];
        }
        chartData[matchData["matchNumber"]] = scoreDistribution;

        // Get matches where robot disabled
        if (matchData["robotDisabled"]) {
          removedData.add(matchData["matchNumber"]);
        }
      }
    }

    return NRGBarChart(
        title: "Coral",
        height: 270 * verticalScaleFactor,
        width: 190 * horizontalScaleFactor,
        removedData: removedData,
        multiData: chartData,
        multiColor: colors,
        dataLabels: labels);
  }

  Widget getAutoPreviews() {
    // Sorted so latest autos appear first to keep the list up-to-date.
    SplayTreeMap<int, AutoReefView> autos = SplayTreeMap<int, AutoReefView>((a, b) => b.compareTo(a));;

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        autos[matchData["matchNumber"]] = AutoReefView(
          height: 270 * horizontalScaleFactor,
          width: 360 * horizontalScaleFactor,
          scouterNames: [matchData["scouterName"]],
          matchNumber: matchData["matchNumber"],
          dataQuality: matchData["dataQuality"].toDouble(),
          flipStartingPosition: matchData["driverStation"][0] == "R",
          startingPosition: List<double>.from(matchData["startingPosition"]
              .split(",")
              .map((x) => double.parse(x))
              .toList()),
          reef: AutoReef(
              algaeRemoved: List<String>.from(matchData["autoAlgaeRemoved"]),
              scores: fixAutoCoralScoredData(
                  matchData["autoCoralScored"].toString()),
              troughCount: int.parse(matchData["autoCoralScoredL1"] ?? "0"),
              groundIntake: matchData["groundIntake"],
              processorCS: matchData["processorCS"],
              bargeCS: matchData["bargeCS"]),
          hasNoAuto: matchData["hasNoAuto"],
          pit: false,
        );
      }
    }

    for (Map<String, dynamic> matchData in pitData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        for (int i = 0; i < matchData["auto"]!.length; i++) {
          autos[-i - 1] = AutoReefView(
            height: 270 * horizontalScaleFactor,
            width: 360 * horizontalScaleFactor,
            scouterNames: [matchData["interviewerName"]],
            matchNumber: -i - 1,
            dataQuality: 0,
            flipStartingPosition: false,
            startingPosition: [0, 0],
            reef: AutoReef(
              algaeRemoved:
                  List<String>.from(matchData["auto"][i]["autoAlgaeRemoved"]),
              scores: fixAutoCoralScoredData(
                  matchData["auto"][i]["autoCoralScored"].toString()),
              troughCount:
                  int.parse(matchData["auto"][i]["autoCoralScoredL1"] ?? "0"),
              groundIntake: matchData["auto"][i]["groundIntake"],
              processorCS: matchData["auto"][i]["processorCS"],
              bargeCS: matchData["auto"][i]["bargeCS"],
            ),
            hasNoAuto: matchData["auto"][i]["hasNoAuto"],
            pit: true,
          );
        }
      }
    }

    if (autos.values.toList().isEmpty) {
      return Placeholder();
    }
    return ScrollableAutoPaths(
        height: 300 * verticalScaleFactor,
        width: 400 * horizontalScaleFactor,
        title: "Match Autos",
        autos: autos.values.toList());
  }

  Widget getPitAutoPreviews() {
    Map<int, AutoReefView> autos = {};
    for (Map<String, dynamic> teamPitData in pitData) {
      if (teamPitData["teamNumber"] == currentTeamNumber.toString()) {
        for (dynamic auto in teamPitData["auto"]) {
          autos[teamPitData["auto"].indexOf(auto) + 1] = AutoReefView(
              height: 270 * horizontalScaleFactor,
              width: 360 * horizontalScaleFactor,
              pit: true,
              scouterNames: [
                teamPitData["interviewerName"],
                teamPitData["intervieweeName"],
              ],
              matchNumber: teamPitData["auto"].indexOf(auto) + 1,
              dataQuality:
                  5.0, // This value doesn't matter as rating is never rendered
              reef: AutoReef(
                  scores: fixAutoCoralScoredData(
                      auto["autoCoralScored"].toString()),
                  algaeRemoved: List<String>.from(auto["autoAlgaeRemoved"]),
                  troughCount: int.parse(auto["autoCoralScoredL1"] ?? "0"),
                  groundIntake: auto["groundIntake"],
                  bargeCS: auto["bargeCS"],
                  processorCS: auto["processorCS"]),
              startingPosition: [0.0, 0.0],
              flipStartingPosition: false,
              hasNoAuto: false);
        }
      }
    }

    if (autos.values.toList().isEmpty) {
      return Container(
        width: 300 * verticalScaleFactor,
        height: 00 * horizontalScaleFactor,
        decoration: Constants.roundBorder(),
        child: Center(child: Text("No pit autos")),
      );
    }
    return ScrollableAutoPaths(
        height: 300 * verticalScaleFactor,
        width: 400 * horizontalScaleFactor,
        title: "Pit Autos",
        autos: autos.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    atlasData = getDataAsMapFromDatabase("Atlas");
    //chronosData = getDataAsMapFromDatabase("Chronos");
    humanPlayerData = getDataAsMapFromDatabase("Human Player");
    pitData = getDataAsMapFromDatabase("Pit");
    teamsInDatabase = getTeamsInDatabase();

    if (teamsInDatabase.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back)),
          ),
          body: Text("No data",
              style: comfortaaBold(18, color: Constants.pastelBrown)));
    }

    if (currentTeamNumber == 0) {
      currentTeamNumber = teamsInDatabase.first;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    verticalScaleFactor = screenHeight / 914;
    horizontalScaleFactor = screenWidth / 411;
    marginSize = 10 * verticalScaleFactor;

    List<Widget> scrollableDataColumn = [
      Row(
        spacing: marginSize,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getCoralBarChart(),
          Column(
            spacing: marginSize,
            children: [
              Container(
                  width: 190 * horizontalScaleFactor,
                  height: 80 * verticalScaleFactor,
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.borderRadius))),
                  child: getTeamSelectDropdown()),
              getAlgaeBarChart(),
            ],
          )
        ],
      ),
      getAutoPreviews(),
      getPitAutoPreviews(),
      getCommentBox(),
      Row(
        spacing: marginSize,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getDefenseMatches(),
          Container(
            padding: EdgeInsets.all(marginSize),
            width: 140 * horizontalScaleFactor,
            height: 200 * verticalScaleFactor,
            decoration: BoxDecoration(
                color: Constants.pastelWhite,
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.borderRadius))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: marginSize,
              children: [
                getFunctionalMatches(),
                getHumanPlayerAccuracy(),
                getAtlasClimbStartTimeAverage(),
                getSuccessfulClimbRate(),
                getMatchesOnDefense()
              ],
            ),
          )
        ],
      )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: configData["theme"] != null
          ? themeColorPalettes[configData["theme"] ?? "Dark"]![0]
          : Constants.pastelRed,
      appBar: AppBar(
        backgroundColor: themeColorPalettes[configData["theme"] ?? "Dark"]![0],
        title: const Text(
          "Tony's Data Viewer",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Constants.pastelWhite),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home-data-viewer");
            },
            icon: Icon(
              Icons.home,
              color: Constants.pastelWhite,
            )),
      ),
      body: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.all(marginSize),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgrounds[configData["theme"]] ??
                      "assets/images/background-hires-dark.png"),
                  fit: BoxFit.cover)),
          child: ListView.separated(
            itemCount: scrollableDataColumn.length,
            itemBuilder: (BuildContext context, int index) {
              return scrollableDataColumn[index];
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: marginSize, color: Colors.transparent),
          )),
    );
  }
}

List<String> fixAutoCoralScoredData(String string) {
  //debugPrint(string);
  // Remove outer square brackets (single or double)
  String cleaned =
      string.replaceAllMapped(RegExp(r'^\[\[?|\]\]?$'), (match) => '');

  // Split items by comma and trim spaces
  List<String> items = cleaned.split(',').map((e) => e.trim()).toList();
  return items;
}
