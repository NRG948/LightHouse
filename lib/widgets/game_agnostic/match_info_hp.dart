import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/data_entry.dart';

class MatchInfoHumanPlayer extends StatefulWidget {
  final double width;
  
  const MatchInfoHumanPlayer({super.key, this.width=400});

  @override
  State<MatchInfoHumanPlayer> createState() => _MatchInfoHumanPlayerState();
}

class _MatchInfoHumanPlayerState extends State<MatchInfoHumanPlayer> {
  static late double scaleFactor;
  String? redTeamName;
  String? redTeamLocation;
  String? blueTeamName;
  String? blueTeamLocation;
  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    eventKey = configData["eventKey"]!;
    redTeamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["redHPTeam"] = int.tryParse(redTeamNumberController.text) ?? 0;
        getTeamInfo(DataEntry.exportData["redHPTeam"], false);
      });
    });
    blueTeamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["blueHPTeam"] = int.tryParse(blueTeamNumberController.text) ?? 0;
         getTeamInfo(DataEntry.exportData["blueHPTeam"], true);
      });
    });
    DataEntry.exportData["matchNumber"] = 0;
    DataEntry.exportData["redHPTeam"] = 0;
    DataEntry.exportData["blueHPTeam"] = 0;
    DataEntry.exportData["replay"] = false;
    DataEntry.exportData["matchType"] = "Qualifications";
  }
  
  @override
  void dispose() {
    super.dispose();
    redTeamNumberController.dispose();
  }
  late String eventKey;
  bool replay = false;
  String matchType = "Qualifications";
  String driverStation = "Red 1";
  TextEditingController redTeamNumberController = TextEditingController();
  TextEditingController blueTeamNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
   
    return Container(
      width: 400 * scaleFactor,
      height: 340 * scaleFactor,
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius)
      ),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Container(
          //     height: 55 * scaleFactor,
          //     width: 390 * scaleFactor,
          //     decoration: BoxDecoration(
          //     color: Constants.pastelGray,
          //           borderRadius: BorderRadius.circular(Constants.borderRadius)
          //         ),
          //     child: Center(child: AutoSizeText("Match - $eventKey".toUpperCase(),style: comfortaaBold(35,color:Colors.white),textAlign: TextAlign.center,)),
                  
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 180 * scaleFactor,
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
                    Icon(Icons.person,size: 30 * scaleFactor,color: Constants.pastelRed,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
                    child: Center(child: AutoSizeText(redTeamName ?? "No Team Selected",style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,)))
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.location_pin,size: 30 * scaleFactor,color: Constants.pastelRed,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
                    child: Center(child: AutoSizeText(redTeamLocation ?? "",style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,)))
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.person,size: 30 * scaleFactor,color: Constants.pastelBlue,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
                    child: Center(child: AutoSizeText(blueTeamName ?? "No Team Selected",style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,)))
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.location_pin,size: 30 * scaleFactor,color: Constants.pastelBlue,),
                    SizedBox(
                    width: 300 * scaleFactor,
                    height: 35 * scaleFactor,
                    child: Center(child: AutoSizeText(blueTeamLocation ?? "",style: comfortaaBold(18),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,)))
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
                  width: 175 * scaleFactor,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: redTeamNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Red Team #",
                      labelStyle: comfortaaBold(20 * scaleFactor, color: Constants.pastelRedMuted,),
                      fillColor: Constants.pastelRed,
                      filled: true
                    ),
                  ),
                ),
                         SizedBox(
                  height: 50 * scaleFactor,
                  width: 175 * scaleFactor,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: blueTeamNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        borderSide: BorderSide.none),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Blue Team #",
                      labelStyle: comfortaaBold(20 * scaleFactor, color: Constants.pastelBlueMuted,),
                      fillColor: Constants.pastelBlue,
                      filled: true
                    ),
                  ),
                ),
                
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
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            SizedBox(width: 50 * scaleFactor,
                height: 50 * scaleFactor,
                child: Center(child: AutoSizeText("Replay",style: comfortaaBold(30 * scaleFactor,color: Constants.pastelReddishBrown),maxLines: 1,textAlign: TextAlign.start,)),),
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(value: replay, onChanged: (v) {setState(() {
                    replay = v ?? false;
                    DataEntry.exportData["replay"] = replay;});
                  },
                  activeColor: Constants.pastelYellow,),
                )
            ],),
              // Container(
              //   width: 100 * scaleFactor,
              //   height: 65 * scaleFactor,
              //   decoration: BoxDecoration(color: Constants.pastelYellow,borderRadius: BorderRadius.circular(Constants.borderRadius)),
              //   child: Center(
              //     child: DropdownButton(value:driverStation,  items: ["Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"].map((v) {return DropdownMenuItem(value:v,child: Text(v,style: comfortaaBold(15 * scaleFactor,color: Constants.pastelReddishBrown),));}).toList(), onChanged: (value) {
              //         driverStation = value ?? "Red 1";
              //         DataEntry.exportData["driverStation"] = value;
              //     },dropdownColor: Constants.pastelYellow,),
              //   ),
              // ),
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
          ),
          SizedBox(height: 10,),
          
        ],
      ),
    );
  }
  void getTeamInfo(int teamNumber,bool blue) async {
    bool foundTeam = false;
    try {
    final teamPage = jsonDecode(await rootBundle.loadString("assets/text/teams${(teamNumber ~/ 500) * 500}-${(teamNumber ~/ 500) * 500 + 500}.txt"));
    for (dynamic teamObject in teamPage) {
      if (teamObject["key"] == "frc$teamNumber") {
        if (teamObject["city"] == null) {
          break;}
        setState(() {
        if (blue) {
        blueTeamName = teamObject["nickname"];
        blueTeamLocation = "${teamObject["city"]}, ${teamObject["state_prov"]}, ${teamObject["country"]}";
        } else {
        redTeamName = teamObject["nickname"];
        redTeamLocation = "${teamObject["city"]}, ${teamObject["state_prov"]}, ${teamObject["country"]}";
        }
        });
        foundTeam = true;
      }
    }
    } catch (e) {debugPrint("oops");}
    if (!foundTeam) {
    setState(() {
      if (blue) {
      blueTeamName = null;
      blueTeamLocation = null;
    } else {
      redTeamName = null;
      redTeamLocation = null;
    }
    });
    
    }
  }
}