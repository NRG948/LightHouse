import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/widgets/game_agnostic/scrollable_box.dart';

Map<String, dynamic> atlascout = {
  "title": "Atlascout",
  "pages": [
    {
      "title": "Setup",
      "icon": CustomIcons.wrench,
      "widgets": [
        {
          "title": "Scouter Name",
          "type": "textbox",
          "jsonKey": "scouterName",
        },
        {
          "type": "matchInfo",
          "jsonKey": ["teamNumber", "driverStation", "matchType", "matchNumber", "replay"]
        },
        
        {
          "title": "Starting Position",
          "type": "startPos",
          "jsonKey": "startingPosition",
          "height": "30"
        },
        {"title": "Preload", "type": "checkbox", "jsonKey": "preload","height":"10"}
      ]
    },
    {
      "title": "Auto",
      "icon": CoralAlgaeIcons.autonomous,
      "widgets": [
        {
          "type": "rsAutoUntimed",
          "jsonKey": [
            "autoProcessorCS",
            "autoBargeCS",
            "autoCoralScored",
            "autoAlgaeRemoved",
            "autoCoralScoredL1"
          ],
          "height": "60",
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": CoralAlgaeIcons.teleop,
      "widgets": [
        {
          "title": "Coral Pickups",
          "type": "multispinbox",
          "jsonKey": [
            "coralPickupsStation",
            "coralPickupsGround",
          ],
          "height": "30",
          "boxNames": [
            ["Station", "Ground"]
          ]
        },
        {
          "title": "Coral Scored",
          "type": "multispinbox",
          "jsonKey": [
            "coralScoredL1",
            "coralScoredL2",
            "coralScoredL3",
            "coralScoredL4",
          ],
          "height": "43",
          "boxNames": [
            ["L1", "L2"],
            ["L3", "L4"]
          ]
        },
        {
          "title": "Algae",
          "type": "multispinbox",
          "jsonKey": [
            "algaeremoveL2",
            "algaeremoveL3",
            "algaescoreProcessor",
            "algaescoreNet",
            "algaemissProcessor",
            "algaemissNet"
          ],
          "height": "65",
          "boxNames": [
            ["Remove L2", "Remove L3"],
            ["Score Processor", "Score Net"],
            ["Miss Processor", "Miss Net"]
          ]
        }
      ]
    },
    {
      "title": "Endgame",
      "icon": CustomIcons.flag,
      "widgets": [
        {
          "title": "End Location",
          "type": "dropdown",
          "options": "None,Park,Deep Climb,Shallow Climb",
          "jsonKey": "endLocation"
        },
        {
          "title": "Attempted Climb?",
          "type": "checkbox",
          "jsonKey": "attemptedClimb",
          "height": "10"
        },
        {
          "title": "Climb Start time",
          "type": "numberbox",
          "jsonKey": "climbStartTime"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Robot Disabled",
              "type": "checkbox_vertical",
              "jsonKey": "robotDisabled",
              "width": "20"
            },
            {
              "type": "spacer",
              "width": "2",
            },
            {
              "title": "Reason?",
              "type": "textbox",
              "jsonKey": "robotDisableReason",
              "width": "48",
              "maxLines": 2,
              "fontSize": 15.0
            }
          ]
        },
        {"title": "Data Quality", "type": "dataQuality", "jsonKey": "dataQuality"},
        {"title": "Comments", "type": "textbox", "jsonKey": "comments","height":"10","fontSize":15.0,"maxLines":3},
        {
          "title": "Team crossed over midline?",
          "type": "checkbox",
          "jsonKey": "crossedMidline",
          "height": "10"
        }
      ]
    }
  ]
};

