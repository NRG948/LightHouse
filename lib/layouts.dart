/** 
 * This file is a bygone relic of the 2025 season
 * Unfortunately, large parts of the code still rely on it
 * Because we're stupid
 * At some point, this will be removed
*/

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/widgets/game_agnostic/scrollable_box.dart';

Map<String, dynamic> dataViewer = {
  "title": "Data Viewer",
  "pages": [
    {
      "title": "bing chilling",
      "icon": CustomIcons.chartBar,
      "widgets": [
        {
          "title": "Barchart Test",
          "type": "barchart",
          "height": "70",
          "multiColor": [
            Constants.pastelRed,
            Constants.pastelYellow,
            Constants.pastelBlue
          ],
          "multiChartData": () {
            SplayTreeMap<int, List<double>> data = SplayTreeMap();
            data.addAll({
              1: [5, 0, 1],
              8: [2, 2, 2],
              13: [4, 1, 1],
              16: [3, 2, 3],
              27: [1, 0, 3],
              38: [3, 1, 1],
              43: [5, 1, 1],
              47: [2, 2, 4],
              58: [0, 1, 1],
              65: [1, 0, 2],
            });
            return data;
          }(),
          "chartRemovedData": [8, 27, 58]
        },
        {
          "type": "row",
          "height": "50",
          "children": [
            {
              "title": "Barchart Test",
              "type": "barchart",
              "width": "42",
              "color": Constants.pastelRed,
              "chartData": () {
                SplayTreeMap<int, double> data = SplayTreeMap();
                data.addAll({
                  1: 5,
                  8: 2,
                  13: 4,
                  16: 3,
                  27: 1,
                  38: 3,
                  43: 5,
                  47: 2,
                  58: 0,
                  65: 1,
                });
                return data;
              }(),
              "chartRemovedData": [8, 27, 58]
            },
            {
              "type": "spacer",
              "width": "2",
            },
            {
              "title": "Barchart Test",
              "type": "barchart",
              "width": "42",
              "multiColor": [
                Colors.deepPurple,
                Colors.purple,
                Colors.purpleAccent,
                const Color.fromARGB(255, 244, 83, 195)
              ],
              "multiChartData": () {
                SplayTreeMap<int, List<double>> data = SplayTreeMap();
                data.addAll({
                  1: [5, 5, 2, 7],
                  8: [2, 7, 3, 6],
                  13: [4, 1, 6, 2],
                  16: [3, 1, 2, 6],
                  27: [1, 3, 1, 7],
                  38: [3, 6, 2, 7],
                  43: [5, 2, 1, 2],
                  47: [2, 1, 3, 8],
                  58: [1, 1, 1, 1],
                  65: [5, 2, 1, 3],
                });
                return data;
              }(),
              "chartRemovedData": [8, 27, 58]
            }
          ]
        },
        {
          "type": "scrollable-box",
          "height": "40",
          "title": "Comments",
          "sortType": Sort.LATEST,
          "comments": [
            ["Jeffery", "oh yeah that was one of the moments of all time", "5"],
            ["Bezos", "absolute cinema", "11"],
            [
              "Banana",
              "sigma sigma on the wall who is the skibidiest of them all lorem ipsum sussy baka",
              "20"
            ],
            [
              "Morbius",
              "Oh yeah it's morbin time im gonna morb all over the place",
              "43"
            ],
            [
              "Barry B. Benson",
              "According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees don't care what humans think is impossible.",
              "32"
            ],
            [
              "Michael VSauce",
              "Hey, Vsauce, Michael here. If you ate yourself, would you vanish or become infinitely full? Self-cannibalism isn’t just culinary—topologically, it’s a strange loop. Your body, like a Möbius strip, folds into itself, blurring ‘inside’ and ‘outside.’ Are you food, eater, or both? Or is digestion a metaphor for existence itself?",
              "1"
            ]
          ]
        }
      ]
    }
  ]
};

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
