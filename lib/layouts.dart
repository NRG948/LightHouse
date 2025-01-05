Map<String, dynamic> testJson = {"widgets": [
    {
        "title": "JSON Test 1 Spinbox",
        "type": "spinbox",
        "jsonKey" : "test1"
    },
    {
        "title":"JSON Test 2 Text Box",
        "type": "textbox",
        "jsonKey": "test2"
    }
    
]};

Map<String, dynamic> coolerTestJson = {"widgets": [
    {
        "title": "Super awesome checkbox",
        "type": "checkbox",
        "jsonKey" : "test1"
    },
    {
        "title":"JSON Test 2 Text Box",
        "type": "textbox",
        "jsonKey": "test2"
    },

    {
        "title": "Super awesome spinbox 2",
        "type": "spinbox",
        "jsonKey" : "test3"
    },
    {
        "title": "Super ame spinbo",
        "type": "spinbox",
        "jsonKey" : "test4"
    },
     {
        "title": "Super awesome spinbox 2",
        "type": "spinbox",
        "jsonKey" : "test5"
    },
     {
        "title": "Super awesome spinbox 2",
        "type": "spinbox",
        "jsonKey" : "test6"
    },
     {
        "title": "Super awesome spinbox 2",
        "type": "spinbox",
        "jsonKey" : "test7"
    },
     {
        "title": "Super awesome spinbox 2",
        "type": "spinbox",
        "jsonKey" : "test8"
    },
     {
        "title": "Super awesome spinbox 2",
        "type": "spinbox",
        "jsonKey" : "test9"
    }
]};

Map<String,dynamic> barebonesNRG = {"widgets": [
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
  {
    "title": "Comments",
    "type": "textboxLarge",
    "jsonKey": "comments"
  }
]};


Map<String, Map> layoutMap = {
  "testJson" : testJson,
  "coolerTestJson" : coolerTestJson,
  "barebonesNRG" : barebonesNRG,
};

// TODO: Add icon bindings

