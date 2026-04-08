import "dart:convert";

import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/device_id.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/themes.dart";
import 'package:http/http.dart' as http;
import "package:lighthouse/widgets/game_agnostic/default_container.dart";
import "package:lighthouse/widgets/game_agnostic/leaderboard.dart";

class PredictionsPage extends StatefulWidget {
  const PredictionsPage({super.key});

  @override
  State<PredictionsPage> createState() => _PredictionsPageState();
}

class _PredictionsPageState extends State<PredictionsPage> {
  Map<String, int> _predictionResults = {};
  bool _loading = true;
  int? _errorCode;

  @override
  void initState() {
    super.initState();
    _downloadPredictionResults();
  }

  Future<void> _downloadPredictionResults() async {
    final uuid = await getPersistentDeviceID();
    final response = await http.get(
      (Uri.tryParse("${configData["serverIP"]!}/api/prediction") ?? Uri.base),
      headers: {"Content-Type": "application/json", "X-API-KEY": uuid},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        _predictionResults = jsonDecode(response.body).cast<String, int>();
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
        _errorCode = response.statusCode;
      });
    }
  }

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
          "Predictions",
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
        child: Column(
          spacing: 10,
          children: [
            DefaultContainer(
              color: context.colors.container,
              margin: 10,
              expandHorizontal: true,
              child: Text(
                "Leaderboard",
                textAlign: TextAlign.center,
                style: comfortaaBold(25, color: context.colors.containerText),
              ),
            ),
            if (_loading)
              DefaultContainer(
                color: context.colors.container,
                margin: 10,
                expandHorizontal: true,
                child: DefaultContainer(
                  color: context.colors.accent2,
                  margin: 5,
                  child: Text(
                    "Loading...",
                    textAlign: TextAlign.center,
                    style: comfortaaBold(17, color: context.colors.text),
                  ),
                ),
              ),
            if (!_loading && _errorCode == null)
              AspectRatio(
                aspectRatio: 0.8,
                child: Leaderboard(
                  margin: 10,
                  statistics: _predictionResults,
                ),
              ),
            if (!_loading && _errorCode != null)
              DefaultContainer(
                color: context.colors.container,
                margin: 10,
                expandHorizontal: true,
                child: DefaultContainer(
                  color: context.colors.accent2,
                  margin: 5,
                  child: Text(
                    "Code $_errorCode",
                    textAlign: TextAlign.center,
                    style: comfortaaBold(17, color: context.colors.text),
                  ),
                ),
              ),
            Text(
              "Powered by The Blue Alliance",
              style: comfortaaBold(
                17,
                color: context.colors.titleText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
