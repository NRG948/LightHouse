import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';
import 'package:lighthouse/widgets/game_agnostic/match_info.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';
import 'package:lighthouse/widgets/rebuilt/cycle_counter.dart';
import 'package:lighthouse/widgets/rebuilt/metric.dart';
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
                  height: 167,
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
          margin: EdgeInsets.all(15),
          child: ShiftContainer(
            height: 75,
            margin: margin,
            shifts: ["Transition", "1st Offshift", "2nd Offshift"],
            childBuilder: (index) => Column(
              spacing: margin,
              children: [
                Metric(
                    checkboxTitle: "Defending",
                    selectOptions: ["Poor", "Decent", "Great"],
                    height: 100,
                    optionColor: Constants.pastelYellow),
                Metric(
                  checkboxTitle: "Feeding / Collecting",
                  selectOptions: ["Poor", "Decent", "Great"],
                  height: 100,
                  optionColor: Constants.pastelRed,
                ),
                Metric(
                  checkboxTitle: "Stealing",
                  selectOptions: ["Poor", "Decent", "Great"],
                  height: 100,
                  optionColor: Constants.pastelYellow,
                ),
                Container(
                  height: 65,
                  padding: EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius: BorderRadius.circular(margin)),
                  child: Column(
                    spacing: margin,
                    children: [
                      Expanded(
                        child: CustomCheckbox(
                          title: "Disabled",
                          selectColor: Constants.pastelWhite,
                          optionColor: Constants.pastelRed,
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
      "Endgame": DataEntrySubPage(
        icon: CustomIcons.flag,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: margin,
            children: [
              RebuiltEndgameTagSelector(),
              TowerLocationSelector(margin: margin),
              NRGCommentBox(
                title: "Comments",
                jsonKey: "comments",
                height: 150,
                margin: margin,
              ),
            ],
          ),
        ),
      )
    });
  }
}
