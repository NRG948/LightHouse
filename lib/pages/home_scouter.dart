
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/layouts.dart';
import 'package:lighthouse/splash_texts.dart';

//stateless widget representing the home screen of the app
class ScouterHomePage extends StatefulWidget {
  const ScouterHomePage({super.key});

  @override
  State<ScouterHomePage> createState() => _ScouterHomePageState();
}

class _ScouterHomePageState extends State<ScouterHomePage> {
  late Future<Map<String,String>> asyncConfigData;
  static late double scaleFactor;
  @override
  void initState() {
    super.initState();
    asyncConfigData = loadConfig();
  }
  // This method generates a list of Launcher widgets based on layouts.
  List<Launcher> getLaunchers() {
    final enabledLayouts = layoutMap.keys;
    final enabledLaunchers = enabledLayouts.map((layout) {
      return Launcher(
        icon: iconMap[layout] ?? Icons.data_object,
        title: layout,
        color: colorMap[layout] ?? Colors.black,
      );
    }).toList();
    // Adding extra launchers for viewing saved data and syncing to the server.
    enabledLaunchers.add(Launcher(
      icon: Icons.folder,
      title: "View Saved Data",
      route: "/saved_data",
      color: colorMap["View Saved Data"] ?? Colors.black,
    ));
    enabledLaunchers.add(Launcher(
    icon: Icons.sync_outlined, 
    route: "/sync",
    title: "Sync to Server", 
    color: colorMap["Sync to Server"] ?? Colors.black));
    return enabledLaunchers;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and set scale factor
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.pastelRed,
        // Drawer menu with navigation options
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(child: Text("Switch Mode",style: comfortaaBold(18,color: Constants.pastelBrown))),
              ListTile(
                  leading: Icon(Icons.home,color: Constants.pastelBrown,),
                  title: Text("Scouter Home",style: comfortaaBold(18,color: Constants.pastelBrown)),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: Icon(Icons.bar_chart,color: Constants.pastelBrown,),
                  title: Text("Data Viewer Home",style: comfortaaBold(18,color: Constants.pastelBrown)),
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, "/home-data-viewer");
                  })
            ],
          ),
        ),
        // App bar with icons for settings and displaying config data
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor: Constants.pastelRed,
          centerTitle: true,
          actions: [
            // Buttons used for testing functionality
            // Leave them here but shouldn't be enabled in prod
            // IconButton(onPressed: () => Navigator.pushNamed(context, "/amongview-individual",arguments: 948), icon: Icon(Icons.extension)),
            // IconButton(
            //   icon: Icon(Icons.javascript_outlined,color: Constants.pastelWhite,),
            //   onPressed: (() {
            //     showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //               content: Text(jsonEncode(configData).toString()));
            //         });
            //   }),
            // ),
            IconButton(
                icon: Icon(Icons.settings,color: Constants.pastelWhite,),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pushNamed(context, "/settings");
                })
          ],
        ),
        // Main body of the page with a background image
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
            // Column containing title, splash text, and launcher buttons
            child: Column(
              children: [
                SizedBox(
                  width: 0.75 * screenWidth,
                  child: AutoSizeText("LightHouse",style: comfortaaBold(60,spacing: -6),maxLines: 1,textAlign: TextAlign.center,),
                ),
               SizedBox(
                height: 0.05 * screenHeight,
                width: 0.8 * screenWidth,
                child: AutoSizeText(randomSplashText(),style: comfortaaBold(18,spacing: -1),maxLines: 2,textAlign: TextAlign.center,)),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getLaunchers()),
                SizedBox(
                  height: 0.05 * screenHeight,
                  width: 0.8 * screenWidth,
                  child: FutureBuilder(
                    future: asyncConfigData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                      return  AutoSizeText("${Constants.versionName} | ${snapshot.data!["scouterName"]} | ${snapshot.data!["eventKey"]}",style: comfortaaBold(18),textAlign: TextAlign.center,);}
                      else {
                        return AutoSizeText("Loading...",style: comfortaaBold(18),textAlign: TextAlign.center,);
                      }}),
                )
              ],
            )),
      ),
    );
  }
}

// Launcher widget represents a button that navigates to different app sections.
class Launcher extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final Color color;
  const Launcher(
      {super.key,
      required this.icon,
      required this.title,
      this.route = "/entry",
      required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigates to the specified route when tapped
      onTap: () {
        Navigator.pushNamed(context, route, arguments: title);
        HapticFeedback.mediumImpact();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        //space between each choice
        child: Container(
          height: 75 * _ScouterHomePageState.scaleFactor,
          width: 400 * _ScouterHomePageState.scaleFactor,

          //the size of the box that holds each choice
          decoration: BoxDecoration(color: Constants.pastelWhite,borderRadius: BorderRadius.circular(Constants.borderRadius)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 10, top: 10),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 10,
                        bottom: 10
                      ), // Padding inside the container
                    decoration: BoxDecoration(
                      color:color, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),

                    child: Center(
                      child: AutoSizeText(
                        title.toUpperCase(),
                        style: comfortaaBold(25,color: Colors.white)
                      ),
                    ),  
                  ),
                ),
              ),

              // Icon positioned on the right side
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Icon(
                  icon,
                  color: color,
                  size: 50,
                ),
              ), // Positioned to the right
            ],
          ),
        ),
      ),
    );
  }
}