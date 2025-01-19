import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';

Map<String, dynamic> atlascout = {
  "title": "Atlascout",
  "pages": [
    {
      "title": "Setup",
      "icon": Icon(CustomIcons.wrench),
      "widgets": [
        {
          "title": "Scouter Name",
          "type": "textbox",
          "jsonKey": "scouterName", 
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Team Number",
              "type": "numberbox",
              "jsonKey": "teamNumber",
              "width": "42"
            },
            {
              "type": "spacer", 
              "width": "2"
            }, 
            {
              "title": "Driver Station",
              "type": "dropdown",
              "options": "Red 1,Red 2,Red 3,Blue 1,Blue 2,Blue3",
              "jsonKey": "driverStation",
              "width": "42", 
              "height": "84", 
            }
          ]
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Match Type",
              "type": "dropdown",
              "options": "Qualifications,Playoffs,Finals", 
              "jsonKey": "matchType",
              "width": "42"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Match Number",
              "type": "textbox",
              "jsonKey": "matchNumber",
              "width": "20"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Replay",
              "type": "placeholder",
              "jsonKey": "replay",
              "width": "20"
            }
          ]
        },
        {
          "title": "Starting Position",
          "type": "placeholder",
          "jsonKey": "startingPosition",
          "height": "30"
        },
        {"title": "Preload", "type": "placeholder", "jsonKey": "preload"}
      ]
    },
    {
      "title": "Auto",
      "icon": Icon(CoralAlgaeIcons.autonomous),
      "widgets": [
        {
          "type": "rsAutoUntimed",
          "jsonKey": ["autoProcessorCS","autoBargeCS","autoCoralScored","autoAlgaeRemoved","autoCoralScoredL1"],
          "height": "60", 
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": Icon(CoralAlgaeIcons.teleop),
      "widgets": [
        {
          "title": "Coral Pickups",
          "type": "multispinbox",
          "jsonKey": [
            "coralPickupsStation",
            "coralPickupsGround",
          ],
          "height": "40",
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
            "coralScoredL4"
          ],
          "height": "40",
          "boxNames": [
            ["L1", "L2", "L3", "L4"]
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
            ["Remove L2", "Remove L3", "Score Processor", "Score Net"],
            ["Miss Processor", "Miss Net"]
          ]
        }
      ]
    },
    {
      "title": "Endgame",
      "icon": Icon(CustomIcons.flag),
      "widgets": [
        {
          "title": "End Location",
          "type": "placeholder",
          "jsonKey": "endLocation"
        },
        {
          "title": "[ ] Attempted Climb?",
          "type": "placeholder",
          "jsonKey": "attemptedClimb"
        },
        {
          "title": "Climb Start time",
          "type": "placeholder",
          "jsonKey": "climbStartTime"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Robot Disabled",
              "type": "placeholder",
              "jsonKey": "robotDisabled",
              "width": "32"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Reason for robot disable",
              "type": "placeholder",
              "jsonKey": "robotDisableReason",
              "width": "52"
            }
          ]
        },
        {
          "title": "Data Quality",
          "type": "placeholder",
          "jsonKey": "dataQuality"
        },
        {"title": "Comments", "type": "placeholder", "jsonKey": "comments"},
        {
          "title": "[ ] Team crossed over midline?",
          "type": "placeholder",
          "jsonKey": "crossedMidline"
        }
      ]
    }
  ]
};

Map<String, dynamic> chronoscout = {
  "title": "Chronoscout",
  "pages": [
    {
      "title": "HorizontalTest", //Test page for horizontal stuff. REMOVE FOR PRODUCTION
      "icon": Icon(CustomIcons.pitCrew), 
      "widgets": [
        {
          "title": "hiiiiii",
          "type": "stopwatch-horizontal",
          "jsonKey": "random",
        }
      ]
    },
    {
      "title": "Setup",
      "icon": Icon(CustomIcons.wrench),
      "widgets": [
        {
          "title": "Scouter Name",
          "type": "placeholder",
          "jsonKey": "scouterName"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Team Number",
              "type": "placeholder",
              "jsonKey": "scouterName",
              "width": "34"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Driver Station",
              "type": "placeholder",
              "jsonKey": "driverStation",
              "width": "50"
            }
          ]
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Match Type",
              "type": "placeholder",
              "jsonKey": "matchType",
              "width": "30"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Match Number",
              "type": "placeholder",
              "jsonKey": "matchNumber",
              "width": "20"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Replay",
              "type": "placeholder",
              "jsonKey": "replay",
              "width": "32"
            }
          ]
        },
        {
          "title": "Starting Position",
          "type": "placeholder",
          "jsonKey": "startingPosition",
          //Deleted "height" field... Not sure why needed. No idea what type this should be. -Sean
        },
        {"title": "Start match guided", "type": "placeholder", "jsonKey": ""}
      ]
    },
    {
      "title": "Auto",
      "icon": Icon(CustomIcons.autonomous),
      "widgets": [
        {
          "title": "big boy auto widget",
          "type": "placeholder",
          "jsonKey": "idkYet",
        },
        {
          "title": "Timer",
          "type": "stopwatch",
          "jsonKey": "shouldThisBeSeparate"
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": Icon(CustomIcons.gamepad),
      "widgets": [
        {
          "title": "big boy teleop widget",
          "type": "placeholder",
          "jsonKey": "idkYet",
        },
        {
          "title": "Timer",
          "type": "placeholder",
          "jsonKey": "shouldThisBeSeparate"
        }
      ]
    },
    {
      "title": "Endgame",
      "icon": Icon(CustomIcons.flag),
      "widgets": [
        {
          "title": "General Match Strategy",
          "type": "dropdown",
          "jsonKey": "generalStrategy",
          "options": "Cycling,Defense,Feed/Pass,Other"
        },
        {
          "title": "Data Quality (5 star rating)",
          "type": "placeholder",
          "jsonKey": "dataQuality"
        },
        {"title": "Comments", "type": "textbox", "jsonKey": "comments"}
      ]
    }
  ]
};

