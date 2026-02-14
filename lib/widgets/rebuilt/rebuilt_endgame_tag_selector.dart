import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/game_agnostic/endgame_tag_selector.dart';

class RebuiltEndgameTagSelector extends StatelessWidget {
  final bool debug;

  const RebuiltEndgameTagSelector({super.key, this.debug = false});

  List<String> getPossibleTags() {
    return [
      "defense",
      "climb",
      "passing",
      "shoot while moving",  
      "ground intake", 
      "outpost intake", 
      "shoot from anywhere", 
      "shoot from hub", 
      "beached on fuel"
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NRGEndgameTagSelector(possibleTags: getPossibleTags());
  }
}
