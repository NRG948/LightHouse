import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/models/rebuilt/atlas_data.dart';
import 'package:lighthouse/team_spritesheet.dart';

class MatchInfo extends StatefulWidget {
  final double? margin;
  final Function(String driverStation)? onDriverStationUpdate;
  final Function(int teamNumber)? onTeamNumberUpdate;
  final AtlasData data;

  const MatchInfo({
    super.key,
    this.margin,
    this.onDriverStationUpdate,
    this.onTeamNumberUpdate,
    required this.data,
  });

  @override
  State<MatchInfo> createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo>
    with AutomaticKeepAliveClientMixin {
  static dynamic matchData = [];

  late double _width;
  double get _margin => widget.margin ?? _width / 20;
  Function(String driverStation)? get _onDriverStationUpdate =>
      widget.onDriverStationUpdate;
  Function(int teamNumber)? get _onTeamNumberUpdate =>
      widget.onTeamNumberUpdate;
  AtlasData get _data => widget.data;

  Completer<String> displayEventKey = Completer<String>();
  @override
  bool get wantKeepAlive => true;

  void parseTBAMatchesFile() async {
    String content = await loadTBAFile(eventKey, "matches");
    try {
      matchData = jsonDecode(content);

      if (configData["downloadTheBlueAllianceInfo"] == "true" &&
          matchData != [] &&
          configData["autofillLastMatch"] == "true") {
        autofillTeamNumber();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void checkForTBAEventInfo() async {
    String eventInfo = await loadTBAFile(eventKey, "event_info");
    if (eventInfo != "") {
      dynamic eventInfoJson = jsonDecode(eventInfo);
      displayEventKey.complete(
          Future.value("${eventInfoJson["year"]} ${eventInfoJson["name"]}"));
    } else {
      displayEventKey.complete(eventKey.toUpperCase());
    }
  }

  @override
  void initState() {
    super.initState();
    if (TeamSpritesheet.spritesheet == null) {
      TeamSpritesheet.loadSpritesheet();
    }
    eventKey = configData["eventKey"]!;
    parseTBAMatchesFile();
    checkForTBAEventInfo();
    teamNumberController.addListener(() {
      int team = int.tryParse(teamNumberController.text) ?? 0;
      setState(() {
        _data.teamNumber = team;
        getTeamInfo(team);
      });
      if (_onTeamNumberUpdate != null) _onTeamNumberUpdate!(team);
    });
    _data.matchNumber ??= 0;
    _data.teamNumber ??= 0;
    _data.isReplay ??= false;
    _data.matchType ??= "Qualifications";
    _data.driverStation ??= "Red 1";

    setInitialValue();
  }

  void setInitialValue() {
    if (configData["autofillLastMatch"] == "true") {
      int value = int.parse(configData["currentMatch"]!) + 1;

      _data.matchNumber = value;
      _autofilledMatchNumber = "$value";

      driverStation = configData["currentDriverStation"]!;
      _data.driverStation = driverStation;

      matchType = configData["currentMatchType"]!;
      _data.matchType = matchType;
    }
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
  String? _autofilledMatchNumber;

  @override
  Widget build(BuildContext context) {
    // Build the main container for the widget
    super.build(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return Container(
          width: _width,
          height: _width * 0.8,
          padding: EdgeInsets.all(_margin),
          decoration: BoxDecoration(
              color: Constants.pastelWhite,
              borderRadius: BorderRadius.circular(Constants.borderRadius)),
          child: Column(
            spacing: 10,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(_margin),
                  decoration: BoxDecoration(
                      color: Constants.pastelGray,
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                  child: Center(
                      child: Row(
                    spacing: _margin,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            // Display event key
                            Row(
                              spacing: _margin,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.event,
                                  size: _width / 20,
                                  color: Constants.pastelWhite,
                                ),
                                Expanded(
                                  child: FutureBuilder(
                                      future: displayEventKey.future,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text("");
                                        }
                                        return Center(
                                            child: AutoSizeText(
                                          snapshot.data ?? "",
                                          style: comfortaaBold(_width / 22),
                                          minFontSize: 10,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ));
                                      }),
                                )
                              ],
                            ),
                            // Display team name
                            Row(
                              spacing: _margin,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: _width / 20,
                                  color: Constants.pastelWhite,
                                ),
                                Expanded(
                                  child: Center(
                                      child: AutoSizeText(
                                    teamName ?? "No Team Selected",
                                    style: comfortaaBold(_width / 22),
                                    minFontSize: 10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                )
                              ],
                            ),
                            // Display team location
                            Row(
                              spacing: _margin,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  size: _width / 20,
                                  color: Constants.pastelWhite,
                                ),
                                Expanded(
                                  child: Center(
                                      child: AutoSizeText(
                                    teamLocation ?? "",
                                    style: comfortaaBold(_width / 22),
                                    minFontSize: 10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  )),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: TeamSpritesheet.getTeamPicture(
                                int.tryParse(teamNumberController.text) ?? 0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Container();
                              }
                              return Image.memory(snapshot.data!,
                                  fit: BoxFit.fill);
                            }),
                      )
                    ],
                  )),
                ),
              ),
              // Input for team number and replay checkbox
              Expanded(
                flex: 2,
                child: Row(
                  spacing: _margin,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: teamNumberController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.borderRadius),
                                borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: "Team Number",
                            labelStyle: comfortaaBold(
                              _width / 22,
                              color: Constants.pastelRedDark,
                            ),
                            fillColor: Constants.pastelRed,
                            filled: true),
                      ),
                    ),
                    Expanded(
                      child: Center(
                          child: AutoSizeText(
                        "Replay",
                        style: comfortaaBold(_width / 18,
                            color: Constants.pastelBrown),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      )),
                    ),
                    Expanded(
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: replay,
                          onChanged: (v) {
                            setState(() {
                              HapticFeedback.mediumImpact();
                              replay = v ?? false;
                              _data.isReplay = replay;
                            });
                          },
                          activeColor: Constants.pastelYellow,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Constants.pastelYellow,
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
                        child: Center(
                          child: DropdownButton(
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius),
                            value: matchType,
                            items: ["Qualifications", "Playoffs", "Finals"]
                                .map((v) {
                              return DropdownMenuItem(
                                  value: v,
                                  child: Text(
                                    v,
                                    style: comfortaaBold(_width / 26,
                                        color: Constants.pastelBrown),
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              HapticFeedback.mediumImpact();
                              matchType = value ?? "Qualifications";
                              _data.matchType = value;
                              if (configData["downloadTheBlueAllianceInfo"] ==
                                      "true" &&
                                  matchData != []) {
                                autofillTeamNumber();
                              }
                              setState(
                                  () {}); // for some reason it doesn't change unless this is here :(
                            },
                            dropdownColor: Constants.pastelYellow,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _autofilledMatchNumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          HapticFeedback.mediumImpact();
                          _data.matchNumber = int.tryParse(value) ?? 0;
                          if (configData["downloadTheBlueAllianceInfo"] ==
                                  "true" &&
                              matchData != []) {
                            autofillTeamNumber();
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.borderRadius),
                                borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: "#",
                            labelStyle: comfortaaBold(
                              _width / 20,
                              color: Constants.pastelYellowDark,
                              italic: true,
                            ),
                            fillColor: Constants.pastelYellow,
                            filled: true),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: (_data.driverStation ?? "").contains("Red")
                                ? Constants.pastelRed
                                : Constants.pastelBlue,
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
                        child: Center(
                          child: DropdownButton(
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius),
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
                                    style: comfortaaBold(_width / 22,
                                        color: Constants.pastelBrown),
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              HapticFeedback.mediumImpact();
                              driverStation = value ?? "Red 1";
                              _data.driverStation = value;
                              if (configData["downloadTheBlueAllianceInfo"] ==
                                      "true" &&
                                  matchData != []) {
                                autofillTeamNumber();
                              }
                              if (_onDriverStationUpdate != null)
                                _onDriverStationUpdate!(driverStation);
                            },
                            dropdownColor:
                                (_data.driverStation ?? "").contains("Red")
                                    ? Constants.pastelRed
                                    : Constants.pastelBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
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
          debugPrint('Found team: $teamNumber');
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
      if (match["comp_level"] == tbaAPIMatchTypes[_data.matchType]) {
        // Skips if match number in iterated match doesn't match
        // entered match number, (confusingly enough) using negation
        // and continue statements unlike the logic above
        // to make this even more confusing, semifinals put the match number
        // in a different place >:(
        if (match["comp_level"] == "sf") {
          if (!(match["set_number"] == _data.matchNumber)) {
            continue;
          }
        } else {
          if (!(match["match_number"] == _data.matchNumber)) {
            continue;
          }
        }
        int team = int.tryParse(match["alliances"][
                    (_data.driverStation ?? "").contains("Red")
                        ? "red"
                        : "blue"]["team_keys"][stationIndex]
                .substring(3)) ??
            0;
        setState(() {
          teamNumberController.text = team.toString();
        });
        return;
      }
    }
    debugPrint("No matches found.");
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
