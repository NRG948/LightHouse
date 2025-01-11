import 'package:flutter/material.dart';


Map<String, dynamic> alphaScout = {
  "title": "Alpha Scout",
  "pages": [
    {
      "title": "Initial Info",
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
      "widgets": [
        {
          "title": "big boy auto widget",
          "type": "placeholder",
          "jsonKey": "TODOauto",
          "height": "750"
        }
      ]
    },
    {
      "title": "Teleop",
      "widgets": [
        {
          "title": "Coral Pickups Station & Ground double spinbox",
          "type": "placeholder",
          "jsonKey": "coralPickupsStation,coralPickupsGround",
          "height": "150"
        },
        {
          "title": "Coral Scored 4 spinboxes",
          "type": "placeholder",
          "jsonKey": "coralScoredL1,coralScoredL2,coralScoredL3,coralScoredL4",
          "height": "150"
        },
        {
          "title": "Algae widget 6 spinboxes",
          "type": "placeholder",
          "jsonKey": "removeL2,removeL3,scoreProcessor,scoreNet,missProcessor,missNet"
        }
      ]
    },
    {
      "title": "Endgame",
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

Map<String, Map> layoutMap = {
  "alphaScout": alphaScout
};

// TODO: Add icon bindings
