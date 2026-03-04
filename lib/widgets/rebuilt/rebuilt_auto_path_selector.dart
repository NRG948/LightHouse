import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/game_agnostic/auto_path_selector.dart';

class RebuiltAutoPathSelector extends StatelessWidget {
  final bool debug;
  final String? jsonKey; 
  final double? margin;
  final bool flipField;
  final bool viewOnly;
  final List<dynamic>? initialPath;
  final bool pit;

  const RebuiltAutoPathSelector(
      {
    super.key,
    this.debug = false,
    this.margin,
    this.flipField = false,
    this.viewOnly = false,
    this.initialPath,
  , required this.pit, this.jsonKey});

  List<Zone> getZones() {
    return [
      Zone(id: "depot", top: 148, left: 14, width: 86, height: 78),
      Zone(id: "outpost", top: 527, left: 0, width: 110, height: 71),
      Zone(id: "tower", top: 302, left: 14, width: 140, height: 87),
      Zone(id: "trench_depot", top: 34, left: 337, width: 91, height: 108),
      Zone(id: "bump_depot", top: 142, left: 337, width: 91, height: 136),
      Zone(id: "bump_outpost", top: 369, left: 337, width: 91, height: 136),
      Zone(id: "trench_outpost", top: 506, left: 337, width: 91, height: 109),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AutoPathSelector(
      imageFilePath: "assets/images/rebuiltFullField.png",
      rawImageWidth: 700,
      rawImageHeight: 647,
      maximumGroupSize: 4,
      debug: debug,
      margin: margin,
      zones: getZones(),
      showClimbOptions: true,
      pit: pit,
      jsonKey: jsonKey ?? "autoPath",
      flipField: flipField,
      imageScalingFactor: viewOnly ? 1 : 0.75,
      viewOnly: viewOnly,
      initialPath: initialPath,
      converter: AutoPathSelector.getConverterFromPoints(
          Offset(52, 617), // Bottom left corner
          Offset(0, 0),
          Offset(379, 325), // Center of hub
          Offset(4.621, 4.029)),
    );
  }
}
