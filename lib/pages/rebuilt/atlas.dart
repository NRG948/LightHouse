import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/checbox.dart';
import 'package:lighthouse/widgets/game_agnostic/match_info.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';
import 'package:lighthouse/widgets/rebuilt/cycle_counter.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_endgame_tag_selector.dart';
import 'package:lighthouse/widgets/rebuilt/shift_container.dart';
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
          child: ShiftContainer(
            height: 75,
            margin: margin,
            shifts: ["Transition", "1st Onshift", "2nd Onshift"],
            childBuilder: (index) => Column(
              spacing: margin,
              children: [
                CycleCounter(),
                Container(
                  height: 150,
                  padding: EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius: BorderRadius.circular(margin)),
                  child: Column(
                    spacing: margin,
                    children: [
                      Expanded(
                        child: CustomCheckbox(
                          title: "Feeding",
                          selectColor: Constants.pastelWhite,
                          optionColor: Constants.pastelYellow,
                          textColor: Constants.pastelBrown,
                        ),
                      ),
                      Expanded(
                        child: CustomCheckbox(
                          title: "Disabled",
                          selectColor: Constants.pastelWhite,
                          optionColor: Constants.pastelRed,
                          textColor: Constants.pastelBrown,
                        ),
                      ),
                      Expanded(
                        child: CustomCheckbox(
                          title: "Defending",
                          selectColor: Constants.pastelWhite,
                          optionColor: Constants.pastelYellow,
                          textColor: Constants.pastelBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          child: Column(
            children: [
              RebuiltEndgameTagSelector(),
            ],
          ),
        ),
      )
    });
  }
}
