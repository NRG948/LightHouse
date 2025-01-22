import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/layouts.dart';

class ScouterHomePage extends StatelessWidget {
  const ScouterHomePage({super.key});
  static late double scaleFactor;
  List<Launcher> getLaunchers() {
    final enabledLayouts = layoutMap.keys;
    final enabledLaunchers = enabledLayouts.map((layout) {
      return Launcher(icon: iconMap[layout] ?? Icons.data_object, title: layout);
    }).toList();
    enabledLaunchers.add(Launcher(icon: Icons.folder,title: "View Saved Data", route: "/saved_data",));
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
                }
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text("Data Viewer Home"),
                onTap: () {
                  Navigator.pushNamed(context, "/home-data-viewer");
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: getLaunchers())),
        );
  }
}

class Launcher extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  const Launcher({super.key, required this.icon, required this.title, this.route = "/entry"});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route, arguments: title);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100 * ScouterHomePage.scaleFactor,
          width: 400 * ScouterHomePage.scaleFactor,
          color: Colors.white,
          child: Row(children: [
            Icon(icon),
            Text(title)
          ],),
        ),
      ),
    );
  }
}
