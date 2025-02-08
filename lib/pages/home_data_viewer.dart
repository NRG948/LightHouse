import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';
import 'package:lighthouse/widgets/game_agnostic/scrollable_box.dart';



class DataViewerHome extends StatelessWidget {
  const DataViewerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor;
    final screenWidth = MediaQuery.of(context).size.width; // gets screen width
    final screenHeight = MediaQuery.of(context).size.height; // gets screen height
    scaleFactor = screenHeight / 914; //calculate scaling factor based on height
    loadConfig();
    
    return Scaffold(
      
      body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)),
          child: Column(children: [
        TextButton(onPressed: () {
          Navigator.pushNamed(context, "/data-viewer-tony"); // Navigates to Tony's Data Viewer Page.
        }, child: Text("Tony's Data Viewer Page")),
         TextButton(onPressed: () {
          Navigator.pushNamed(context, "/data-viewer-amongview"); // Navigates to Amongview page.
        }, child: Text("Amongview")),
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
        iconTheme: IconThemeData(
          color: Constants.pastelWhite
        ),
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
              DrawerHeader(child: Text("Switch Mode")),
              ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Scouter Home"),
                  onTap: () {
                    Navigator.pushNamed(context, "/home-scouter");
                  }),
              ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text("Data Viewer Home"),
                  onTap: () {
                    Navigator.pop(context); // Closes the drawer, since the user is already on this page.
                  })
            ],
          ),
        
      ),
      
    );
  }
}



