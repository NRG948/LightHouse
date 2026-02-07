import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/game_agnostic/endgame_tag_selector.dart';

class RebuiltEndgameTagSelector extends StatelessWidget {
  final bool debug;

  const RebuiltEndgameTagSelector({super.key, this.debug = false});

  List<String> getPossibleTags() {
    return [
      "defense",
      "climb",
      "passed",
      "stop reading this",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NRGEndgameTagSelector(possibleTags: getPossibleTags());
  }
}
