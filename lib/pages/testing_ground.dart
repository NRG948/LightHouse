import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart";
import "package:lighthouse/widgets/rebuilt/tower_location_selector.dart";

class TestingGroundPage extends StatefulWidget {
  const TestingGroundPage({super.key});

  @override
  State<TestingGroundPage> createState() => _TestingGroundPageState();
}

class _TestingGroundPageState extends State<TestingGroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: configData["theme"] != null
          ? themeColorPalettes[configData["theme"] ?? "Dark"]![0]
          : Constants.pastelRed,
      appBar: AppBar(
        backgroundColor: themeColorPalettes[configData["theme"] ?? "Dark"]![0],
        title: const Text(
          "Testing Ground",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Constants.pastelWhite),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home-scouter");
            },
            icon: Icon(
              Icons.home,
              color: Constants.pastelWhite,
            )),
      ),
      body: RebuiltAutoPathSelector(),
    );
  }
}
