import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/models/rebuilt/location_tracker_data.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/box_region.dart';
import 'package:lighthouse/widgets/game_agnostic/location_tracker.dart';
import 'package:lighthouse/widgets/rebuilt/cycle_list_counter.dart';

class RebuiltLocationTracker extends StatelessWidget {
  final LocationTrackerData data;
  final double? margin;
  final bool viewOnly;
  final Map<String, Color>? assignedColors;
  final Color? mapColor;
  final bool flipField;

  const RebuiltLocationTracker({
    super.key,
    required this.data,
    this.margin,
    this.viewOnly = false,
    this.assignedColors,
    this.mapColor,
    this.flipField = false,
  });

  List<LocationTrackerZone> getZones() {
    return [
      LocationTrackerZone(
          id: LocationZoneId.depotCorner,
          top: 34,
          left: 45,
          width: 200,
          height: 108),
      LocationTrackerZone(
          id: LocationZoneId.depotTrench,
          top: 34,
          left: 245,
          width: 140,
          height: 108),
      LocationTrackerZone(
          id: LocationZoneId.depotWall,
          top: 142,
          left: 45,
          width: 160,
          height: 168),
      LocationTrackerZone(
          id: LocationZoneId.depotBump,
          top: 142,
          left: 205,
          width: 132,
          height: 137),
      LocationTrackerZone(
          id: LocationZoneId.tower, top: 310, left: 124, width: 81, height: 71),
      LocationTrackerZone(
          id: LocationZoneId.hub, top: 279, left: 205, width: 132, height: 102),
      LocationTrackerZone(
          id: LocationZoneId.outpostWall,
          top: 381,
          left: 45,
          width: 160,
          height: 126),
      LocationTrackerZone(
          id: LocationZoneId.outpostBump,
          top: 381,
          left: 205,
          width: 132,
          height: 126),
      LocationTrackerZone(
          id: LocationZoneId.outpostCorner,
          top: 507,
          left: 45,
          width: 200,
          height: 118),
      LocationTrackerZone(
          id: LocationZoneId.outpostTrench,
          top: 507,
          left: 245,
          width: 140,
          height: 118),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LocationTracker(
      data: data,
      imageFilePath: "assets/images/rebuildFieldMap.png",
      rawImageWidth: 464,
      rawImageHeight: 647,
      zones: getZones(),
      margin: margin,
      viewOnly: viewOnly,
      assignedColors: assignedColors,
      mainColor: mapColor,
      flipField: flipField,
      childBuilder: (context, regionId, onUpdate) {
        return Column(
          children: [
            Text(
              "Accuracy",
              style: comfortaaBold(17, color: context.colors.containerText),
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
