import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';

// Main widget for displaying saved data
class SavedData extends StatelessWidget {
  const SavedData({super.key});
  static final SharedState sharedState = SharedState();
  static String? activeLayout;
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    activeLayout = ModalRoute.of(context)?.settings.arguments as String?; // get layouts
    if (!["Atlas","Chronos","Pit","Human Player"].any((e) => activeLayout == e)) {activeLayout = null;} // check if layout is valid
    scaleFactor = screenWidth / 411;
    if (!configData.containsKey("eventKey") || !ensureSavedDataExists(configData["eventKey"]!)) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new)),),
        body: Column(
          children: [
            Text("NO DATA",style: comfortaaBold(18,color: Constants.pastelBrown)),
            Text(configData.toString(),style: comfortaaBold(18,color: Constants.pastelBrown)),
            TextButton(onPressed: () {build(context);}, child: Text("Reload Page"))
          ],
        ),);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.pastelWhite),
        backgroundColor: Constants.pastelRed,
        title: const Text("Saved Data", style: TextStyle(
           fontFamily: "Comfortaa",
           fontWeight: FontWeight.w900,
           color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pushNamed(context, "/home-scouter");}, icon: Icon(Icons.home,color: Constants.pastelWhite,)),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)), // set background image
        child: Column(
          children: [
            EventKeyDropdown(), //dropdown for event selection
            SizedBox(height: 5,), 
            LayoutDropdown(), // dropdown for layout selection 
            SizedBox(height: 5,),
            SavedFileList() // Display saved files for the selected event and layout

          ],
        ))
    );
  } 
}

// Dropdown for selecting event key
class EventKeyDropdown extends StatefulWidget {
  const EventKeyDropdown({super.key,});
  @override
  State<EventKeyDropdown> createState() => _EventKeyDropdownState();
}

class _EventKeyDropdownState extends State<EventKeyDropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    SavedData.sharedState.activeEvent = configData["eventKey"]!; // Set active event from config
    selectedValue = SavedData.sharedState.activeEvent; // Initialize selected value for dropdown
    SavedData.sharedState.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400 * SavedData.scaleFactor,
      height: 0.12 * SavedData.screenHeight,
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius)
      ),
      child: Column(
        children: [
          Text("Showing data for event:",style: comfortaaBold(18,color: Colors.black),),
          DropdownButton<String>(value: selectedValue,
            items: getSavedEvents().map((item) {
            return DropdownMenuItem<String>(value: item,child: Text(item),);
          }).toList(), onChanged:(eventKey){setState(() {
            selectedValue = eventKey ?? SavedData.sharedState.activeEvent; // update selected event
            SavedData.sharedState.setActiveEvent(selectedValue); // set active event
          });}),
        ],
      ),
    );
  }
}

// Dropdown for selecting layout
class LayoutDropdown extends StatefulWidget {
  const LayoutDropdown({super.key,});
  @override
  State<LayoutDropdown> createState() => _LayoutDropdownState();
}

class _LayoutDropdownState extends State<LayoutDropdown> {
  late List<String> layouts;
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    layouts = getLayouts(SavedData.sharedState.activeEvent); //get layouts for the active event
    selectedValue = SavedData.activeLayout ?? layouts[0]; // initialize selected layout
    SavedData.sharedState.activeLayout = selectedValue; // set active layout
    SavedData.sharedState.addListener(() {setState(() {
    });}); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400 * SavedData.scaleFactor,
      height: 0.12 * SavedData.screenHeight,
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius)
      ),
      child: Column(
        children: [
          Text("Showing layout:",style: comfortaaBold(18,color: Colors.black),),
          DropdownButton<String>(value: selectedValue,
            items: layouts.map((item) {
            return DropdownMenuItem<String>(value: item,child: Text(item),);
          }).toList(), onChanged:(layout){setState(() {
            selectedValue = layout ?? layouts[0]; // Update selected layout
            SavedData.sharedState.setActiveLayout(selectedValue); // Set active layout
          });}),
        ],
      ),
    );
  }
}

// List of saved files for the selected event and layout
class SavedFileList extends StatefulWidget {
  const SavedFileList({super.key});

  @override
  State<SavedFileList> createState() => _SavedFileListState();
}

