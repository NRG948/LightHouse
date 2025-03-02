import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class TeamInfo extends StatefulWidget {
  final double width;

  const TeamInfo({super.key, this.width = 400});

  @override
  State<TeamInfo> createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo>
    with AutomaticKeepAliveClientMixin {
  TextEditingController teamNumberController = TextEditingController();
  static late double scaleFactor;
  String? teamName;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    teamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["teamNumber"] =
            int.tryParse(teamNumberController.text) ?? 0;
        getTeamName(int.tryParse(teamNumberController.text) ?? 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        width: 360 * scaleFactor,
        height: 200 * scaleFactor,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: teamNumberController,
                  style:
                      comfortaaBold(25.0, color: Constants.pastelBrown),
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: "Team Number",
                      labelStyle: comfortaaBold(30.0,
                          color: Constants.pastelBrown, italic: true),
                      fillColor: Constants.pastelYellow,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Constants.borderRadius),
                          borderSide: BorderSide.none)),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Constants.pastelYellow,
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                  child: Align(
                    alignment: Alignment(-0.85, 0),
                    child: Text(teamName ?? "Team Name",
                        style: comfortaaBold(30,
                            color: Constants.pastelBrown,
                            italic: teamName == null)),
                  ),
                ),
              ),
            ]));
  }

  Future<String?> getTeamName(int teamNumber) async {
    dynamic teamPage;
    try {
      teamPage = jsonDecode(await rootBundle.loadString(
          "assets/text/teams${(teamNumber ~/ 500) * 500}-${(teamNumber ~/ 500) * 500 + 500}.txt"));
    } catch (e) {
      teamName = null;
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
        });
      }
    }
    DataEntry.exportData["teamName"] = teamName ?? "";
  }
}
