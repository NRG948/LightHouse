import "package:flutter/material.dart";
import "package:lighthouse/themes.dart";
import "package:lighthouse/widgets/game_agnostic/team_guessr.dart";

class TeamGuessrPage extends StatefulWidget {
  const TeamGuessrPage({super.key});

  @override
  State<TeamGuessrPage> createState() => _TeamGuessrPageState();
}

class _TeamGuessrPageState extends State<TeamGuessrPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: context.colors.backgroundPrimary,
        title: Text(
          "Team Guessr",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: context.colors.titleText),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/playground");
            },
            icon: Icon(
              Icons.home,
              color: context.colors.titleText,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: screenWidth,
        height: screenHeight,
        decoration: context.backgroundDecoration,
        child: TeamGuessr(),
      ),
    );
  }
}
