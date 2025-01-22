import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';


class SavedData extends StatelessWidget {
  const SavedData({super.key});
  static final SharedState sharedState = SharedState();
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenWidth / 411;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.pastelRed,
        title: const Text("SavedData", style: TextStyle(
           fontFamily: "Comfortaa",
           fontWeight: FontWeight.w900,
           color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pushNamed(context, "/home-scouter");}, icon: Icon(Icons.home)),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
        child: Column(
          children: [
            EventKeyDropdown(),
            SizedBox(height: 5,),
            LayoutDropdown(),
            SizedBox(height: 5,),
            SavedFileList()

          ],
        ))
    );
  }
}
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
    SavedData.sharedState.activeEvent = configData["eventKey"]!;
    selectedValue = SavedData.sharedState.activeEvent;
    SavedData.sharedState.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 400 * SavedData.scaleFactor,
      height: 100 * SavedData.scaleFactor,
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
            selectedValue = eventKey ?? SavedData.sharedState.activeEvent;
            SavedData.sharedState.setActiveEvent(selectedValue);
          });}),
        ],
      ),
    );
  }
}
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
    layouts = getLayouts(SavedData.sharedState.activeEvent);
    selectedValue = layouts[0];
    SavedData.sharedState.activeLayout = selectedValue;
    SavedData.sharedState.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    
    
    return Container(
      width: 400 * SavedData.scaleFactor,
      height: 100 * SavedData.scaleFactor,
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
            selectedValue = layout ?? layouts[0];
            SavedData.sharedState.setActiveLayout(selectedValue);
          });}),
        ],
      ),
    );
  }
}

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
    if (SavedData.sharedState.activeLayout == "No Data") {return Text("No layouts");}
    
    List<String> fileListStrings = getFilesInLayout(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout);
    if (fileListStrings.isEmpty) {
      
      return Text("No matches for layout ${SavedData.sharedState.activeLayout}");
      }
    List<SavedFile> savedFiles = fileListStrings.map((file) {
        return SavedFile(fileName: file,);}).toList();
    return SizedBox(
      height: 600,
      child: ListView.builder(
        itemCount: savedFiles.length,
        itemBuilder: (context,index) {
          return savedFiles[index];
        }
      ),
    );
  }
}

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
    savedFileJson = loadFile(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout, widget.fileName);
    if (["matchType","matchNumber","driverStation","scouterName","teamNumber"].every((value) => savedFileJson.containsKey(value))) {
      matchInfo = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          children: [
            SizedBox(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                AutoSizeText(savedFileJson["teamNumber"],style: comfortaaBold(40, color:Colors.black),),
                Column(children: [
                  AutoSizeText(savedFileJson["matchType"],style: comfortaaBold(16,color:Colors.black),),
                  AutoSizeText(savedFileJson["matchNumber"],style: comfortaaBold(35,color:Colors.black),)
                ],)
              ],),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(height: 50,
                  width: 100,
                  color: savedFileJson["driverStation"].toString().contains("Red") ? Constants.pastelRed : Constants.pastelBlue,
                  child: Center(child: AutoSizeText(savedFileJson["driverStation"], textAlign: TextAlign.center,style: comfortaaBold(30),)),),
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Icon(Icons.data_object,size:30),
                      SizedBox(
                        width: 70,
                        child: AutoSizeText(savedFileJson["layout"],style: comfortaaBold(25,color: Colors.black),maxLines: 1,))
                    ],),
                  ),
                ],
              ),
              Column(
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Icon(Icons.schedule),
                  SizedBox(
                    width: 185,
                    child: AutoSizeText(savedFileJson["timestamp"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                    // 
                ],),
                Row(children: [
                  Icon(Icons.account_circle),
                  SizedBox(
                    width: 185,
                    child: AutoSizeText(savedFileJson["scouterName"],maxLines: 1,overflow: TextOverflow.ellipsis,minFontSize: 6,style: comfortaaBold(18,color: Colors.black),))
                  
                ],)
              ],)
            ],)
          ],
        ),
      );
    } else {
      matchInfo = Text("doesn't satisfy");
    }
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10
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
          SizedBox(width: 325, height: 195,child: matchInfo,),
          SizedBox(width: 65, height: 195,child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.edit_note,size:50)),
              IconButton(onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(title:Text("Delete Data"),
                  content: Text("Are you sure you want to delete ${widget.fileName}?"),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("No")),
                    TextButton(onPressed: () {
                      if (deleteFile(SavedData.sharedState.activeEvent, SavedData.sharedState.activeLayout, widget.fileName) == 0) {
                        Navigator.pushReplacementNamed(context, "/saved_data");
                      } else {
                        showDialog(context: context, builder: (BuildContext context) {return AlertDialog(content: Text("Error"));});
                      }
                      //
                    }, child: Text("Yes"))
                  ],
                  );
                });
              }, icon: Icon(Icons.delete,size:50))
            ],
          ),),
        ],),
        ),
    );
  }
}


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