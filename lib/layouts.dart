import 'package:flutter/material.dart';
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
          "jsonKey": "scouterName"
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Team Number",
              "type": "numberbox",
              "jsonKey": "teamNumber",
              "width": "200"
            },
            {
              "title": "Driver Station",
              "type": "dropdown",
              "options": "Red 1,Red 2,Red 3,Blue 1,Blue 2,Blue3", 
              "jsonKey": "driverStation",
              "height": "100", 
              "width": "200", 
            }
          ]
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Match Type",
              "type": "dropdown",
              "options": "Qualifiers,Playoffs,ADD MORE THIS IS NOT COMPLETE", 
              "jsonKey": "matchType",
              "width": "225"
            },
            {
              "title": "Match Number",
              "type": "placeholder",
              "jsonKey": "matchNumber",
              "width": "75"
            },
            {
              "title": "Replay",
              "type": "placeholder",
              "jsonKey": "replay",
              "width": "100"
            }
          ]
        },
        {
          "title": "Starting Position",
          "type": "placeholder",
          "jsonKey": "startingPosition",
          "height": "200"
        },
        {
          "title": "Preload", 
          "type": "placeholder", 
          "jsonKey": "preload"
        }
      ]
    },
    {
      "title": "Auto",
      "icon": Icon(CustomIcons.autonomous),
      "widgets": [
        {
          "title": "big boy auto widget",
          "type": "placeholder",
          "jsonKey": "autoQuantitative",
          "height": "750"
        }
      ]
    },
    {
      "title": "Teleop",
      "icon": Icon(CustomIcons.gamepad),
      "widgets": [
        {
          "title": "Coral Pickups",
          "type": "multispinbox",
          "jsonKey": ["coralPickupsStation","coralPickupsGround",],
          "height": "150",
          "boxNames": [
            ["Station", "Ground"]
          ]
        },
        {
          "title": "Coral Scored",
          "type": "multispinbox",
          "jsonKey": ["coralScoredL1","coralScoredL2","coralScoredL3","coralScoredL4"],
          "height": "150",
          "boxNames":[
            ["L1","L2","L3","L4"]
          ]
        },
        {
          "title": "Algae",
          "type": "multispinbox",
          "jsonKey": ["algaeremoveL2","algaeremoveL3","algaescoreProcessor","algaescoreNet","algaemissProcessor","algaemissNet"],
          "height": "400",
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
              "width": "75"
            },
            {
              "title": "Reason for robot disable",
              "type": "placeholder",
              "jsonKey": "robotDisableReason",
              "width": "300"
            }
          ]
        },
        {
          "title": "Data Quality",
          "type": "placeholder",
          "jsonKey": "dataQuality"
        },
        {
          "title": "Comments",
          "type": "placeholder",
          "jsonKey": "comments"
        },
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
      "title": "HorizontalTest", //Test page for horizontal stuff. 
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
              "width": "275"
            },
            {
              "title": "Driver Station",
              "type": "placeholder",
              "jsonKey": "driverStation",
              "width": "100"
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
              "width": "200"
            },
            {
              "title": "Match Number",
              "type": "placeholder",
              "jsonKey": "matchNumber",
              "width": "75"
            },
            {
              "title": "Replay",
              "type": "placeholder",
              "jsonKey": "replay",
              "width": "75"
            }
          ]
        },
        {
          "title": "Starting Position",
          "type": "placeholder",
          "jsonKey": "startingPosition",
          "height": "200"
        },
        {
          "title": "Start match guided",
          "type": "placeholder",
          "jsonKey": ""
        }
      ]
    },
    {
      "title": "Auto",
      "icon": Icon(CustomIcons.autonomous),
      "widgets": [
        {
          "title":"big boy auto widget",
          "type": "placeholder",
          "jsonKey": "idkYet",
          "height": "600"
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
          "title":"big boy teleop widget",
          "type": "placeholder",
          "jsonKey": "idkYet",
          "height": "600"
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
        {
          "title": "Comments",
          "type": "textbox",
          "jsonKey": "comments"
        }
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
        {
          "title": "Team Number",
          "type": "textbox",
          "jsonKey": "teamNumber"
        },
        {
          "title": "Team Name",
          "type": "textbox",
          "jsonKey": "teamName"
        },
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
        {
          "title": "",
          "type": "placeholder",
          "jsonKey": "teamNumber"
        }
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
          "height": "600"
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
          "height": "400"          
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
              "width": "190"
            },
            {
              "title": "Average Algae Cycles",
              "type": "placeholder",
              "jsonKey": "averageAlgaeCycles",
              "width": "190"
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
              "width": "190"
            },
            {
              "title": "Blue Team Number",
              "type": "placeholder",
              "jsonKey": "blueHPTeam",
              "width": "190"
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
              "width": "200"
            },
            {
              "title": "Match Number",
              "type": "placeholder",
              "jsonKey": "matchNumber",
              "width": "75"
            },
            {
              "title": "Replay",
              "type": "placeholder",
              "jsonKey": "replay",
              "width": "75"
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
          "children": [
            {
              "title": "Red Score",
              "type": "spinbox",
              "jsonKey": "redScore",
              "width": "190",
              "height": "190"
            },
            {
              "title": "Blue Score",
              "type": "spinbox",
              "jsonKey": "blueScore",
              "width": "190",
              "height": "190"
            }
          ]
        },
        {
          "type": "row",
          "children": [
            {
              "title": "Red Miss",
              "type": "spinbox",
              "jsonKey": "redMiss",
              "width": "190",
              "height": "190"
            },
            {
              "title": "Blue Miss",
              "type": "spinbox",
              "jsonKey": "blueMiss",
              "width": "190",
              "height": "190"
            }
          ]
        },
        {
          "title": "Algae in Net",
          "type": "multispinbox",
          "jsonKey": ["redNetAlgae", "blueNetAlgae"],
          "height": "250",
          "boxNames": [
            ["Red Algae", "Blue Algae"]
          ]
        }
      ]
    }
  ]
};

Map<String, Map> layoutMap = {
  "AtlaScout": atlascout,
  "ChronoScout" : chronoscout,
  "PitScout" : pitscout,
  "HPScout": hpscout
};


Map<String, IconData> iconMap = {
  "AtlaScout": Icons.map,
  "ChronoScout": Icons.timer,
  "PitScout": Icons.analytics_rounded,
  "HPScout": Icons.child_care
};