import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';

class DataViewerHome extends StatelessWidget {
  const DataViewerHome({super.key});
  static late double scaleFactor;
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
                  Navigator.pushNamed(context, "/home-scouter");
                }
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text("Data Viewer Home"),
                onTap: () {
                  
                }
              )
              
            ],
          ),
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
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
            child: Text("Data Viewer Home")),
        );
  }
}