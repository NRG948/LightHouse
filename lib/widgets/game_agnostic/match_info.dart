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
        DataEntry.exportData["teamNumber"] = teamNumberController.text;
      });
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    teamNumberController.dispose();
  }
  late String eventKey;
  bool replay = false;
  String matchType = "Qualifications";
  String driverStation = "Red 1";
  TextEditingController teamNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
   
    return Container(
      width: 400 * scaleFactor,
      height: 250 * scaleFactor,
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
                    DataEntry.exportData["replay"] = replay ? "true" : "false";});
                  },
                  activeColor: Constants.pastelYellow,),
                )
              ],
          ),
          SizedBox(height:20*scaleFactor),
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
                      DataEntry.exportData["matchNumber"] = value.toString();
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
}