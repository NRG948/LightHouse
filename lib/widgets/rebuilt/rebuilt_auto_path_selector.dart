import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/rebuilt/auto_path_selector.dart';

class RebuiltAutoPathSelector extends StatelessWidget {
  const RebuiltAutoPathSelector({super.key});

  List<Zone> getZones() {
    return [
      Zone(id: "depot", top: 148, left: 14, width: 86, height: 78),
      Zone(id: "outpost", top: 527, left: 0, width: 56, height: 70),
      Zone(id: "tower", top: 302, left: 14, width: 120, height: 87),
      Zone(id: "trench_depot", top: 34, left: 337, width: 91, height: 108),
      Zone(id: "bump_depot", top: 142, left: 337, width: 91, height: 136),
      Zone(id: "bump_outpost", top: 369, left: 337, width: 91, height: 136),
      Zone(id: "trench_outpost", top: 506, left: 337, width: 91, height: 108),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AutoPathSelector(
        imageFilePath: "assets/images/rebuildFieldMap.png",
        width: 300,
        rawImageWidth: 464,
        rawImageHeight: 647,
        maximumGroupSize: 4,
        zones: getZones());
  }
}
