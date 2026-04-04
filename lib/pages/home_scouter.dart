import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/splash_texts.dart';
import 'package:lighthouse/themes.dart';

//stateless widget representing the home screen of the app
class ScouterHomePage extends StatefulWidget {
  const ScouterHomePage({super.key});

  @override
  State<ScouterHomePage> createState() => _ScouterHomePageState();
}

class _ScouterHomePageState extends State<ScouterHomePage> {
  late Future<Map<String, String>> asyncConfigData;
  @override
  void initState() {
    super.initState();
    asyncConfigData = loadConfig();
  }

  // This method generates a list of Launcher widgets based on layouts.
  List<Launcher> getLaunchers() {
    final enabledLaunchers = List<Launcher>.empty(growable: true);
    // Adding extra launchers for viewing saved data and syncing to the server.
    enabledLaunchers.add(Launcher(
        icon: Icons.public,
        title: "Atlas",
        route: "/atlas",
        color: context.colors.accent1));
    enabledLaunchers.add(Launcher(
        icon: Icons.analytics_rounded,
        title: "Pit",
        route: "/pit",
        color: context.colors.accent2));
    enabledLaunchers.add(Launcher(
      icon: Icons.folder,
      title: "View Saved Data",
      route: "/saved_data",
      color: context.colors.accent3,
    ));
    enabledLaunchers.add(Launcher(
        icon: Icons.sync_outlined,
        route: "/sync",
        title: "Sync to Server",
        color: context.colors.accent4));
    return enabledLaunchers;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and set scale factor
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool secretScreen = Random().nextInt(100) < 1;
    return FutureBuilder(
        future: asyncConfigData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: Constants.darkModeDarkGray,
              body: Center(
                  child: Text(
                "Loading...",
                style: comfortaaBold(40, color: Constants.darkModeLightGray),
              )),
            );
          }
          return PopScope(
            canPop: false,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: context.colors.backgroundPrimary,
              // Drawer menu with navigation options
              drawer: Drawer(
                backgroundColor: context.colors.container,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                            color: context.colors.backgroundPrimary),
                        child: AutoSizeText(
                          "Hi, ${configData["scouterName"]}!",
                          style: comfortaaBold(25,
                              color: context.colors.titleText),
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
                          HapticFeedback.mediumImpact();
                          Navigator.pop(context);
                        }),
                    ListTile(
                        leading: Icon(
                          Icons.bar_chart,
                          color: context.colors.containerText,
                        ),
                        title: Text("Data Viewer Home",
                            style: comfortaaBold(18,
                                color: context.colors.containerText)),
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, "/home-data-viewer");
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
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, "/testing-ground");
                        })
                  ],
                ),
              ),
              // App bar with icons for settings and displaying config data
              appBar: AppBar(
                iconTheme: IconThemeData(color: context.colors.titleText),
                backgroundColor: context.colors.backgroundPrimary,
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
                      icon: Icon(
                        Icons.settings,
                        color: context.colors.titleText,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pushNamed(context, "/settings");
                      })
                ],
              ),
              // Main body of the page with a background image
              body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: screenWidth,
                  height: screenHeight,
                  decoration: context.backgroundDecoration,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 0.75 * screenWidth,
                        child: AutoSizeText(
                          secretScreen ? "LightHuose" : "LightHouse",
                          style: comfortaaBold(60,
                              spacing: -6, color: context.colors.titleText),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                          height: 0.05 * screenHeight,
                          width: 0.8 * screenWidth,
                          child: isWishTime()
                              ? Stack(
                                alignment: AlignmentDirectional.topCenter,
                                  children: [
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        ColorizeAnimatedText(
                                          "WISH!",
                                          textStyle:
                                              comfortaaBold(30, spacing: -1, customFontWeight: FontWeight.w900),
                                          colors: [
                                            Colors.red,
                                            Colors.yellow,
                                            Colors.red,
                                          ],
                                          speed:
                                              const Duration(milliseconds: 400),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      isRepeatingAnimation: true,
                                      repeatForever: true,
                                      pause: Duration.zero,
                                    ),

                                    Text(
                                      "WISH!",
                                      style: comfortaaBold(30,
                                          spacing: -0.3,
                                          customFontWeight: FontWeight.w100),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : AutoSizeText(
                                  secretScreen
                                      ? "Nobody will ever believe you"
                                      : randomSplashText(),
                                  style: comfortaaBold(18,
                                      spacing: -1,
                                      color: context.colors.titleText),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                )),
                      Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: getLaunchers()),
                      SizedBox(height: 10),
                      SizedBox(
                          height: 0.05 * screenHeight,
                          width: 0.8 * screenWidth,
                          child: AutoSizeText(
                            "${Constants.versionName} | ${snapshot.data!["scouterName"]} | ${snapshot.data!["eventKey"]}",
                            style: comfortaaBold(18,
                                color: context.colors.titleText),
                            textAlign: TextAlign.center,
                          ))
                    ],
                  )),
            ),
          );
        });
  }
}

// Launcher widget represents a button that navigates to different app sections.
class Launcher extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final Color color;
  const Launcher({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
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
      child: AspectRatio(
        aspectRatio: 5,
        child: Container(
          //the size of the box that holds each choice
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: context.colors.container,
              borderRadius: BorderRadius.circular(Constants.borderRadius * 2)),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color, // Background color of the container
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Center(
                    child: AutoSizeText(title.toUpperCase(),
                        style:
                            comfortaaBold(25, color: context.colors.container)),
                  ),
                ),
              ),

              // Icon positioned on the right side
              Center(
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
