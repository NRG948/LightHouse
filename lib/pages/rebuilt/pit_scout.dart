import 'package:flutter/material.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';

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
        "placeholder": DataEntrySubPage(
          icon: CustomIcons.pitCrew,
          content: Container(
              child: NRGPlaceholder(
                  title: "pit", jsonKey: "pit", height: 5, width: 50)),
        )
      },
    );
  }
}
