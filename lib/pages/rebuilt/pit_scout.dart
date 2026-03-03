import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/multi_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/multi_three_stage_checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/old_textbox.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/team_info.dart';
import 'package:lighthouse/widgets/rebuilt/metric.dart';
import 'package:lighthouse/widgets/rebuilt/pit_auto_container.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart';

class PitScout extends StatefulWidget {
  const PitScout({super.key});

  @override
  State<PitScout> createState() => PitScoutState();
}

class PitScoutState extends State<PitScout> {
  @override
  Widget build(BuildContext context) {
    return DataEntryPage(
      name: "Pit",
      pages: {
        "Setup": DataEntrySubPage(
          icon: CustomIcons.pitCrew,
          content: Container(
              child: Column(
            children: [
              TeamInfo(),
            ],
          )),
        ),
        "General": DataEntrySubPage(
            icon: CustomIcons.wrench,
            content: Container(
              margin: EdgeInsets.all(10),
              child: Column(spacing: 15, children: [
                MultiChoiceSelector(
                  title: "Shooter Type",
                  selectOptions: ["Fixed", "Turret"],
                  height: 100,
                  jsonKey: "shooterType",
                ),
                MultiChoiceSelector(
                    title: "Intake Type",
                    selectOptions: ["Ground", "Outpost"],
                    height: 100,
                    jsonKey: "intakeType")
              ]),
            )),
        "Auto": DataEntrySubPage(
          icon: CustomIcons.autonomous,
          content: Container(
            margin: EdgeInsets.all(10),
            child: Column(spacing: 15, children: [
              PitAutoContainer(
                height: 50,
                jsonKey: "autoPath",
                childBuilder: (index) => Column(
                  spacing: 10,
                  children: [
                    RebuiltAutoPathSelector(
                      margin: 7,
                      jsonKey: "autoPath${(index + 1)}",
                      pit: true,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Constants.pastelWhite,
                        borderRadius:
                            BorderRadius.circular(Constants.borderRadius),
                      ),
                      child: NRGTextbox(
                          numeric: true,
                          title: "Fuel Scored",
                          jsonKey: "autoFuelScored${(index + 1)}",
                          height: 60,
                          width: double.infinity,
                          fontSize: 20,
                          maxLines: 1),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        "Teleop": DataEntrySubPage(
          icon: CustomIcons.racecar,
          content: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              spacing: 10, 
              children: [
                NRGMultiThreeStageCheckbox(
                  title: "Bump or Trench",
                  jsonKey: ["canGoBump", "canGoTrench"],
                  width: double.infinity,
                  height: 100,
                  boxNames: [
                    ["Bump", "Trench"]
                  ],
                ), 
                NRGMultiThreeStageCheckbox(
                  title: "Preferred Shooting Area",
                  jsonKey: ["canShootTrench", "canShootHub", "canShootTower", "canShootAnywhere"],
                  width: double.infinity,
                  height: 130,
                  boxNames: [
                    ["Trench", "Hub", "Tower", "Anywhere"]
                  ],
                ), 
                NRGMultiThreeStageCheckbox(
                  title: "Offshift Strat",
                  jsonKey: ["canFeed", "canDefend", "canHoard"],
                  width: double.infinity,
                  height: 130,
                  boxNames: [
                    ["Feed", "Defend", "Hoard"]
                  ],
                )
              ],
            ),
          ),
        ),
      },
    );
  }
}
