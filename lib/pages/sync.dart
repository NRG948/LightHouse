
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override 
  State<SyncPage> createState() => SyncPageState();
}

class SyncPageState extends State<SyncPage> {
  late http.Response response = http.Response("", 200);

  Future<void> fetchData(String requestedFileType) async {
    response = await http.get(Uri.parse("http://169.254.9.48/81"));
    if (response.statusCode == 200) {
      //stuff
    } else {
      debugPrint(response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final sizeScaleFactor = screenWidth / 400;
    debugPrint("size scale factor: $sizeScaleFactor");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.pastelWhite),
        backgroundColor: Constants.pastelRed,
        title: const Text("Sync", style: TextStyle(
           fontFamily: "Comfortaa",
           fontWeight: FontWeight.w900,
           color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pushNamed(context, "/home-scouter");}, icon: Icon(Icons.home)),
      ),
      body: Container(
        height: screenHeight,
        width: 400 * sizeScaleFactor,
        decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
        child: Center(
          child: Column (
            children: [
              GestureDetector(
                onTap: () {
                  fetchData("hi!").timeout(Duration(seconds: 10), onTimeout: () => {throw UnimplementedError("HELP!")});
                },
                child: Container(
                  height: 50,
                  width: 350 * sizeScaleFactor,
                  decoration: BoxDecoration(
                    color: Constants.pastelWhite,
                    borderRadius: BorderRadius.circular(Constants.borderRadius)
                  ),
                  child: Text(
                    "Sync", 
                    style: comfortaaBold(40, color: Constants.pastelReddishBrown),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10 * sizeScaleFactor), 
              Container(
                decoration: BoxDecoration(
                    color: Constants.pastelWhite,
                    borderRadius: BorderRadius.circular(Constants.borderRadius)
                  ),
                child: Text(
                  response.statusCode.toString(),
                  style: comfortaaBold(40, color: Constants.pastelReddishBrown), 
                ),
              ) 
            ],
          ), 
        ),
      )
    );}
}

