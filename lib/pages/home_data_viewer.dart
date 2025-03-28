import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/sync.dart';

class DataViewerHome extends StatelessWidget {
  const DataViewerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // gets screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // gets screen height
//calculate scaling factor based on height
    print(screenWidth * 0.85);
    print(screenHeight * 0.15);
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                color: Constants.darkPurple,
                image: DecorationImage(
                    image: AssetImage(backgrounds[configData["theme"]] ?? "assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
            child: Column(
              spacing: 10,
              children: [
          Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              color: Constants.darkPurple
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.bar_chart,size: 30,color: Constants.pastelWhite,),
                Text("Data Viewer Home",style: comfortaaBold(25,color: Constants.pastelWhite),)
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
               Navigator.pushNamed(context, "/data-viewer-tony"); // Navigates to Tony's Data Viewer Page.
            },
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                color: Constants.darkPurple,
                image: DecorationImage(image: AssetImage("assets/images/tdv_bg.jpg")),
                borderRadius: BorderRadius.circular(Constants.borderRadius) 
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("TONY'S DATA VIEWER",style: comfortaaBold(25)),
                    AutoSizeText("A more specialized data viewer page made specifically for drive team, featuring detailed auto information and comments.",style: comfortaaBold(screenWidth * 0.03),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
               Navigator.pushNamed(context, "/data-viewer-amongview"); // Navigates to Tony's Data Viewer Page.
            },
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/amongview_bg.png")),
                borderRadius: BorderRadius.circular(Constants.borderRadius) 
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("AMONGVIEW",style: comfortaaBold(25)),
                    AutoSizeText("A more comprehensive data viewer page geared more towards strat team, with a focus on direct data comparison between teams.",style: comfortaaBold(screenWidth * 0.03),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
          ),
           ServerTestWidget(width: 350,darkMode: true,),
           UploadButton(width: 400,route: "/home-data-viewer",),
           DownloadButton(width: 400,)
        ],),
        ),

        appBar: AppBar(
          backgroundColor:themeColorPalettes[configData["theme"]]![0], // Sets the app bar color.
          title: const Text(
            "LightHouse",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Constants.pastelWhite),
          ),
          centerTitle: true, // Centers the title in the app bar.
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          actions: [
            // Button to display JSON config data in a dialog.
            IconButton(
              icon: Icon(Icons.javascript_outlined),
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: Text(jsonEncode(configData).toString()));
                    });
              }),
            ),
            // Button to navigate to settings page.
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                })
          ],
        ),

        // Drawer menu for navigation between different app modes.
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  child: Text("Switch Mode",
                      style: comfortaaBold(18, color: Constants.pastelBrown))),
              ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Constants.pastelBrown,
                  ),
                  title: Text("Scouter Home",
                      style: comfortaaBold(18, color: Constants.pastelBrown)),
                  onTap: () {
                    Navigator.pushNamed(context, "/home-scouter");
                  }),
              ListTile(
                  leading: Icon(
                    Icons.bar_chart,
                    color: Constants.pastelBrown,
                  ),
                  title: Text("Data Viewer Home",
                      style: comfortaaBold(18, color: Constants.pastelBrown)),
                  onTap: () {
                    Navigator.pop(
                        context); // Closes the drawer, since the user is already on this page.
                  })
            ],
          ),
        ),
      ),
    );
  }
}
