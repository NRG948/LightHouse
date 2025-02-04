import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/data_entry.dart';

class MatchInfo extends StatefulWidget {
  final double width;
  
  const MatchInfo({super.key, this.width=400});

  @override
  State<MatchInfo> createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo> {
  static late double scaleFactor;
  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    eventKey = configData["eventKey"]!;
    teamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["teamNumber"] = int.tryParse(teamNumberController.text) ?? 0;
        getTeamInfo(int.tryParse(teamNumberController.text) ?? 0);
      });
    });
    print("INIT STATE");
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
   
    return Container(
      width: 400 * scaleFactor,
      height: 275 * scaleFactor,
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 105 * scaleFactor,
              width: 390 * scaleFactor,
              decoration: BoxDecoration(
              color: Constants.pastelGray,
                    borderRadius: BorderRadius.circular(Constants.borderRadius)
                  ),
              child: Center(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.event,size: 30 * scaleFactor,color: Constants.pastelWhite,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
            
                    child: Center(child: AutoSizeText(eventKey.toUpperCase(),style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,)))
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.person,size: 30 * scaleFactor,color: Constants.pastelWhite,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
                    child: Center(child: AutoSizeText(teamName ?? "No Team Selected",style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,)))
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.location_pin,size: 30 * scaleFactor,color: Constants.pastelWhite,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
                    child: Center(child: AutoSizeText(teamLocation ?? "",style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,)))
                  ],)
                ],)
              ),
                 
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50 * scaleFactor,
                  width: 200 * scaleFactor,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: teamNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Team Number",
                      labelStyle: comfortaaBold(20 * scaleFactor, color: Constants.pastelRedMuted,),
                      fillColor: Constants.pastelRed,
                      filled: true
                    ),
                  ),
                ),
                SizedBox(width: 50 * scaleFactor,
                height: 50 * scaleFactor,
                child: Center(child: AutoSizeText("Replay",style: comfortaaBold(13 * scaleFactor,color: Constants.pastelReddishBrown),maxLines: 1,textAlign: TextAlign.start,)),),
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(value: replay, onChanged: (v) {setState(() {
                    replay = v ?? false;
                    DataEntry.exportData["replay"] = replay;});
                  },
                  activeColor: Constants.pastelYellow,),
                )
              ],
          ),
          SizedBox(height:5*scaleFactor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150 * scaleFactor,
                height: 65 * scaleFactor,
                decoration: BoxDecoration(color: Constants.pastelYellow,borderRadius: BorderRadius.circular(Constants.borderRadius)),
                child: Center(
                  child: DropdownButton(value:matchType,  items: ["Qualifications", "Playoffs", "Finals"].map((v) {return DropdownMenuItem(value:v,child: Text(v,style: comfortaaBold(15 * scaleFactor,color: Constants.pastelReddishBrown),));}).toList(), onChanged: (value) {
                      matchType = value ?? "Qualifications";
                      DataEntry.exportData["matchType"] = value;
                  },dropdownColor: Constants.pastelYellow, ),
                ),
              ),
              Container(
                width: 100 * scaleFactor,
                height: 65 * scaleFactor,
                decoration: BoxDecoration(color: Constants.pastelYellow,borderRadius: BorderRadius.circular(Constants.borderRadius)),
                child: Center(
                  child: DropdownButton(value:driverStation,  items: ["Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"].map((v) {return DropdownMenuItem(value:v,child: Text(v,style: comfortaaBold(15 * scaleFactor,color: Constants.pastelReddishBrown),));}).toList(), onChanged: (value) {
                      driverStation = value ?? "Red 1";
                      DataEntry.exportData["driverStation"] = value;
                  },dropdownColor: Constants.pastelYellow,),
                ),
              ),
              SizedBox(
                  height: 65 * scaleFactor,
                  width: 75 * scaleFactor,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      DataEntry.exportData["matchNumber"] = int.tryParse(value) ?? 0;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "#",
                      labelStyle: comfortaaBold(20 * scaleFactor, color: Constants.pastelRedMuted,italic: true,),
                      fillColor: Constants.pastelRed,
                      filled: true
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  void getTeamInfo(int teamNumber) async {
    final teamPage = jsonDecode(await rootBundle.loadString("assets/text/teams${(teamNumber ~/ 500) * 500}-${(teamNumber ~/ 500) * 500 + 500}.txt"));
    bool foundTeam = false;
    for (dynamic teamObject in teamPage) {
      if (teamObject["key"] == "frc$teamNumber") {
        if (teamObject["city"] == null) {
          print('found this team $teamNumber');
          break;}
        setState(() {
          teamName = teamObject["nickname"];
        teamLocation = "${teamObject["city"]}, ${teamObject["state_prov"]}, ${teamObject["country"]}";
        foundTeam = true;
        });
      }
    }
    if (!foundTeam) {
    teamName = null;
    teamLocation = null;}
  }

}