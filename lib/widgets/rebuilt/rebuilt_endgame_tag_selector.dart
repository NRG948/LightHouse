import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/game_agnostic/endgame_tag_selector.dart';

class RebuiltEndgameTagSelector extends StatelessWidget {
  final bool debug;

  const RebuiltEndgameTagSelector({super.key, this.debug = false});

  List<String> getPossibleTags() {
    return [
      "prefer bump",
      "prefer trench",
      "fouled",
      "disabled",
      "robot issues",
      "beached on fuel",
      "stuck on bump",
      "high game sense",
      "poor game sense",
      "rush center auto",
      "wanders",
      "no show",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NRGEndgameTagSelector(possibleTags: getPossibleTags());
  }
}
