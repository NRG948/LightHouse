/**
 * This file is a bygone relic of the 2025 season
 * Unfortunately, large parts of the code still rely on it
 * Because we're stupid
 * At some point, this will be removed
*/

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

const Map<String, IconData> iconMap = {
  "Atlas": Icons.public,
  "Chronos": Icons.timer,
  "Pit": Icons.analytics_rounded,
  "Human Player": Icons.child_care,
  "Data Viewer": Icons.account_box_rounded,
};

Map<String, Color> colorMap = {
  "Atlas": Constants.pastelRed,
  "Chronos": Constants.pastelYellow,
  "Pit": Constants.pastelGray,
  "Human Player": Constants.pastelGreen,
  "Data Viewer": Constants.pastelYellow,
  "View Saved Data": Constants.pastelGray,
  "Sync to Server": Constants.pastelBlue
};

class DESharedState extends ChangeNotifier {
  void triggerUpdate() {
    notifyListeners();
  }
}
