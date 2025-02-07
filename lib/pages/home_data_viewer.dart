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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
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
          Navigator.pushNamed(context, "/data-viewer-tony");
        }, child: Text("Tony's Data Viewer Page"))
      ],),
      ),
      appBar: AppBar(
        backgroundColor: Constants.pastelRed,
        title: const Text(
          "LightHouse",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Constants.pastelWhite
        ),
        actions: [
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
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              })
        ],
      ),
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
                    Navigator.pop(context);
                  })
            ],
          ),
        
      ),
      
    );
  }
}



