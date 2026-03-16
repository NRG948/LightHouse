import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/box_region.dart';
import 'package:lighthouse/widgets/game_agnostic/location_tracker.dart';
import 'package:lighthouse/widgets/rebuilt/cycle_list_counter.dart';

class RebuiltLocationTracker extends StatelessWidget {
  final String? jsonKey;
  final double? margin;
  final bool viewOnly;
  final Map<String, Color>? assignedColors;

  const RebuiltLocationTracker({
    super.key,
    this.jsonKey,
    this.margin,
    this.viewOnly = false,
    this.assignedColors,
  });

  List<Zone> getZones() {
    return [
      Zone(id: "depot_corner", top: 34, left: 45, width: 200, height: 108),
      Zone(id: "depot_trench", top: 34, left: 245, width: 140, height: 108),
      Zone(id: "depot_wall", top: 142, left: 45, width: 160, height: 168),
      Zone(id: "depot_bump", top: 142, left: 205, width: 132, height: 137),
      Zone(id: "tower", top: 310, left: 124, width: 81, height: 71),
      Zone(id: "hub", top: 279, left: 205, width: 132, height: 102),
      Zone(id: "outpost_wall", top: 381, left: 45, width: 160, height: 126),
      Zone(id: "outpost_bump", top: 381, left: 205, width: 132, height: 126),
      Zone(id: "outpost_corner", top: 507, left: 45, width: 200, height: 118),
      Zone(id: "outpost_trench", top: 507, left: 245, width: 140, height: 118),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LocationTracker(
      jsonKey: jsonKey,
      imageFilePath: "assets/images/rebuildFieldMap.png",
      rawImageWidth: 464,
      rawImageHeight: 647,
      zones: getZones(),
      margin: margin,
      viewOnly: viewOnly,
      assignedColors: assignedColors,
      childBuilder: (context, regionId, onUpdate) {
        return Column(
          children: [
            Text(
              "Accuracy",
              style: comfortaaBold(17, color: Constants.pastelBrown),
            ),
            Expanded(
              child: CycleListCounter(
                regionId: regionId,
                onUpdate: onUpdate,
                isLocked: regionId == null,
              ),
            ),
          ],
        );
      },
    );
  }
}
