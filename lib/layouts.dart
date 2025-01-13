import 'package:flutter/material.dart';
import 'package:lighthouse/custom_icons.dart';


Map<String, dynamic> atlaScout = {
  "title": "Atlascout",
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
        {"title": "Preload", "type": "placeholder", "jsonKey": "preload"}
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
          "jsonKey": ["removeL2","removeL3","scoreProcessor","scoreNet","missProcessor","missNet"],
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
      "title": "HorizontalTest", 
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
      "icon": Icon(CustomIcons.wrench),
      "widgets": [
        {
          "title": "Team Number",
          "type": "placeholder",
          "jsonKey": "teamNumber"
        },
        {
          "title"
        }
      ]
    }
  ]
};

Map<String, Map> layoutMap = {
  "AtlaScout": atlaScout,
  "ChronoScout" : chronoscout
};


Map<String, IconData> iconMap = {
  "AtlaScout": Icons.map,
  "ChronoScout": Icons.timer
};