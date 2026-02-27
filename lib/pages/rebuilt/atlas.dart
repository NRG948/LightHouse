import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';
import 'package:lighthouse/widgets/game_agnostic/match_info.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';
import 'package:lighthouse/widgets/game_agnostic/rating.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/textbox.dart';
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
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.all(margin),
                decoration: BoxDecoration(
                  color: Constants.pastelWhite,
                  borderRadius: BorderRadius.circular(margin),
                ),
                child: InputTextBox(
                  maxLines: 1,
                  hintText: "Scouter name",
                  jsonKey: "scouterName",
                  autofillKey: "scouterName",
                ),
              ),
              MatchInfo()
            ],
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
                    jsonKey: "autoCycles",
                    isCompact: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // TODO: get more sensible icons
      //
      // oh yeah right I kinda just put whatever was in [CustomIcons] already lol
      "Onshift": DataEntrySubPage(
        icon: CustomIcons.racecar,
        content: Container(
          margin: EdgeInsets.all(15),
          child: ShiftContainer(
            height: 75,
            margin: margin,
            shifts: ["Transition", "1st Onshift", "2nd Onshift"],
            childBuilder: (index) {
              final List<String> onshiftKeyPrefixes = [
                'transitionOnshift',
                'firstOnshift',
                'secondOnshift',
              ];
              return Column(
                spacing: margin,
                children: [
                  CycleCounter(jsonKey: "${onshiftKeyPrefixes[index]}Cycles"),
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
                            jsonKey: "${onshiftKeyPrefixes[index]}IsFeeding",
                          ),
                        ),
                        Expanded(
                          child: CustomCheckbox(
                            title: "Disabled",
                            selectColor: Constants.pastelWhite,
                            optionColor: Constants.pastelRed,
                            textColor: Constants.pastelBrown,
                            jsonKey: "${onshiftKeyPrefixes[index]}IsDisabled",
                          ),
                        ),
                        Expanded(
                          child: CustomCheckbox(
                            title: "Defending",
                            selectColor: Constants.pastelWhite,
                            optionColor: Constants.pastelYellow,
                            textColor: Constants.pastelBrown,
                            jsonKey: "${onshiftKeyPrefixes[index]}IsDefending",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
            childBuilder: (index) {
              final List<String> offshiftKeyPrefixes = [
                'transitionOffshift',
                'firstOffshift',
                'secondOffshift',
              ];
              return Column(
                spacing: margin,
                children: [
                  Metric(
                    checkboxTitle: "Defending",
                    selectOptions: ["Poor", "Decent", "Great"],
                    height: 100,
                    optionColor: Constants.pastelYellow,
                    jsonKey: "${offshiftKeyPrefixes[index]}IsDefending",
                  ),
                  Metric(
                    checkboxTitle: "Feeding / Collecting",
                    selectOptions: ["Poor", "Decent", "Great"],
                    height: 100,
                    optionColor: Constants.pastelRed,
                    jsonKey: "${offshiftKeyPrefixes[index]}IsFeeding",
                  ),
                  Metric(
                    checkboxTitle: "Stealing",
                    selectOptions: ["Poor", "Decent", "Great"],
                    height: 100,
                    optionColor: Constants.pastelYellow,
                    jsonKey: "${offshiftKeyPrefixes[index]}IsStealing",
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
                            jsonKey: "${offshiftKeyPrefixes[index]}IsDisabled",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
              TowerLocationSelector(
                margin: margin,
                jsonKey: "climb",
              ),
              NRGRating(
                  title: "Data Quality",
                  jsonKey: "dataQuality",
                  height: 90,
                  width: 400,
                  clearable: false),
              NRGCommentBox(
                title: "Comments",
                jsonKey: "comments",
                height: 125,
                margin: margin,
              ),
            ],
          ),
        ),
      )
    });
  }
}
