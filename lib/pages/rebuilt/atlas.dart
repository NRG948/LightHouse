import 'package:flutter/material.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/match_info.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';

class Atlas extends StatefulWidget {
  const Atlas({super.key});

  @override
  State<Atlas> createState() => AtlasState();
}

class AtlasState extends State<Atlas> {
  @override
  Widget build(BuildContext context) {
    return DataEntryPage(
      name: "Atlas", 
      pages: {
        "Setup": DataEntrySubPage(icon: CustomIcons.wrench, content: Container(
          child: Column(
            children: [
              MatchInfo()
            ],
          )
        )), 
        "Auto": DataEntrySubPage(icon: CustomIcons.autonomous,content: Container(
          child: NRGPlaceholder(title: "auto", jsonKey: "auto", height: 20, width: 20)
        ),), 
        // TODO: get more sensible icons
        "Onshift": DataEntrySubPage(icon: CustomIcons.racecar, content: Container(
           child: NRGPlaceholder(title: "onshift", jsonKey: "onshift", height: 10, width: 20),
        ),), 
        "Offshift": DataEntrySubPage(icon: CustomIcons.timer, content: Container(
           child: NRGPlaceholder(title: "offshift", jsonKey: "offshift", height: 10, width: 20),
        ),),
        "Endgame": DataEntrySubPage(icon: CustomIcons.flag, content: Container(
           child: NRGPlaceholder(title: "endgame", jsonKey: "endgame", height: 10, width: 20),
        ),)
      }
    );
  }
}