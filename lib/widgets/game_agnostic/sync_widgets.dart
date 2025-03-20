import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:http/http.dart' as http;

class ServerTestWidget extends StatefulWidget {
  final double width;
  const ServerTestWidget({super.key, required this.width});

  @override
  State<ServerTestWidget> createState() => _ServerTestWidgetState();
}

class _ServerTestWidgetState extends State<ServerTestWidget> {

  late double scaleFactor;
  late TextEditingController controller;
  late Future<String> responseCode;
  @override
  void initState() {
    controller = TextEditingController(text: configData["serverIP"]);
    responseCode = testConnection();
    super.initState();
    scaleFactor = widget.width / 400;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400 * scaleFactor,
      height: 150 * scaleFactor,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),color: Constants.pastelWhite),
      child: Column(
        children: [
          SizedBox(height: 5 * scaleFactor,),
          SizedBox(
            height: 25 * scaleFactor,
            width: 250 * scaleFactor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Icon(Icons.language,color: Colors.black,size: 25 * scaleFactor,),
              Text("Server IP",style: comfortaaBold(18 * scaleFactor,color: Colors.black),)
            ],),
          ),
          SizedBox(height: 5 * scaleFactor,),
          SizedBox(
            width: 400 *scaleFactor,
            height: 50 * scaleFactor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300 * scaleFactor,
                  height: 200 * scaleFactor,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Constants.borderRadius)),
                      filled: true,
                      fillColor: Constants.pastelRed,
                      contentPadding: EdgeInsets.only(left: 5 * scaleFactor,right: 5 * scaleFactor)
                    ),
                    style: comfortaaBold(15 * scaleFactor),
                    onChanged: (e) {
                      configData["serverIP"] = e;
                      saveConfig();
                    },
                  ),
                ),
                
                Container(width: 50 * scaleFactor,
                height: 50 * scaleFactor,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),color: Constants.pastelRed,),
                child: IconButton(onPressed: () {setState(() {
                  responseCode = testConnection();
                });
                }, icon: Icon(Icons.network_ping,color: Colors.white,)),
                )
              ],
            ),
          ),
          SizedBox(height: 10 * scaleFactor,),
          FutureBuilder(future: responseCode, builder: (context,snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {return Container(
              height: 40 * scaleFactor,
              width: 250 * scaleFactor,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),color: Constants.pastelGray),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 20 * scaleFactor,
                    width: 20 * scaleFactor,
                    child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation<Color>(Constants.pastelBlue),)),
                  Text("Waiting for response...",style: comfortaaBold(15 * scaleFactor),)
                ],
              ),
            );}
            return Container(
              height: 40 * scaleFactor,
              width: 250 * scaleFactor,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),color: snapshot.data! == "Code 200 - OK" ? Constants.pastelGreen : Constants.pastelRedSuperDark),
              child: Center(child: AutoSizeText(snapshot.data!,style: comfortaaBold(18 * scaleFactor),textAlign: TextAlign.center,minFontSize: 12 * scaleFactor,maxLines:2,overflow: TextOverflow.ellipsis,)),
            );
          })
        ],
      ),
    );
    
  }
  Future<String> testConnection() async {
    while (configData["serverIP"] == null) {
      await Future.delayed(Duration(milliseconds: 200));
    }
    String serverIP = configData["serverIP"]!.removeTrailingSlashes;
    controller.text = controller.text.removeTrailingSlashes;

    final uri = Uri.tryParse(serverIP);
    if (uri == null) {
      return "ERROR: Invalid URL";
    }
    late final dynamic response;
    try {
      response = await http.get(Uri.parse("$uri/api/atlas"));
    } catch (e) {
     
      return "ERROR - $e";
    }
    return "Code ${response.statusCode.toString()} - ${responseCodes[response.statusCode]}";
  }
}