class _SavedFileListState extends State<SavedFileList> {
  @override
  void initState() {
    super.initState();
    SavedData.sharedState.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    if (SavedData.sharedState.activeLayout == "No Data") {return Text("No layouts",style: comfortaaBold(10));} // check if there's no layout
    
    List<String> fileListStrings = getFilesInLayout(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout);
    if (fileListStrings.isEmpty) {
      
      return Text("No matches for layout ${SavedData.sharedState.activeLayout}",style: comfortaaBold(10)); //display message if no files found
      }
    List<SavedFile> savedFiles = fileListStrings.map((file) {
        return SavedFile(fileName: file,);}).toList();
    return SizedBox(
      height: 0.6 * SavedData.screenHeight,
      width: 400 * SavedData.scaleFactor,
      child: ListView.builder(
        itemCount: savedFiles.length,
        itemBuilder: (context,index) {
          return savedFiles[index];
        }
      ),
    );
  }
}

// Widget for displaying individual saved file
class SavedFile extends StatefulWidget {
  final String fileName;
  const SavedFile({super.key, required this.fileName});

  @override
  State<SavedFile> createState() => _SavedFileState();
}

class _SavedFileState extends State<SavedFile> {
  late Widget matchInfo;
  late Map<String,dynamic> savedFileJson;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("${SavedData.sharedState.activeEvent}, ${SavedData.sharedState.activeLayout}, ${widget.fileName}");
    savedFileJson = loadFileIntoSavedData(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout, widget.fileName);
    if (["matchType","matchNumber","driverStation","scouterName","teamNumber"].every((value) => savedFileJson.containsKey(value))) {
      matchInfo = Padding(
        padding: EdgeInsets.all(8.0 * SavedData.scaleFactor),
        child: Column(
          children: [
            SizedBox(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                AutoSizeText(savedFileJson["teamNumber"].toString(),style: comfortaaBold(40 * SavedData.scaleFactor, color:Colors.black),),
                Column(children: [
                  AutoSizeText(savedFileJson["matchType"],style: comfortaaBold(16 * SavedData.scaleFactor,color:Colors.black),),
                  AutoSizeText(savedFileJson["matchNumber"].toString(),style: comfortaaBold(35 * SavedData.scaleFactor,color:Colors.black),)
                ],)
              ],),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(height: 50 * SavedData.scaleFactor,
                  width: 100 * SavedData.scaleFactor,
                  color: savedFileJson["driverStation"].toString().contains("Red") ? Constants.pastelRed : Constants.pastelBlue,
                  child: Center(child: AutoSizeText(savedFileJson["driverStation"], textAlign: TextAlign.center,style: comfortaaBold(30 * SavedData.scaleFactor),)),),
                  SizedBox(
                    height: 50 * SavedData.scaleFactor,
                    width: 100 * SavedData.scaleFactor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Icon(Icons.data_object,size:30 * SavedData.scaleFactor),
                      SizedBox(
                        width: 70 * SavedData.scaleFactor,
                        child: AutoSizeText(savedFileJson["layout"],style: comfortaaBold(25 * SavedData.scaleFactor,color: Colors.black),maxLines: 1,)),
                    ],),
                  ),
                ], 
              ),
              Column(
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Icon(Icons.schedule,size: 2 * SavedData.scaleFactor),
                  SizedBox(
                    width: 185 * SavedData.scaleFactor,
                    child: AutoSizeText(savedFileJson["timestamp"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                ],),
                Row(children: [
                  Icon(Icons.account_circle,size: 23 * SavedData.scaleFactor,),
                  SizedBox(
                    width: 185 * SavedData.scaleFactor,
                    child: AutoSizeText(savedFileJson["scouterName"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                ],)
              ],)
            ],)
          ],
        ),
      );
    } else if (["teamNumber","teamName","interviewerName","interviewerName"].every((value) => savedFileJson.containsKey(value))) {
       matchInfo = Padding(
        padding: EdgeInsets.all(8.0 * SavedData.scaleFactor),
        child: Column(
          children: [
            SizedBox(
              width: 400 * SavedData.scaleFactor,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                AutoSizeText(savedFileJson["teamNumber"].toString(),style: comfortaaBold(40 * SavedData.scaleFactor, color:Colors.black),),
                SizedBox(width: 200*SavedData.scaleFactor, child: AutoSizeText(savedFileJson["teamName"].toString(),style: comfortaaBold(20 * SavedData.scaleFactor,color: Colors.black),maxLines: 2,))
              ],),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  
                  SizedBox(
                    height: 50 * SavedData.scaleFactor,
                    width: 100 * SavedData.scaleFactor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Icon(Icons.data_object,size:30 * SavedData.scaleFactor),
                      SizedBox(
                        width: 70 * SavedData.scaleFactor,
                        child: AutoSizeText(savedFileJson["layout"],style: comfortaaBold(25 * SavedData.scaleFactor,color: Colors.black),maxLines: 1,)),
                    ],),
                  ),
                ], 
              ),
              Column(
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Icon(Icons.schedule,size: 2 * SavedData.scaleFactor),
                  SizedBox(
                    width: 185 * SavedData.scaleFactor,
                    child: AutoSizeText(savedFileJson["timestamp"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                ],),
                Column(
                  children: [
                    Row(children: [
                      Icon(Icons.account_circle,size: 23 * SavedData.scaleFactor,),
                      SizedBox(
                        width: 185 * SavedData.scaleFactor,
                        child: AutoSizeText(savedFileJson["interviewerName"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                    ],),
                    Row(children: [
                      Icon(Icons.no_accounts,size: 23 * SavedData.scaleFactor,),
                      SizedBox(
                        width: 185 * SavedData.scaleFactor,
                        child: AutoSizeText(savedFileJson["intervieweeName"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                    ],),
                  ],
                )
              ],)
            ],)
          ],
        ),
      );
    }
    else if (["matchType","matchNumber","scouterName","redHPTeam","blueHPTeam"].every((value) => savedFileJson.containsKey(value))) {
      matchInfo = Padding(
        padding: EdgeInsets.all(8.0 * SavedData.scaleFactor),
        child: Column(
          children: [
            SizedBox(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
                  children: [
                    AutoSizeText(savedFileJson["redHPTeam"].toString(),style: comfortaaBold(40 * SavedData.scaleFactor, color:Constants.pastelRed),),
                    AutoSizeText(savedFileJson["blueHPTeam"].toString(),style: comfortaaBold(40 * SavedData.scaleFactor, color:Constants.pastelBlue),),
                  ],
                ),
                Column(children: [
                  AutoSizeText(savedFileJson["matchType"],style: comfortaaBold(16 * SavedData.scaleFactor,color:Colors.black),),
                  AutoSizeText(savedFileJson["matchNumber"].toString(),style: comfortaaBold(35 * SavedData.scaleFactor,color:Colors.black),)
                ],)
              ],),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
            
                  SizedBox(
                    height: 50 * SavedData.scaleFactor,
                    width: 100 * SavedData.scaleFactor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Icon(Icons.data_object,size:30 * SavedData.scaleFactor),
                      SizedBox(
                        width: 70 * SavedData.scaleFactor,
                        child: AutoSizeText(savedFileJson["layout"],style: comfortaaBold(25 * SavedData.scaleFactor,color: Colors.black),maxLines: 1,)),
                    ],),
                  ),
                ], 
              ),
              Column(
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Icon(Icons.schedule,size: 2 * SavedData.scaleFactor),
                  SizedBox(
                    width: 185 * SavedData.scaleFactor,
                    child: AutoSizeText(savedFileJson["timestamp"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                ],),
                Row(children: [
                  Icon(Icons.account_circle,size: 23 * SavedData.scaleFactor,),
                  SizedBox(
                    width: 185 * SavedData.scaleFactor,
                    child: AutoSizeText(savedFileJson["scouterName"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                ],)
              ],)
            ],)
          ],
        ),
      );
    }
    else {
      matchInfo = Padding(
        padding: EdgeInsets.all(8.0 * SavedData.scaleFactor),
        child: Column(
          children: [
            
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 50 * SavedData.scaleFactor,
                    width: 100 * SavedData.scaleFactor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Icon(Icons.data_object,size:30 * SavedData.scaleFactor),
                      SizedBox(
                        width: 70 * SavedData.scaleFactor,
                        child: AutoSizeText(savedFileJson["layout"],style: comfortaaBold(25 * SavedData.scaleFactor,color: Colors.black),maxLines: 1,)),
                    ],),
                  ),
                ], 
              ),
              Column(
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Icon(Icons.schedule,size: 2 * SavedData.scaleFactor),
                  SizedBox(
                    width: 185 * SavedData.scaleFactor,
                    child: AutoSizeText(savedFileJson["timestamp"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                ],),
              ],)
            ],)
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10 * SavedData.scaleFactor
      ),
      child: Container(
        width: 400 * SavedData.scaleFactor,
        height: 200 * SavedData.scaleFactor,
        decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(width: 325 * SavedData.scaleFactor, height: 195 * SavedData.scaleFactor,child: matchInfo,),
          SizedBox(width: 65 * SavedData.scaleFactor, height: 195 * SavedData.scaleFactor,child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {showDialog(context: context, builder: (context) {return DataEdit(fileName: widget.fileName,);});}, icon: Icon(Icons.edit_note,size:50 * SavedData.scaleFactor)),
              IconButton(onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(title:Text("Delete Data",style: comfortaaBold(25,color: Constants.pastelBrown),),
                  content: Text("Are you sure you want to delete ${widget.fileName}?",style: comfortaaBold(12,color: Constants.pastelBrown)),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("No",style: comfortaaBold(18,color: Constants.pastelBrown))),
                    TextButton(onPressed: () {
                      if (deleteFile(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout, widget.fileName) == 0) {
                        Navigator.pushReplacementNamed(context, "/saved_data",arguments: SavedData.sharedState.activeLayout);
                      } else {
                        showDialog(context: context, builder: (BuildContext context) {return AlertDialog(content: Text("Error"));});
                      }
                      //
                    }, child: Text("Yes",style: comfortaaBold(18,color: Constants.pastelBrown)))
                  ],
                  );
                });
              }, icon: Icon(Icons.delete,size:50 * SavedData.scaleFactor))
            ],
          ),),
        ],),
        ),
    );
  }
}

