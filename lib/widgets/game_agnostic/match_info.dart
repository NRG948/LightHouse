import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/data_entry.dart';

class MatchInfo extends StatefulWidget {
  final double width;

  const MatchInfo({super.key, this.width = 400});

  @override
  State<MatchInfo> createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo>
    with AutomaticKeepAliveClientMixin {
  static late double scaleFactor;
  static dynamic matchData = [];
  Completer<String> displayEventKey = Completer<String>();
  @override
  bool get wantKeepAlive => true;

  void parseTBAMatchesFile() async {
    String content = await loadTBAFile(eventKey,"matches");
    try {
      matchData = jsonDecode(content);
    } catch(e) {
      print(e);
    }
  }

  void checkForTBAEventInfo() async {
    String eventInfo = await loadTBAFile(eventKey, "event_info");
    if (eventInfo != "") {
      dynamic eventInfoJson = jsonDecode(eventInfo);
      displayEventKey.complete(Future.value("${eventInfoJson["year"]} ${eventInfoJson["name"]}"));
    } else {
      displayEventKey.complete(eventKey.toUpperCase());
    }
  }
  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    eventKey = configData["eventKey"]!;
    parseTBAMatchesFile();
    checkForTBAEventInfo();
    teamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["teamNumber"] =
            int.tryParse(teamNumberController.text) ?? 0;
        getTeamInfo(int.tryParse(teamNumberController.text) ?? 0);
      });
    });
    DataEntry.exportData["matchNumber"] ??= 0;
    DataEntry.exportData["teamNumber"] ??= 0;
    DataEntry.exportData["replay"] ??= false;
    DataEntry.exportData["matchType"] ??= "Qualifications";
    DataEntry.exportData["driverStation"] ??= "Red 1";
  }

  @override
  void dispose() {
    super.dispose();
    teamNumberController.dispose();
  }

  late String eventKey;
  String? teamName;
  String? teamLocation;
  bool replay = false;
  String matchType = "Qualifications";
  String driverStation = "Red 1";
  TextEditingController teamNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Build the main container for the widget
    super.build(context);

    return Container(
      width: 400 * scaleFactor,
      height: 290 * scaleFactor,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        spacing: 10,
        children: [
          Container(
            height: 120 * scaleFactor,
            width: 390 * scaleFactor,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Constants.pastelGray,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Center(
                child: Column(
              children: [
                // Display event key
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.event,
                      size: 30 * scaleFactor,
                      color: Constants.pastelWhite,
                    ),
                    FutureBuilder(
                      future: displayEventKey.future,
                      builder: (context,snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("");
                        }
                        return SizedBox(
                            width: 300 * scaleFactor,
                            height: 35 * scaleFactor,
                            child: Center(
                                child: AutoSizeText(
                              snapshot.data ?? "",
                              style: comfortaaBold(18),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )));
                      }
                    )
                  ],
                ),
                // Display team name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.person,
                      size: 30 * scaleFactor,
                      color: Constants.pastelWhite,
                    ),
                    SizedBox(
                        width: 300 * scaleFactor,
                        height: 35 * scaleFactor,
                        child: Center(
                            child: AutoSizeText(
                          teamName ?? "No Team Selected",
                          style: comfortaaBold(18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )))
                  ],
                ),
                // Display team location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 30 * scaleFactor,
                      color: Constants.pastelWhite,
                    ),
                    SizedBox(
                        width: 300 * scaleFactor,
                        height: 35 * scaleFactor,
                        child: Center(
                            child: AutoSizeText(
                          teamLocation ?? "",
                          style: comfortaaBold(18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        )))
                  ],
                )
              ],
            )),
          ),
          // Input for team number and replay checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50 * scaleFactor,
                width: 250 * scaleFactor,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: teamNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constants.borderRadius),
                          borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Team Number",
                      labelStyle: comfortaaBold(
                        20 * scaleFactor,
                        color: Constants.pastelRedDark,
                      ),
                      fillColor: Constants.pastelRed,
                      filled: true),
                ),
              ),
              SizedBox(
                width: 70 * scaleFactor,
                height: 50 * scaleFactor,
                child: Center(
                    child: AutoSizeText(
                  "Replay",
                  style: comfortaaBold(13 * scaleFactor,
                      color: Constants.pastelBrown),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                )),
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: replay,
                  onChanged: (v) {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      replay = v ?? false;
                      DataEntry.exportData["replay"] = replay;
                    });
                  },
                  activeColor: Constants.pastelYellow,
                ),
              )
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Container(
                width: 170 * scaleFactor,
                height: 65 * scaleFactor,
                decoration: BoxDecoration(
                    color: Constants.pastelYellow,
                    borderRadius:
                        BorderRadius.circular(Constants.borderRadius)),
                child: Center(
                  child: DropdownButton(
                    value: matchType,
                    items: ["Qualifications", "Playoffs", "Finals"].map((v) {
                      return DropdownMenuItem(
                          value: v,
                          child: Text(
                            v,
                            style: comfortaaBold(15 * scaleFactor,
                                color: Constants.pastelBrown),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      HapticFeedback.mediumImpact();
                      matchType = value ?? "Qualifications";
                      DataEntry.exportData["matchType"] = value;
                      if (configData["downloadTheBlueAllianceInfo"] == "true" &&
                        matchData != []) {
                      autofillTeamNumber();
                    }
                    },
                    dropdownColor: Constants.pastelYellow,
                  ),
                ),
              ),
              SizedBox(
                height: 65 * scaleFactor,
                width: 75 * scaleFactor,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    HapticFeedback.mediumImpact();
                    DataEntry.exportData["matchNumber"] =
                        int.tryParse(value) ?? 0;
                    if (configData["downloadTheBlueAllianceInfo"] == "true" &&
                        matchData != []) {
                      autofillTeamNumber();
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constants.borderRadius),
                          borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "#",
                      labelStyle: comfortaaBold(
                        20 * scaleFactor,
                        color: Constants.pastelYellowDark,
                        italic: true,
                      ),
                      fillColor: Constants.pastelYellow,
                      filled: true),
                ),
              ),
              Container(
                width: 110 * scaleFactor,
                height: 65 * scaleFactor,
                decoration: BoxDecoration(
                    color: DataEntry.exportData["driverStation"].contains("Red") ? Constants.pastelRed : Constants.pastelBlue,
                    borderRadius:
                        BorderRadius.circular(Constants.borderRadius)),
                child: Center(
                  child: DropdownButton(
                    value: driverStation,
                    items: [
                      "Red 1",
                      "Red 2",
                      "Red 3",
                      "Blue 1",
                      "Blue 2",
                      "Blue 3"
                    ].map((v) {
                      return DropdownMenuItem(
                          value: v,
                          child: Text(
                            v,
                            style: comfortaaBold(15 * scaleFactor,
                                color: Constants.pastelBrown),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      HapticFeedback.mediumImpact();
                      driverStation = value ?? "Red 1";
                      DataEntry.exportData["driverStation"] = value;
                      if (configData["downloadTheBlueAllianceInfo"] == "true" &&
                          matchData != []) {
                        autofillTeamNumber();
                      }
                    },
                    dropdownColor: DataEntry.exportData["driverStation"].contains("Red") ? Constants.pastelRed : Constants.pastelBlue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Fetch team information based on team number
  void getTeamInfo(int teamNumber) async {
    dynamic teamPage;
    try {
      teamPage = jsonDecode(await rootBundle.loadString(
          "assets/text/teams${(teamNumber ~/ 500) * 500}-${(teamNumber ~/ 500) * 500 + 500}.txt"));
    } catch (e) {
      teamName = null;
      teamNumber = 0;
      teamLocation = null;
      return null;
    }
    bool foundTeam = false;
    for (dynamic teamObject in teamPage) {
      if (teamObject["key"] == "frc$teamNumber") {
        if (teamObject["city"] == null) {
          print('found this team $teamNumber');
          break;
        }
        setState(() {
          teamName = teamObject["nickname"];
          teamLocation =
              "${teamObject["city"]}, ${teamObject["state_prov"]}, ${teamObject["country"]}";
          foundTeam = true;
        });
      }
    }
    if (!foundTeam) {
      teamName = null;
      teamLocation = null;
    }
  }

  void autofillTeamNumber() {
    int stationIndex = driverStation.contains("1")
        ? 0
        : driverStation.contains("2")
            ? 1
            : 2;
    for (dynamic match in matchData) {
      if (match["comp_level"] ==
              tbaAPIMatchTypes[DataEntry.exportData["matchType"]]) {

        // Skips if match number in iterated match doesn't match
        // entered match number, (confusingly enough) using negation
        // and continue statements unlike the logic above
        // to make this even more confusing, semifinals put the match number
        // in a different place >:(
        if (match["comp_level"] == "sf") {
          if (!(match["set_number"] == DataEntry.exportData["matchNumber"])) {
            continue;
          }
        } else {
          if (!(match["match_number"] == DataEntry.exportData["matchNumber"])) {
            continue;
          }
        }
        setState(() {
          int.tryParse(teamNumberController.text = match["alliances"][
                      DataEntry.exportData["driverStation"].contains("Red")
                          ? "red"
                          : "blue"]["team_keys"][stationIndex]
                  .substring(3)) ??
              0;
        });
        return;
      }
    }
    print("no matches");
    setState(() {
      teamNumberController.text = "";
    });
    
  }
}

Map<String, String> tbaAPIMatchTypes = {
  "Qualifications": "qm",
  "Playoffs": "sf",
  "Finals": "f"
};
