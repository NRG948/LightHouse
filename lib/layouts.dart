import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';

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
        // {
        //   "type": "row",
        //   "children": [
        //     {
        //       "title": "Team Number",
        //       "type": "numberbox",
        //       "jsonKey": "teamNumber",
        //       "width": "42"
        //     },
        //     {
        //       "type": "spacer", 
        //       "width": "2"
        //     }, 
        //     {
        //       "title": "Driver Station",
        //       "type": "dropdown",
        //       "options": "Red 1,Red 2,Red 3,Blue 1,Blue 2,Blue3",
        //       "jsonKey": "driverStation",
        //       "width": "42", 
        //       "height": "84", 
        //     }
        //   ]
        // },
        // {
        //   "type": "row",
        //   "children": [
        //     {
        //       "title": "Match Type",
        //       "type": "dropdown",
        //       "options": "Qualifications,Playoffs,Finals", 
        //       "jsonKey": "matchType",
        //       "width": "42"
        //     },
        //     {
        //       "type": "spacer", 
        //       "width": "2", 
        //     }, 
        //     {
        //       "title": "Match Number",
        //       "type": "textbox",
        //       "jsonKey": "matchNumber",
        //       "width": "20"
        //     },
        //     {
        //       "type": "spacer", 
        //       "width": "2", 
        //     }, 
        //     {
        //       "title": "Replay",
        //       "type": "checkbox",
        //       "jsonKey": "replay",
        //       "width": "20"
        //     }
        //   ]
        // },
        {
          "title": "Starting Position",
          "type": "placeholder",
          "jsonKey": "startingPosition",
          "height": "30"
        },
        {"title": "Preload", "type": "checkbox", "jsonKey": "preload"}
      ]
    },
    {
      "title": "Auto",
      "icon": CoralAlgaeIcons.autonomous,
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
      "icon": CoralAlgaeIcons.teleop,
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
            "coralScoredL4",
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
      "icon": CustomIcons.flag,
      "widgets": [
        {
          "title": "End Location",
          "type": "dropdown",
          "options": "None,Park,Deep Climb,Shallow Climb", 
          "jsonKey": "endLocation"
        },
        {
          "title": "[ ] Attempted Climb?",
          "type": "checkbox",
          "jsonKey": "attemptedClimb"
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
              "type": "checkbox",
              "jsonKey": "robotDisabled",
              "width": "32"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Reason for robot disable",
              "type": "textbox",
              "jsonKey": "robotDisableReason",
              "width": "52"
            }
          ]
        },
        {
          "title": "Data Quality",
          "type": "mcq",
          "jsonKey": "dataQuality"
        },
        {"title": "Comments", "type": "placeholder", "jsonKey": "comments"},
        {
          "title": "Team crossed over midline?",
          "type": "checkbox",
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
      "icon": CustomIcons.pitCrew, 
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
      "icon": CustomIcons.wrench,
      "widgets": [
        {
          "title": "Scouter Name",
          "type": "textbox",
          "jsonKey": "scouterName"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Team Number",
              "type": "numberbox",
              "jsonKey": "teamNumber",
              "width": "34"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Driver Station",
              "options": "Red 1,Red 2,Red 3,Blue 1,Blue 2,Blue3",
              "type": "dropdown",
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
              "type": "dropdown",
              "options": "Qualifications,Playoffs,Finals",
              "jsonKey": "matchType",
              "width": "30"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Match Number",
              "type": "numberbox",
              "jsonKey": "matchNumber",
              "width": "20"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Replay",
              "type": "checkbox",
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
      "icon": CoralAlgaeIcons.autonomous,
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
      "icon": CoralAlgaeIcons.teleop,
      "widgets": [
        {
          "title": "big boy teleop widget",
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
      "title": "Endgame",
      "icon": CustomIcons.flag,
      "widgets": [
        {
          "title": "General Match Strategy",
          "type": "dropdown",
          "jsonKey": "generalStrategy",
          "options": "Cycling,Defense,Feed/Pass,Other"
        },
        {
          "title": "Data Quality (5 star rating)",
          "type": "mcq",
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
          "type" : "numberbox", 
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
          "title": "Auto Routine",
          "type": "placeholder",
          "jsonKey": "autoRoutine",
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
          "jsonKey": [
            "canIntakeStation", 
            "canIntakeGround"
          ], 
          "boxNames": [
            [
              "Station", 
              "Ground"
            ]
          ]
        },
        {
          "title": "Algae Removal Ability",
          "type": "multi-three-stage-checkbox",
          "jsonKey": [
            "canRemoveAlgaeL2", 
            "canRemoveAlgaeL3"
          ], 
          "boxNames": [
            [
              "L2", 
              "L3"
            ]
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
            [
              "Processor", 
              "Net"
            ]
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
          "jsonKey": [
            "canClimbShallow", 
            "canClimbDeep"
          ],
          "boxNames": [
            [
              "Shallow", 
              "Deep"
            ]
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
          "options": "Processer,Processer Coral Station,Barge Coral Station", 
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
        {
          "title": "Scouter Name",
          "type": "textbox",
          "jsonKey": "scouterName"
        },
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
          "type": "row",
          "children": [
            {
              "title": "Match Type",
              "type": "dropdown",
              "options": "Qualifications,Playoffs,Finals", 
              "jsonKey": "matchType",
              "width": "30"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Match Number",
              "type": "numberbox",
              "jsonKey": "matchNumber",
              "width": "30"
            },
            {
              "type": "spacer", 
              "width": "2", 
            }, 
            {
              "title": "Replay",
              "type": "checkbox",
              "jsonKey": "replay",
              "width": "22"
            }
          ]
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
          "multiColor": [Constants.pastelRed, Constants.pastelYellow, Constants.pastelBlue],
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
              }(),
              "chartRemovedData": [8, 27, 58]
            }
          ]
        },
        {
          "type": "scrollable-box",
          "height": "40",
          "title": "Comments"
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

Map<String, Color> colorMap = {
  "Atlas": Colors.teal,
  "Chronos": Colors.red,
  "Pit": Constants.ufogreen,
  "Human Player": Constants.magenta,
  "Data Viewer": Colors.blue,

};

Map<String, double> fontMap = {
  "Atlas": 25.0,
  "Chronos": 25.0,
  "Pit": 25.0,
  "Human Player": 25.0,
  "Data Viewer": 25.0,
};