// Dialog for editing data
class DataEdit extends StatefulWidget {
  final String fileName;
  const DataEdit({super.key, required this.fileName});

  @override
  State<DataEdit> createState() => _DataEditState();
}

class _DataEditState extends State<DataEdit> {
  late Map<String, dynamic> jsonFile;
  late Map<String, dynamic> typeReferenceFile;
  late String activeKey;
  String statusText = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    jsonFile = loadFileIntoSavedData(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout, widget.fileName);
    typeReferenceFile = jsonFile;
    activeKey = jsonFile.keys.toList()[0];
    controller.text = jsonFile[activeKey];
    if (typeReferenceFile[activeKey].runtimeType == List<dynamic>) {
      controller.text = jsonEncode(jsonFile[activeKey]);
    }

    controller.addListener(() {setState(() {
      late Type decodedInput;
      late dynamic decodedReference;
      try {decodedInput = jsonDecode(controller.text).runtimeType;} catch (_) {decodedInput = String;}
      try {decodedReference = typeReferenceFile[activeKey].runtimeType;} catch (_) {decodedReference = String;}
      try {
      if (decodedInput == decodedReference) {
        jsonFile[activeKey] = jsonDecode(controller.text);
        statusText = "";
      } else {
        statusText = "TYPE MISMATCH: $decodedInput to $decodedReference";
      }
      } catch (_) {
        if (decodedReference == String) {
        jsonFile[activeKey] = controller.text;
        statusText = "";
        } else {
          statusText = "INVALID TYPE";
        }
      }
    });});
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Constants.pastelWhite,
      child: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
          height: 525 * SavedData.scaleFactor,
          width: 350 * SavedData.scaleFactor,
          decoration: BoxDecoration(color: Constants.pastelWhite,borderRadius: BorderRadius.circular(Constants.borderRadius)),
          child: SizedBox(
            width: 300 * SavedData.scaleFactor,
            child: Column(
              children: [
                AutoSizeText("Edit Data",style: comfortaaBold(30 * SavedData.scaleFactor,color: Constants.pastelBrown),),
                AutoSizeText(statusText,style: comfortaaBold(15,color: Colors.red),maxLines: 1,),
                DropdownButton(items: 
                jsonFile.keys.map(
                  (file) {
                    return DropdownMenuItem(value:file,child: Text(file));}
                ).toList(),
                value: activeKey,
                onChanged: (value) {setState(() {
                  activeKey = value ?? "";
                  controller.text = jsonFile[activeKey].toString();
                  if (typeReferenceFile[activeKey].runtimeType == List<dynamic>) {
                      controller.text = jsonEncode(jsonFile[activeKey]);
                    }
                });
                }),
                SizedBox(
                  height: 218 * SavedData.scaleFactor,
                  width: 300 * SavedData.scaleFactor,
                  child: TextField(
                    smartDashesType: SmartDashesType.disabled,
                    smartQuotesType: SmartQuotesType.disabled,
                    controller: controller,
                    maxLines: 10,
                  ),
                ),
                SizedBox(
                height: 100 * SavedData.scaleFactor,
                child: TextButton(onPressed: () {
                  if (statusText == "") {
                  saveFileFromSavedData(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout, widget.fileName, jsonFile);
                   Navigator.pushReplacementNamed(context,"/home-scouter");}
                  
                 
                }, child: Text("Save",style: comfortaaBold(10))))
              ],
            ),
          )
                ),
        ),),
    );
  }
  List<String> tryParseStringList(String inputString) {

    return [];
  }
}

// Shared state class for managing active event and layout
class SharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;

  void setActiveEvent(String event) {
    activeEvent = event;
    notifyListeners();
  }

  void setActiveLayout(String layout) {
    activeLayout = layout;
    notifyListeners();
  }

  
}