import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/layouts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<LayoutLauncher> getLayouts() {
    final enabledLayouts = layoutMap.keys;
    return enabledLayouts.map((layout) {
      return LayoutLauncher(icon: iconMap[layout] ?? Icons.data_object, title: layout);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    loadConfig();
    return Scaffold(
        backgroundColor: Constants.pastelRed,
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: getLayouts())),
        );
  }
}

class LayoutLauncher extends StatelessWidget {
  final IconData icon;
  final String title;
  const LayoutLauncher({super.key, required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/entry", arguments: title);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100,
          width: 400,
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
