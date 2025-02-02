import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/layouts.dart';
import 'package:lighthouse/splash_texts.dart';

class ScouterHomePage extends StatelessWidget {
  const ScouterHomePage({super.key});
  static late double scaleFactor;
  List<Launcher> getLaunchers() {
    final enabledLayouts = layoutMap.keys;
    final enabledLaunchers = enabledLayouts.map((layout) {
      return Launcher(
        icon: iconMap[layout] ?? Icons.data_object,
        title: layout,
        color: colorMap[layout] ?? Colors.black,
      );
    }).toList();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    loadConfig();
    return Scaffold(
      backgroundColor: Constants.pastelRed,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Switch Mode")),
            ListTile(
                leading: Icon(Icons.home),
                title: Text("Scouter Home"),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text("Data Viewer Home"),
                onTap: () {
                  Navigator.pushNamed(context, "/home-data-viewer");
                })
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.pastelWhite),
        backgroundColor: Constants.pastelRed,
        // title: const Text(
        //   "LightHouse",
        //   style: TextStyle(
        //       fontFamily: "Comfortaa",
        //       fontWeight: FontWeight.w900,
        //       color: Colors.white),
        // ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.javascript_outlined,color: Constants.pastelWhite,),
            onPressed: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: Text(jsonEncode(configData).toString()));
                  });
            }),
          ),
          IconButton(
              icon: Icon(Icons.settings,color: Constants.pastelWhite,),
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              })
        ],
      ),
      body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)),
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
            ],
          )),
    );
  }
}

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
      onTap: () {
        Navigator.pushNamed(context, route, arguments: title);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        //space between each choice
        child: Container(
          height: 75 * ScouterHomePage.scaleFactor,
          width: 400 * ScouterHomePage.scaleFactor,

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
