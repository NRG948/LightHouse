import "dart:convert";

import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/layouts.dart";
import "package:lighthouse/pages/data_entry.dart";
import "package:lighthouse/pages/entry_widgets.dart";

class DataEntryPaged extends StatelessWidget {
  const DataEntryPaged({super.key});
  static final Map<String, String> exportData = {};
   @override
   Widget build(BuildContext context) {
   final String activeConfig = (ModalRoute.of(context)?.settings.arguments as String?)!;
   final layoutJSON = layoutMap.containsKey(activeConfig) ? layoutMap[activeConfig]! : Map();
   if (layoutJson.)
  //   final String activeConfig = (ModalRoute.of(context)?.settings.arguments as String?)!;
  //   final layoutJSON = layoutMap.containsKey(activeConfig) ? layoutMap[activeConfig]! : Map();
  //   if (layoutJSON.containsKey("widgets")) {Navigator.pushNamed(context, "/entry", arguments: activeConfig);}
  //   final widgetList = (layoutJSON["widgets"] as List).map((widgetData) {
  //     final title = widgetData["title"];
  //     final type = widgetData["type"];
  //     final jsonKey = widgetData["jsonKey"];

  //     if (type == "spinbox") {return NRGSpinbox(title: title,jsonKey: jsonKey,);}
  //     if (type == "textbox") {return NRGTextBox(title: title, jsonKey: jsonKey,);}
  //     if (type == "textboxLarge") {return NRGTextBox(title: title, jsonKey: jsonKey, height: "200");}
  //     if (type == "checkbox") {return NRGCheckbox(title: title, jsonKey: jsonKey);}
  //     if (type == "numberbox") {return NRGTextBox(title: title, jsonKey: jsonKey, numeric: true);}
  //     if (type == "dropdown") {
  //       if (!(widgetData.containsKey("options"))) { return Text("Widget $title doesn't have dropdown options specified.");}
  //       final options = widgetData["options"].split(",");
  //       return NRGDropdown(title: title, jsonKey: jsonKey,options: options,);}
  //     return Text("type $type isn't a valid type you idiot");
  //   }).toList();
  //   widgetList.add(SaveJsonButton());

    // exportData.clear();
    // for (var widgetData in layoutJSON["widgets"]) {
    //   final key = widgetData["jsonKey"];
    //   exportData[key] = "0";
    // }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().pastelRed,
        title: const Text("Data Entry", style: TextStyle(
           fontFamily: "Comfortaa",
           fontWeight: FontWeight.w900,
           color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pushNamed(context, "/home");}, icon: Icon(Icons.home)),
      ),
      body: PageView(
        children: 
        
         Center(
          child: Padding(
            padding: const EdgeInsets.only(top:10.0, left: 10.0, right:10.0),
            child: ListView.builder(
              itemCount: widgetList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: widgetList[index],
                );
              },
            ),
          ),
        ),
      )
      
    );
  }
}

class SaveJsonButton extends StatelessWidget {
  const SaveJsonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () async {
      if (await saveExport() == 0) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(content: Text("Successfully saved."),actions: [
            TextButton(onPressed: () {Navigator.pushNamed(context, "/home");}, child: Text("OK"))
          ],);
        });
      }
    }, child: Text("Save"));
  }
}

