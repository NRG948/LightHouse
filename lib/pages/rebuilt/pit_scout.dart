import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/game_agnostic/data_entry_page.dart';
import 'package:lighthouse/pages/game_agnostic/data_entry_sub_page.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';
import 'package:lighthouse/widgets/game_agnostic/multi_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/multi_three_stage_checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/old_textbox.dart';
import 'package:lighthouse/widgets/game_agnostic/team_info.dart';
import 'package:lighthouse/widgets/game_agnostic/textbox.dart';
import 'package:lighthouse/widgets/rebuilt/pit_auto_container.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart';
import 'package:lighthouse/widgets/rebuilt/tower_location_selector.dart';

class PitScout extends StatefulWidget {
  const PitScout({super.key});

  @override
  State<PitScout> createState() => PitScoutState();
}

class PitScoutState extends State<PitScout> {
  Widget buildPitTextBox({
    required String title,
    required String jsonKey,
    required double height,
    required double width,
    bool numeric = false,
    String defaultText = "Enter Text",
    required double fontSize,
    required int maxLines,
    String? autoFill,
    String? hintText,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colors.container,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: NRGTextbox(
        title: title,
        jsonKey: jsonKey,
        height: height,
        width: width,
        numeric: numeric,
        defaultText: defaultText,
        fontSize: fontSize,
        maxLines: maxLines,
        autoFill: autoFill,
        hintText: hintText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataEntryPage(
      name: "Pit",
      pages: {
        "Setup": DataEntrySubPage(
          icon: CustomIcons.pitCrew,
          content: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                spacing: 10,
                children: [
                  Container(
                    height: 70,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.colors.container,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InputTextBox(
                      maxLines: 1,
                      hintText: "Scouter name",
                      jsonKey: "scouterName",
                      autofillKey: "scouterName",
                    ),
                  ),
                  TeamInfo(),
                ],
              )),
        ),
        "General": DataEntrySubPage(
            icon: CustomIcons.wrench,
            content: Container(
              margin: EdgeInsets.all(15),
              child: Column(spacing: 10, children: [
                MultiChoiceSelector(
                  title: "Shooter Type",
                  selectOptions: ["Fixed", "Turret"],
                  height: 90,
                  jsonKey: "shooterType",
                ),
                MultiChoiceSelector(
                    title: "Intake Type",
                    selectOptions: ["Ground", "Outpost"],
                    height: 90,
                    jsonKey: "intakeType"),
                buildPitTextBox(
                  numeric: true,
                  title: "Fuel Capacity",
                  jsonKey: "fuelCapacity",
                  height: 60,
                  width: double.infinity,
                  fontSize: 20,
                  maxLines: 1,
                ),
                buildPitTextBox(
                    numeric: true,
                    title: "Balls per Second",
                    jsonKey: "bps",
                    height: 60,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 1),
                buildPitTextBox(
                    numeric: true,
                    title: "Weight (lbs) (w/ bump + batt)",
                    jsonKey: "weight",
                    height: 60,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 1),
                buildPitTextBox(
                    numeric: true,
                    title: "Width (in) (w/ bump)",
                    jsonKey: "width",
                    height: 60,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 1),
                buildPitTextBox(
                    numeric: true,
                    title: "Length (in) (w/ bump)",
                    jsonKey: "length",
                    height: 60,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 1),
                buildPitTextBox(
                    numeric: false,
                    title: "Drivetrain description",
                    jsonKey: "drivetrain",
                    height: 60,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 1),
                buildPitTextBox(
                    numeric: false,
                    title: "Describe Mechanisms",
                    jsonKey: "mechanisms",
                    height: 120,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 20),
              ]),
            )),
        "Auto": DataEntrySubPage(
          icon: CustomIcons.autonomous,
          content: Container(
            margin: EdgeInsets.all(15),
            child: Column(spacing: 10, children: [
              PitAutoContainer(
                height: 50,
                jsonKeys: ["autoPath", "autoFuelScored", "autoCrossedMidline"],
                childBuilder: (index) => Column(
                  spacing: 10,
                  children: [
                    RebuiltAutoPathSelector(
                      margin: 7,
                      jsonKey: "autoPath${(index + 1)}",
                      pit: true,
                      nodeScalingFactor: 0.7,
                    ),
                    buildPitTextBox(
                        numeric: true,
                        title: "Fuel Scored",
                        jsonKey: "autoFuelScored${(index + 1)}",
                        height: 60,
                        width: double.infinity,
                        fontSize: 20,
                        maxLines: 1),
                    DefaultContainer(
                      color: context.colors.container,
                      child: AspectRatio(
                          aspectRatio: 8,
                          child: CustomCheckbox(
                            title: "Crossed Midline",
                            jsonKey: "autoCrossedMidline${(index + 1)}",
                            selectColor: context.colors.container,
                            optionColor: context.colors.accent1,
                          )),
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
            margin: EdgeInsets.all(15),
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
                  jsonKey: [
                    "canShootTrench",
                    "canShootHub",
                    "canShootTower",
                    "canShootAnywhere"
                  ],
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
                ),
                NRGMultiThreeStageCheckbox(
                  title: "Feeding",
                  jsonKey: [
                    "canPass",
                    "canPushOverBump",
                    "canPushThroughTrench"
                  ],
                  width: double.infinity,
                  height: 130,
                  boxNames: [
                    ["Pass", "Bump", "Trench"]
                  ],
                ),
                buildPitTextBox(
                    numeric: true,
                    title: "Cycle Time",
                    jsonKey: "cycleTime",
                    height: 60,
                    width: double.infinity,
                    fontSize: 20,
                    maxLines: 1),
              ],
            ),
          ),
        ),
        "Endgame": DataEntrySubPage(
          icon: CustomIcons.flag,
          content: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                spacing: 10,
                children: [
                  TowerLocationSelector(
                    margin: 10,
                    jsonKey: "climb",
                  ),
                  NRGMultiThreeStageCheckbox(
                    title: "Shooting",
                    jsonKey: [
                      "canShootEndgame",
                    ],
                    width: double.infinity,
                    height: 100,
                    boxNames: [
                      ["Shoot during Endgame"]
                    ],
                  ),
                  NRGCommentBox(
                    title: "Comments",
                    jsonKey: "comments",
                    height: 90,
                  ),
                ],
              )),
        )
      },
    );
  }
}