Map<String, dynamic> pitscout = {
  "title": "Pit Scout",
  "pages": [
    {
      "title": "Initial Info",
      "icon": Icon(CustomIcons.chartBar),
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
      "icon": Icon(CustomIcons.wrench),
      "widgets": [
        {"title": "", "type": "placeholder", "jsonKey": "teamNumber"}
      ]
    },
    {
      "title": "Auto",
      "icon": Icon(CustomIcons.autonomous),
      "widgets": [
        {
          "title": "Auto Routine",
          "type": "placeholder",
          "jsonKey": "teamNumber",
        },
        {
          "title": "Drops Algae on Ground",
          "type": "placeholder",
          "jsonKey": "dropsAlgaeAuto"
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": Icon(CustomIcons.gamepad),
      "widgets": [
        {
          "title": "Coral Scoring Ability",
          "type": "placeholder",
          "jsonKey": "coralScoringAbility"
        },
        {
          "title": "Coral Intake Ability",
          "type": "placeholder",
          "jsonKey": "coralIntakeAbility"
        },
        {
          "title": "Algae Removal Ability",
          "type": "placeholder",
          "jsonKey": "algaeRemovalAbility"
        },
        {
          "title": "Algae Scoring Ability",
          "type": "placeholder",
          "jsonKey": "algaeScoringAbility"
        }
      ]
    },
    {
      "title": "Endgame",
      "icon": Icon(CustomIcons.flag),
      "widgets": [
        {
          "title": "Climbing Ability and Preference",
          "type": "placeholder",
          "jsonKey": "climbingAbilityAndPreference",
          "height": "80"  
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
      "icon": Icon(CustomIcons.racecar),
      "widgets": [
        {
          "title": "Driver and Manipulator Experience",
          "type": "textbox",
          "jsonKey": "driveExperience"
        },
        {
          "title": "Preferred Human Player Station",
          "type": "placeholder",
          "jsonKey": "humanPlayerPreference"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Average Coral Cycles",
              "type": "placeholder",
              "jsonKey": "averageCoralCycles",
              "width": "42"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Average Algae Cycles",
              "type": "placeholder",
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
      "icon": Icon(CustomIcons.wrench),
      "widgets": [
        {
          "title": "Scouter Name",
          "type": "placeholder",
          "jsonKey": "scouterName"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Red Team Number",
              "type": "placeholder",
              "jsonKey": "redHPTeam",
              "width": "42"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Blue Team Number",
              "type": "placeholder",
              "jsonKey": "blueHPTeam",
              "width": "42"
            }
          ]
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Match Type",
              "type": "placeholder",
              "jsonKey": "matchType",
              "width": "30"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Match Number",
              "type": "placeholder",
              "jsonKey": "matchNumber",
              "width": "30"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Replay",
              "type": "placeholder",
              "jsonKey": "replay",
              "width": "22"
            }
          ]
        }
      ]
    },
    {
      "title": "Scoring",
      "icon": Icon(CustomIcons.gamepad),
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
      "icon": Icon(CustomIcons.chartBar),
      "widgets": [
        {
          "title": "Barchart Test",
          "type": "barchart",
          "height": "60",
          "multiColor": [Constants.pastelRed, Constants.pastelYellow],
          "multiChartData": () {
            SplayTreeMap<int, List<double>> data = SplayTreeMap();
            data.addAll({
              1: [5, 0],
              8: [2, 2],
              13: [4, 1],
              16: [3, 2],
              27: [1, 0],
              38: [3, 1],
              43: [5, 1],
              47: [2, 2],
              58: [0, 1],
              65: [1, 0],
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
              "width": "190",
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
              "title": "Barchart Test",
              "type": "barchart",
              "width": "190",
              "multiColor": [Colors.deepPurple, Colors.purple, Colors.purpleAccent, const Color.fromARGB(255, 244, 83, 195)],
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
              }()
            }
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
  "Atlas": Icons.map,
  "Chronos": Icons.timer,
  "Pit": Icons.analytics_rounded,
  "Human Player": Icons.child_care,
  "Data Viewer": Icons.account_box_rounded
};
