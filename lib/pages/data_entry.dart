import "dart:convert";

import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/layouts.dart";
import "package:lighthouse/pages/entry_widgets.dart";
import "package:lighthouse/widgets/placeholder.dart";

class DataEntry extends StatelessWidget {

  List<Widget> createWidgetList(List<dynamic> widgets) {
    final widgetList = widgets.map((widgetData) {
      final type = widgetData["type"]!;
      if(type == "row") {return Row(
        spacing: 10.0,
        children:createWidgetList(widgetData["children"]!));}
      final title = widgetData["title"]!;
      final jsonKey = widgetData["jsonKey"]!;
      exportData[jsonKey] = "0"; // creates entry in global data object
      final height = widgetData["height"];
      final width = widgetData["width"];
      switch(type) {
        case "spinbox":
          return NRGSpinbox(title: title,jsonKey: jsonKey,);
        case "textbox":
          return NRGTextBox(title: title,jsonKey: jsonKey,);
        case "checkbox":
          return NRGCheckbox(title: title, jsonKey: jsonKey,);
        case "numberbox":
          return NRGTextBox(title: title, jsonKey: jsonKey, numeric: true,);
        case "dropdown":
          if (!(widgetData.containsKey("options"))) { return Text("Widget $title doesn't have dropdown options specified.");}
          final options = widgetData["options"]!.split(",");
          return NRGDropdown(title: title, jsonKey: jsonKey,options: options,);
        case "placeholder":
          return NRGPlaceholder(title: title, jsonKey: jsonKey, height: height ?? "100", width: width ?? "400");
        }
        return Text("type $type isn't a valid type");
    }).toList();
    return widgetList;
    
  }
  
  List<Widget> createWidgetPages(List<Map<String,dynamic>> pages) {
    exportData.clear();
    return pages.map((page) {
      final pageTitle = page["title"];
      final widgetList = createWidgetList(page["widgets"]);
      return Center(
          child: Padding(
            padding: const EdgeInsets.only(top:10.0, left: 10.0, right:10.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widgetList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: widgetList[index],
                );
              },
            ),
          ),
        );
    }).toList();
  }

  const DataEntry({super.key});
  static final Map<String, String> exportData = {};
   @override
   Widget build(BuildContext context) {
   final String activeConfig = (ModalRoute.of(context)?.settings.arguments as String?)!;
   final layoutJSON = layoutMap.containsKey(activeConfig) ? layoutMap[activeConfig]! : Map();
   final controller = PageController(
    initialPage: 0,

   );
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
        actions: [SaveJsonButton()],
      ),
      body: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: createWidgetPages(layoutJSON["pages"])
        
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

