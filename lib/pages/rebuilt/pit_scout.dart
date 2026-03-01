import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/multi_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/team_info.dart';
import 'package:lighthouse/widgets/rebuilt/metric.dart';

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
              margin: EdgeInsets.all(15),
              child: Column(
                spacing: 15,
                children: [
                  MultiChoiceSelector(title: "Shooter Type", selectOptions: ["Fixed", "Turret"], height: 100, jsonKey: "shooterType",), 
                  MultiChoiceSelector(title: "Intake Type", selectOptions: ["Ground", "Outpost"], height: 100, jsonKey: "intakeType")
                ]
              ),
            ))
      },
    );
  }
}
