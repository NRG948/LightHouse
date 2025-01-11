import 'package:flutter/material.dart';


Map<String,dynamic> nrgPageTest = {"pages" : [
{"title": "Setup",
"widgets": [
{
    "title": "Team Number",
    "type": "numberbox",
    "jsonKey": "teamNumber"
  },
  {
    "title": "Match Type",
    "type": "dropdown",
    "jsonKey": "matchType",
    "options" : "Qualifications,Playoffs,Finals"
  },
  {
    "title": "Match Number",
    "type": "numberbox",
    "jsonKey": "matchNumber"
  },
  {
    "title": "Driver Station",
    "type": "dropdown",
    "jsonKey": "driverStation",
    "options": "Red 1,Red 2,Red 3,Blue 1,Blue 2,Blue 3"
  },
  {
    "title": "Replay",
    "type": "checkbox",
    "jsonKey": "replay"
  },
  {
    "title": "Scouter Name",
    "type": "textbox",
    "jsonKey": "scouterName"
  },
]},
{"title": "Page2",
"widgets": [
  {
    "title": "Second Page",
    "type": "textbox",
    "jsonKey": "test"
  }
]},
]};



Map<String, Map> layoutMap = {
  "nrgPageTest": nrgPageTest
};

// TODO: Add icon bindings

