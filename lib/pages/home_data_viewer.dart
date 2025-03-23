import 'dart:convert';

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

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
            child: Column(
              spacing: 10,
              children: [
          Container(
            decoration: BoxDecoration(
              color: Constants.pastelGray,
              borderRadius: BorderRadius.circular(Constants.borderRadius) 
            ),
            child: TextButton(onPressed: () {
              Navigator.pushNamed(context, "/data-viewer-tony"); // Navigates to Tony's Data Viewer Page.
            }, child: Text("Tony's Data Viewer Page",style: comfortaaBold(18))),
          ),
           Container(
              decoration: BoxDecoration(
              color: Constants.pastelGray,
              borderRadius: BorderRadius.circular(Constants.borderRadius) 
            ),
             child: TextButton(onPressed: () {
              Navigator.pushReplacementNamed(context, "/data-viewer-amongview");
                     }, child: Text("Amongview",style: comfortaaBold(18))),
           ),
           ServerTestWidget(width: 400),
           UploadButton(width: 400,route: "/home-data-viewer",),
           DownloadButton(width: 400,)
        ],),
        ),

        appBar: AppBar(
          backgroundColor: Constants.pastelRed, // Sets the app bar color.
          title: const Text(
            "LightHouse",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Colors.white),
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
