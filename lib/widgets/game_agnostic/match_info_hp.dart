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
  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    eventKey = configData["eventKey"]!;
    redTeamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["redHPTeam"] = int.tryParse(redTeamNumberController.text) ?? 0;
      });
    });
    blueTeamNumberController.addListener(() {
      setState(() {
        DataEntry.exportData["blueHPTeam"] = int.tryParse(blueTeamNumberController.text) ?? 0;
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
      height: 225 * scaleFactor,
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 55 * scaleFactor,
              width: 390 * scaleFactor,
              decoration: BoxDecoration(
              color: Constants.pastelGray,
                    borderRadius: BorderRadius.circular(Constants.borderRadius)
                  ),
              child: Center(child: AutoSizeText("Match - $eventKey".toUpperCase(),style: comfortaaBold(35,color:Colors.white),textAlign: TextAlign.center,)),
                  
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
}