Map<String, dynamic> chronoscout = {
  "title": "Chronoscout",
  "pages": [
    {
      "title": "Setup",
      "icon": CustomIcons.wrench,
      "widgets": [
        {
          "title": "Scouter Name",
          "type": "textbox",
          "jsonKey": "scouterName",
        },
        {
          "type": "matchInfo",
          "jsonKey": ["teamNumber", "driverStation", "matchType", "matchNumber", "replay"]
        },
        
        {
          "title": "Starting Position",
          "type": "startPos",
          "jsonKey": "startingPosition",
          "height": "30"
        },
        
        {
          "type": "guidance-start", 
        }, 
      ]
    },
    {
      "title": "Auto",
      "icon": CoralAlgaeIcons.autonomous,
      "widgets": [
        {
          "title": "big boy auto widget",
          "type": "rsAutoTimed",
          "jsonKey": "autoEventList",
        },
        {
          "title": "Timer",
          "type": "stopwatch",
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": CoralAlgaeIcons.teleop,
      "widgets": [
        {
          "title": "big boy teleop widget",
          "type": "rsTeleopTimed",
          "jsonKey": "teleopEventList",
        },
        {
          "title": "Timer",
          "type": "stopwatch",
        }
      ]
    },
    {
      "title": "Endgame",
      "icon": CustomIcons.flag,
      "widgets": [
        {
          "title": "General Strategy",
          "type": "dropdown",
          "jsonKey": "generalStrategy",
          "options": "Cycling,Defense,Feed/Pass,Other"
        },
        {
          "title": "Data Quality",
          "type": "dataQuality",
          "jsonKey": "dataQuality"
        },
        {"title": "Comments", "type": "textbox", "jsonKey": "comments","maxLines":20,"fontSize":15.0,"height":"100"}
      ]
    }
  ]
};

Map<String, dynamic> pitscout = {
  "title": "Pit Scout",
  "pages": [
    {
      "title": "Initial Info",
      "icon": CustomIcons.chartBar,
      "widgets": [
        {"title": "Team Number", "type": "textbox", "jsonKey": "teamNumber"},
        {"title": "Team Name", "type": "textbox", "jsonKey": "teamName"},
        {
          "title": "Interviewee Name",
          "type": "textbox",
          "jsonKey": "intervieweeName"
        },
        {
          "title": "Interviewer Name",
          "type": "textbox",
          "jsonKey": "interviewerName"
        }
      ]
    },
    {
      "title": "Robot Stats",
      "icon": CustomIcons.wrench,
      "widgets": [
        {
          "title": "Robot Height (in)",
          "type": "numberbox",
          "jsonKey": "robotHeight"
        },
        {
          "title": "Robot Length (in)",
          "type": "numberbox",
          "jsonKey": "robotLength"
        },
        {
          "title": "Robot Width (in)",
          "type": "numberbox",
          "jsonKey": "robotWidth"
        },
        {
          "title": "Robot Weight (lbs)",
          "type": "numberbox",
          "jsonKey": "robotWeight"
        },
        {
          "title": "Drivetrain",
          "type": "textbox",
          "jsonKey": "robotDrivetrain"
        },
        {
          "title": "Describe Robot Mechanisms",
          "type": "textbox",
          "jsonKey": "robotMechanisms"
        }
      ]
    },
    {
      "title": "Auto",
      "icon": CoralAlgaeIcons.autonomous,
      "widgets": [
        {
          "height": "40",
          "width": "60",
          "type": "rsAutoUntimedPit",
          "jsonKey": [
            "autoProcessorCS",
            "autoBargeCS",
            "autoCoralScored",
            "autoAlgaeRemoved",
            "autoCoralScoredL1"
          ],
        },
        {
          "title": "Drops Algae on Ground",
          "type": "checkbox",
          "jsonKey": "dropsAlgaeAuto"
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": CoralAlgaeIcons.teleop,
      "widgets": [
        {
          "title": "Coral Scoring Ability",
          "type": "multi-three-stage-checkbox",
          "jsonKey": [
            "coralScoringAbilityL1",
            "coralScoringAbilityL2",
            "coralScoringAbilityL3",
            "coralScoringAbilityL4"
          ],
          "boxNames": [
            ["L1", "L2", "L3", "L4"]
          ],
          "height": "20"
        },
        {
          "title": "Coral Intake Ability",
          "type": "multi-three-stage-checkbox",
          "jsonKey": ["canIntakeStation", "canIntakeGround"],
          "boxNames": [
            ["Station", "Ground"]
          ]
        },
        {
          "title": "Algae Removal Ability",
          "type": "multi-three-stage-checkbox",
          "jsonKey": ["canRemoveAlgaeL2", "canRemoveAlgaeL3"],
          "boxNames": [
            ["L2", "L3"]
          ]
        },
        {
          "title": "Algae Scoring Ability",
          "type": "multi-three-stage-checkbox",
          "jsonKey": [
            "canScoreProcessor",
            "canScorenet",
          ],
          "boxNames": [
            ["Processor", "Net"]
          ]
        }
      ]
    },
    {
      "title": "Endgame",
      "icon": CustomIcons.flag,
      "widgets": [
        {
          "title": "Climbing Ability and Preference",
          "type": "multi-three-stage-checkbox",
          "jsonKey": ["canClimbShallow", "canClimbDeep"],
          "boxNames": [
            ["Shallow", "Deep"]
          ]
        },
        {
          "title": "Average Climb Time",
          "type": "textbox",
          "jsonKey": "averageClimbTime",
        }
      ]
    },
    {
      "title": "Drive Team",
      "icon": CustomIcons.racecar,
      "widgets": [
        {
          "title": "Driver and Manipulator Experience",
          "type": "textbox",
          "jsonKey": "driveExperience"
        },
        {
          "title": "Preferred Human Player Station",
          "type": "dropdown",
          "options": "Processor,Processor Coral Station,Barge Coral Station",
          "jsonKey": "humanPlayerPreference"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Average Coral Cycles",
              "type": "numberbox",
              "jsonKey": "averageCoralCycles",
              "width": "42"
            },
            {
              "type": "spacer",
              "width": "2",
            },
            {
              "title": "Average Algae Cycles",
              "type": "numberbox",
              "jsonKey": "averageAlgaeCycles",
              "width": "42"
            }
          ]
        },
        {
          "title": "Ideal Qualities in Alliance Partners",
          "type": "textbox",
          "jsonKey": "idealAlliancePartnerQualities"
        },
        {
          "title": "Other Comments",
          "type": "textbox",
          "jsonKey": "otherComments"
        }
      ]
    }
  ]
};

Map<String, dynamic> hpscout = {
  "title": "Human Player Scout",
  "pages": [
    {
      "title": "Setup",
      "icon": CustomIcons.wrench,
      "widgets": [
        {"title": "Scouter Name", "type": "textbox", "jsonKey": "scouterName"},
        {
          "type": "row",
          "children": [
            {
              "title": "Red Team Number",
              "type": "numberbox",
              "jsonKey": "redHPTeam",
              "width": "42"
            },
            {
              "type": "spacer",
              "width": "2",
            },
            {
              "title": "Blue Team Number",
              "type": "numberbox",
              "jsonKey": "blueHPTeam",
              "width": "42"
            }
          ]
        },
        {
              "title": "Match Type",
              "type": "dropdown",
              "options": "Qualifications,Playoffs,Finals",
              "jsonKey": "matchType",
            
            },
             {
              "title": "Match Number",
              "type": "numberbox",
              "jsonKey": "matchNumber",
          
            },
            {
              "title": "Replay",
              "type": "checkbox",
              "jsonKey": "replay",

            }
      ]
    },
    {
      "title": "Scoring",
      "icon": CustomIcons.gamepad,
      "widgets": [
        {
          "type": "row",
          "height": "25",
          "children": [
            {
              "title": "Red Score",
              "type": "spinbox",
              "jsonKey": "redScore",
              "width": "42",
            },
            {
              "type": "spacer",
              "width": "2",
            },
            {
              "title": "Blue Score",
              "type": "spinbox",
              "jsonKey": "blueScore",
              "width": "42",
            }
          ]
        },
        {
          "type": "row",
          "height": "25",
          "children": [
            {
              "title": "Red Miss",
              "type": "spinbox",
              "jsonKey": "redMiss",
              "width": "42",
            },
            {
              "type": "spacer",
              "width": "2",
            },
            {
              "title": "Blue Miss",
              "type": "spinbox",
              "jsonKey": "blueMiss",
              "width": "42",
            }
          ]
        },
        {
          "title": "Algae in Net",
          "type": "multispinbox",
          "jsonKey": ["redNetAlgae", "blueNetAlgae"],
          "height": "40",
          "boxNames": [
            ["Red Algae", "Blue Algae"]
          ]
        }
      ]
    }
  ]
};

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



Map<String, Map> layoutMap = {
  "Atlas": atlascout,
  "Chronos": chronoscout,
  "Pit": pitscout,
  "Human Player": hpscout,
  "Data Viewer": dataViewer
};

Map<String, IconData> iconMap = {
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
  "Human Player": Constants.pastelRed,
  "Data Viewer": Constants.pastelYellow,
  "View Saved Data": Constants.pastelGray,
  "Sync to Server": Constants.pastelBlueAgain
};

Map<String, double> fontMap = {
  "Atlas": 25.0,
  "Chronos": 25.0,
  "Pit": 25.0,
  "Human Player": 25.0,
  "Data Viewer": 25.0,
};
