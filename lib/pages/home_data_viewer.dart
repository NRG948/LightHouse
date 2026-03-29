import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/device_id.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/sync.dart';
import 'package:lighthouse/themes.dart';

class DataViewerHome extends StatelessWidget {
  const DataViewerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // gets screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // gets screen height
//calculate scaling factor based on height
    debugPrint((screenWidth * 0.85).toString());
    debugPrint((screenHeight * 0.15).toString());
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: context.backgroundDecoration,
          child: Column(
            spacing: 10,
            children: [
              Container(
                width: screenWidth * 0.85,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                    color: Constants.darkPurple),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text(
                      "Data Viewer Home",
                      style: comfortaaBold(25, color: Colors.white),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context,
                      "/data-viewer-aryav"); // Navigates to Aryav's Data Viewer Page.
                },
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                      color: Constants.darkPurple,
                      image: DecorationImage(
                          image: AssetImage("assets/images/tdv_bg.jpg")),
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ARYAV'S DATA VIEWER",
                            style: comfortaaBold(25, color: Colors.white)),
                        AutoSizeText(
                          "A more specialized data viewer page made specifically for drive team, featuring detailed auto information and comments.",
                          style: comfortaaBold(screenWidth * 0.03,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/data-viewer-amongview");
                },
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                      color: Constants.darkPurple,
                      image: DecorationImage(
                          image: AssetImage("assets/images/amongview_bg.png")),
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("AMONGVIEW",
                            style: comfortaaBold(25, color: Colors.white)),
                        AutoSizeText(
                          "A more comprehensive data viewer page geared more towards strat team, with a focus on direct data comparison between teams.",
                          style: comfortaaBold(screenWidth * 0.03,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ServerTestWidget(
                width: 345,
                darkMode: true,
              ),
              UploadButton(
                width: 400,
                route: "/home-data-viewer",
              ),
              DownloadButton(
                width: 400,
              )
            ],
          ),
        ),

        appBar: AppBar(
          backgroundColor:
              context.colors.backgroundPrimary, // Sets the app bar color.
          title: Text(
            "LightHouse",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: context.colors.titleText),
          ),
          centerTitle: true, // Centers the title in the app bar.
          iconTheme: IconThemeData(color: context.colors.titleText),
          actions: [
            AuthButton(),
            if (configData["debugMode"] == "true")
              // Button to display JSON config data in a dialog.
              IconButton(
                icon: Icon(Icons.javascript_outlined, color: context.colors.titleText),
                onPressed: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: context.colors.container,
                          content: Text(
                            jsonEncode(configData).toString(),
                            style: comfortaaBold(15,
                                color: context.colors.containerText),
                          ),
                        );
                      });
                }),
              ),
            // Button to navigate to settings page.
            IconButton(
                icon: Icon(Icons.settings, color: context.colors.titleText),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                })
          ],
        ),

        // Drawer menu for navigation between different app modes.
        drawer: Drawer(
          backgroundColor: context.colors.container,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration:
                      BoxDecoration(color: context.colors.backgroundPrimary),
                  child: AutoSizeText(
                    "Hi, ${configData["scouterName"]}!",
                    style: comfortaaBold(25, color: context.colors.titleText),
                    textAlign: TextAlign.start,
                  )),
              ListTile(
                  leading: Icon(
                    Icons.home,
                    color: context.colors.containerText,
                  ),
                  title: Text("Scouter Home",
                      style: comfortaaBold(18,
                          color: context.colors.containerText)),
                  onTap: () {
                    Navigator.pushNamed(context, "/home-scouter");
                  }),
              ListTile(
                  leading: Icon(
                    Icons.bar_chart,
                    color: context.colors.containerText,
                  ),
                  title: Text("Data Viewer Home",
                      style: comfortaaBold(18,
                          color: context.colors.containerText)),
                  onTap: () {
                    Navigator.pop(
                        context); // Closes the drawer, since the user is already on this page.
                  }),
              ListTile(
                  leading: Icon(
                    Icons.grid_3x3,
                    color: context.colors.containerText,
                  ),
                  title: Text("Testing Ground",
                      style: comfortaaBold(18,
                          color: context.colors.containerText)),
                  onTap: () async {
                    Navigator.pushNamed(context, "/testing-ground");
                  })
            ],
          ),
        ),
      ),
    );
  }
}
