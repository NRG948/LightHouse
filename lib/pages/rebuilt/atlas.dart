import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/checbox.dart';
import 'package:lighthouse/widgets/game_agnostic/match_info.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';
import 'package:lighthouse/widgets/game_agnostic/auto_path_selector.dart';
import 'package:lighthouse/widgets/rebuilt/cycle_counter.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart';
import 'package:lighthouse/widgets/rebuilt/tower_location_selector.dart';

class Atlas extends StatefulWidget {
  const Atlas({super.key});

  @override
  State<Atlas> createState() => AtlasState();
}

class AtlasState extends State<Atlas> {
  double margin = 10;

  @override
  Widget build(BuildContext context) {
    return DataEntryPage(name: "Atlas", pages: {
      "Setup": DataEntrySubPage(
          icon: CustomIcons.wrench,
          content: Container(
              child: Column(
            children: [MatchInfo()],
          ))),
      "Auto": DataEntrySubPage(
        icon: CustomIcons.autonomous,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: margin,
            children: [
              RebuiltAutoPathSelector(margin: margin),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.pastelWhite,
                    borderRadius: BorderRadius.circular(margin),
                  ),
                  child: CycleCounter(
                    isCompact: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // TODO: get more sensible icons
      "Onshift": DataEntrySubPage(
        icon: CustomIcons.racecar,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: margin,
            children: [
              CycleCounter(),
            ],
          ),
        ),
      ),
      "Offshift": DataEntrySubPage(
        icon: CustomIcons.timer,
        content: Container(
          child: NRGPlaceholder(
              title: "offshift", jsonKey: "offshift", height: 10, width: 20),
        ),
      ),
      "Endgame": DataEntrySubPage(
        icon: CustomIcons.flag,
        content: Container(
          child: NRGPlaceholder(
              title: "endgame", jsonKey: "endgame", height: 10, width: 20),
        ),
      )
    });
  }
}
