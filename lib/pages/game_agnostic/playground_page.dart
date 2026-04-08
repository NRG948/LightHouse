import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/game_agnostic/home_scouter.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  List<Launcher> getLaunchers(BuildContext context) {
    final enabledLaunchers = List<Launcher>.empty(growable: true);
    enabledLaunchers.add(Launcher(
        icon: Icons.assessment_rounded,
        route: "/prediction",
        title: "Predictions",
        color: context.colors.accent1));
    enabledLaunchers.add(Launcher(
        icon: Icons.question_mark_rounded,
        route: "/team-guessr",
        title: "Team Guessr",
        color: context.colors.accent2));
    return enabledLaunchers;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: context.backgroundDecoration,
          padding: EdgeInsets.all(15),
          child: Column(
            spacing: 10,
            children: [
              DefaultContainer(
                color: context.colors.container,
                margin: 10,
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.videogame_asset_rounded,
                      color: context.colors.containerText,
                      size: 24,
                    ),
                    Text(
                      "Playground",
                      style: comfortaaBold(24,
                          color: context.colors.containerText),
                    ),
                    Container(), // So the text ends up in the center
                  ],
                ),
              ),
              ...getLaunchers(context),
              Text(
                "And more to come!",
                style: comfortaaBold(
                  17,
                  color: context.colors.titleText,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: context.colors.backgroundPrimary,
          title: Text(
            "LightHouse",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: context.colors.titleText),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: context.colors.titleText),
          actions: [
            IconButton(
                icon: Icon(Icons.settings, color: context.colors.titleText),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                })
          ],
        ),
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
                    HapticFeedback.mediumImpact();
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
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, "/home-data-viewer");
                  }),
              ListTile(
                  leading: Icon(
                    Icons.grid_3x3,
                    color: context.colors.containerText,
                  ),
                  title: Text("Playground",
                      style: comfortaaBold(18,
                          color: context.colors.containerText)),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
