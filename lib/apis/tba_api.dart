import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/themes.dart';

final String version = "v3";
String get baseUrl => "https://www.thebluealliance.com/api/$version";

class TbaApi {
  /// downloads and saves TBA data to local storage. note that it opens a dialogue.
  static void downloadAndSaveData(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return TBADownloadDialog();
        });

    int? code = await TBADownloadDialog.responseCode.future;
    debugPrint("Recieved code $code");
  }
}

class TBADownloadDialog extends StatefulWidget {
  const TBADownloadDialog({super.key});
  static Completer<int?> responseCode = Completer<int?>();

  void setResponseCode(int code) {
    if (!responseCode.isCompleted) {
      responseCode.complete(code);
    }
  }

  @override
  State<TBADownloadDialog> createState() => _TBADownloadDialogState();
}

class _TBADownloadDialogState extends State<TBADownloadDialog> {
  String progressIndicator =
      "Downloading TBA Match data for ${configData["eventKey"]}...";
  @override
  void initState() {
    super.initState();
    downloadTBAInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 600,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            color: context.colors.container),
        child: Row(
          children: [
            CircularProgressIndicator(
              color: context.colors.containerText,
            ),
            AutoSizeText(
              progressIndicator,
              style: comfortaaBold(10, color: context.colors.containerText),
            ),
          ],
        ),
      ),
    );
  }

  void downloadTBAInfo() async {
    http.Response responseMatches = await http.get(
        Uri.parse("$baseUrl/event/${configData["eventKey"]}/matches/simple"),
        headers: {"X-TBA-Auth-Key": Constants.tbaAPIKey});
    http.Response responseEventInfo = await http.get(
        Uri.parse("$baseUrl/event/${configData["eventKey"]}/simple"),
        headers: {"X-TBA-Auth-Key": Constants.tbaAPIKey});
    http.Response responseEventOprs = await http.get(
        Uri.parse("$baseUrl/event/${configData["eventKey"]}/oprs"),
        headers: {"X-TBA-Auth-Key": Constants.tbaAPIKey});

    if (responseMatches.statusCode == 200) {
      saveTBAFile(configData["eventKey"]!, responseMatches.body, "matches");
      progressIndicator = "Downloaded Matches.";
    } else {
      setState(() {
        progressIndicator =
            "MATCH ERROR ${responseMatches.statusCode}: ${responseMatches.body}";
      });
      await Future.delayed(Duration(seconds: 1));
    }

    if (responseEventInfo.statusCode == 200) {
      saveTBAFile(
          configData["eventKey"]!, responseEventInfo.body, "event_info");
      progressIndicator += "\nDownloaded Event Info.";
    } else {
      setState(() {
        progressIndicator +=
            "\nEVENT INFO ERROR ${responseEventInfo.statusCode}: ${responseEventInfo.body}";
      });
      await Future.delayed(Duration(seconds: 1));
    }

    if (responseEventOprs.statusCode == 200) {
      saveTBAFile(
          configData["eventKey"]!, responseEventOprs.body, "event_oprs");
      progressIndicator += "\nDownloaded OPRs";
    } else {
      setState(() {
        progressIndicator +=
            "\nEVENT OPR ERROR ${responseEventOprs.statusCode}: ${responseEventOprs.body}";
      });
      await Future.delayed(Duration(seconds: 1));
    }

    widget.setResponseCode(responseMatches.statusCode);
  }
}
