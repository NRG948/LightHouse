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
          child: NRGPlaceholder(title: "placeholder", jsonKey: "none", height: 20, width: 20)
        ),)
      }
    );
  }
}