import "dart:collection";
import "dart:convert";

import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/widgets/game_agnostic/barchart.dart";
import "package:lighthouse/widgets/game_agnostic/scrollable_box.dart";
import "package:lighthouse/widgets/reefscape/animated_auto_replay.dart";
import "package:lighthouse/widgets/reefscape/scrollable_auto_paths.dart";

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
    for (Map<String, dynamic> matchData in chronosData) {
      teams.add(matchData["teamNumber"]);
    }
    for (Map<String, dynamic> matchData in pitData) {
      teams.add(matchData["teamNumber"]);
    }
    for (Map<String, dynamic> matchData in humanPlayerData) {
      teams.add(matchData["redHPTeam"]);
      teams.add(matchData["blueHPTeam"]);
    }
    // Include pit data?

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

    return Text("Algae Accuracy: $algaeScored/$totalAlgae",
        textAlign: TextAlign.left,
        style: comfortaaBold(10, color: Constants.pastelBrown));
  }

  Widget getDisableReasonCommentBox() {
    List<List<String>> comments = [];

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        if (matchData["robotDisableReason"] != "") {
          comments.add([
            matchData["scouterName"],
            matchData["robotDisableReason"],
            matchData["matchNumber"].toString()
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
      if (matchData["teamNumber"] == currentTeamNumber && matchData["comments"].isNotEmpty) {
        comments.add([
          matchData["scouterName"],
          matchData["comments"],
          matchData["matchNumber"].toString()
        ]);
      }
    }
    for (Map<String, dynamic> matchData in chronosData) {
      if (matchData["teamNumber"] == currentTeamNumber && matchData["comments"].isNotEmpty) {
        comments.add([
          matchData["scouterName"],
          matchData["comments"],
          matchData["matchNumber"].toString()
        ]);
      }
    }
    // Pit data not included in comments. That is in a separate section.
    for (Map<String, dynamic> matchData in humanPlayerData) {
      if ((matchData["redHPTeam"] == currentTeamNumber || matchData["blueHPTeam"] == currentTeamNumber) && matchData["comments"].isNotEmpty) {
        comments.add([
          matchData["scouterName"],
          matchData["comments"],
          matchData["matchNumber"].toString()
        ]);
      }
    }

    return ScrollableBox(
        width: 400 * horizontalScaleFactor,
        height: 220 * verticalScaleFactor,
        title: "Comments",
        comments: comments);
  }

  Widget getClimbStartTimeAverage() {
    if (chronosData.isEmpty) {
      return Container();
    }

    double totalTime = 0;
    int matches = 0;

    for (Map<String, dynamic> matchData in chronosData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        double startingTime = -1;
        double endingTime = 135; // Assumes climb stop at end of match

        List<List<dynamic>> teleopEvents = List<List<dynamic>>.from(matchData["teleopEventList"]);
        for (List<dynamic> event in teleopEvents) {
          if (event[0] == "enterClimbArea") {
            startingTime = event[1];
          } else if (event[0] == "exitClimbArea") {
            endingTime = event[1];
          }
          // Takes the last one right now. Might want to take the first starting time and the last ending time.
        }
        
        if (startingTime != -1 && (matchData["endLocation"] == "Deep Climb" || matchData["endLocation"] == "Shallow Climb")) {
          totalTime += endingTime - startingTime;
          matches++;
        }
      }
    }

    return Text("Average Climb Time: ${matches == 0 ? 0 : (totalTime / matches).toStringAsFixed(3)}",
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
    if (chronosData.isEmpty) {
      return Container();
    }

    SplayTreeMap<int, List<double>> chartData = SplayTreeMap();
    List<int> removedData = [];
    List<Color> colors = [Constants.pastelBlue, Constants.pastelBlueSuperDark];
    List<String> labels = ["NET", "PROC"];

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
    if (chronosData.isEmpty) {
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
        for (String reefBranch in matchData["autoCoralScored"]) {
          scoreDistribution[int.parse(reefBranch[1]) - 1] += 1;
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
    Map<int, AnimatedAutoReplay> autos = {};

    for (Map<String, dynamic> matchData in chronosData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        autos[matchData["matchNumber"]] = AnimatedAutoReplay(
            height: 270 * horizontalScaleFactor, // Scaled with horizontal since that's what the auto replay and reef are scaled with
            width: 360 * horizontalScaleFactor,
            scouterNames: [matchData["scouterName"]],
            matchNumber: matchData["matchNumber"],
            path: AutoPath(
              startingPosition: List<double>.from(matchData["startingPosition"]
                  .split(",")
                  .map((x) => double.parse(x))
                  .toList()),
              waypoints: List<List<dynamic>>.from(matchData["autoEventList"]),
              flipStarting: matchData["driverStation"][0] == "R",
            ));
      }
    }

    for (Map<String, dynamic> matchData in atlasData) {
      if (matchData["teamNumber"] == currentTeamNumber) {
        if (!autos.containsKey(matchData["matchNumber"])) {
          autos[matchData["matchNumber"]] = AnimatedAutoReplay(
              height: 270 * horizontalScaleFactor,
              width: 360 * horizontalScaleFactor,
              scouterNames: [matchData["scouterName"]],
              matchNumber: matchData["matchNumber"],
              reef: AutoReef(
                algaeRemoved: List<String>.from(matchData["autoAlgaeRemoved"]),
                scores: List<String>.from(matchData["autoCoralScored"]),
                troughCount: int.parse(matchData["autoCoralScoredL1"] ?? "0"),
              ));
        } else {
          autos[matchData["matchNumber"]]!.reef = AutoReef(
            scores: List<String>.from(matchData["autoCoralScored"]),
            algaeRemoved: List<String>.from(matchData["autoAlgaeRemoved"]),
            troughCount: int.parse(matchData["autoCoralScoredL1"] ?? "0"),
          );
          autos[matchData["matchNumber"]]!
              .scouterNames
              .add(matchData["scouterName"]);
        }
      }
    }

    if (autos.values.toList().isEmpty) {
      return Placeholder();
    }
    return ScrollableAutoPaths(
        height: 300 * verticalScaleFactor,
        width: 400 * horizontalScaleFactor,
        title: "Autos",
        autos: autos.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    atlasData = getDataAsMapFromDatabase("Atlas");
    chronosData = getDataAsMapFromDatabase("Chronos");
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
      getCommentBox(),
      Row(
        spacing: marginSize,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getDisableReasonCommentBox(),
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
                getPreferredStrategy(),
                getHumanPlayerAccuracy(),
                getClimbStartTimeAverage()
              ],
            ),
          )
        ],
      )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.pastelRed,
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
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home-data-viewer");
            },
            icon: Icon(Icons.home)),
      ),
      body: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.all(marginSize),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
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
