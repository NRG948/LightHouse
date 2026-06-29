import 'package:flutter/material.dart';
import 'package:lighthouse/models/general/auto_path_data.dart';
import 'package:lighthouse/models/general/point_data.dart';
import 'package:lighthouse/widgets/game_agnostic/auto_path_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/box_region.dart';

class RebuiltAutoPathSelector extends StatelessWidget {
  final bool debug;
  final AutoPathData data;
  final double? margin;
  final bool flipField;
  final bool viewOnly;
  final List<PointData>? initialPath;
  final bool pit;
  final double nodeScalingFactor;

  const RebuiltAutoPathSelector(
      {super.key,
      this.debug = false,
      this.margin,
      this.flipField = false,
      this.viewOnly = false,
      this.initialPath,
      this.pit = false,
      required this.data,
      this.nodeScalingFactor = 1});

  List<Zone> getZones() {
    return [
      Zone(id: AutoZoneId.depot, top: 148, left: 14, width: 86, height: 78),
      Zone(id: AutoZoneId.outpost, top: 527, left: 0, width: 110, height: 71),
      Zone(id: AutoZoneId.tower, top: 302, left: 14, width: 140, height: 87),
      Zone(
          id: AutoZoneId.trenchDepot,
          top: 34,
          left: 337,
          width: 91,
          height: 108),
      Zone(
          id: AutoZoneId.bumpDepot,
          top: 142,
          left: 337,
          width: 91,
          height: 136),
      Zone(
          id: AutoZoneId.bumpOutpost,
          top: 369,
          left: 337,
          width: 91,
          height: 136),
      Zone(
          id: AutoZoneId.trenchOutpost,
          top: 506,
          left: 337,
          width: 91,
          height: 109),
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
      showDetails: true,
      pit: pit,
      data: data,
      flipField: flipField,
      viewOnly: viewOnly,
      initialPath: initialPath,
      nodeScalingFactor: nodeScalingFactor,
      converter: AutoPathSelector.getConverterFromPoints(
          Offset(52, 617), // Bottom left corner
          Offset(0, 0),
          Offset(379, 325), // Center of hub
          Offset(4.621, 4.029)),
    );
  }
}
