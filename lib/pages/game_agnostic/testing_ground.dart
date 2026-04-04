import "package:flutter/material.dart";
import "package:lighthouse/themes.dart";
import "package:lighthouse/widgets/game_agnostic/team_guessr.dart";

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
      backgroundColor: context.colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: context.colors.backgroundPrimary,
        title: Text(
          "Testing Ground",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: context.colors.titleText),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home-scouter");
            },
            icon: Icon(
              Icons.home,
              color: context.colors.titleText,
            )),
      ),
      body: Center(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: TeamGuessr())),
    );
  }
}
