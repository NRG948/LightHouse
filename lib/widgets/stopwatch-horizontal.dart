import 'dart:async';

import 'package:flutter/material.dart';

class NRGStopwatchHorizontal extends StatefulWidget {
  NRGStopwatchHorizontal({super.key});

  final String title = "Stopwatch";
  final String height = "100";
  final String width = "400";

  final stopwatch = Stopwatch();

  @override
  State<NRGStopwatchHorizontal> createState() => _NRGStopwatchHorizontalState();
}

class _NRGStopwatchHorizontalState extends State<NRGStopwatchHorizontal> {
  Stopwatch get _stopwatch => widget.stopwatch;
  String get _height => widget.height;
  String get _width => widget.width;

  //usually, it is enough to just use "double.parse(_height/_width)", but here, 
  //it is used enough times that it's worth it to just make them 
  //individual variables of their own. Due to this however you need to *restart* the 
  //app to see any changes to the dimensions, not just hot reload it. 
  //(I know on vscode you can just press the green circle-arrow to do this. )
  late final double height;
  late final double width;

  //We need this so that we can call setState and have the stopwatch text change. 
  late Duration stopwatchResult;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch.reset();
    height = double.parse(_height);
    width = double.parse(_width);

    stopwatchResult = _stopwatch.elapsed;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer){
      setState(() {
        stopwatchResult = _stopwatch.elapsed;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: height * 0.1),
            height: height * 0.8, 
            width: width * 0.6,
            decoration: BoxDecoration(color: Colors.white), 
            child: Align(
              alignment: Alignment(0.54, 0),
              child: Transform.rotate(
                angle: 1.5708,
                child: Text(
                  "${stopwatchResult.inMinutes.toString().padLeft(2, "0")}\n${(stopwatchResult.inSeconds % 60).toInt().toString().padLeft(2, "0")}\n${((stopwatchResult.inMilliseconds / 100) % 10).toInt().toString().padLeft(2, "0")}", 
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(height * 3/100), //For development, we can change the height without having to change this too. 
                  overflow: TextOverflow.visible,
                ),
              ),
            ), 
          ),
          Container(
            margin: EdgeInsets.only(left: width * 6/400), //For development, we can change the width without having to change this too. 
            child: IconButton(
              onPressed: () {_stopwatch.stop(); _stopwatch.reset();},
              icon: Transform.rotate(
                angle: 1.5708,
                child: Icon(
                  IconData(0xe514, fontFamily: 'MaterialIcons'), 
                  size: 45,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0), 
            child: IconButton(
              onPressed: () {
                if (_stopwatch.isRunning){
                  _stopwatch.stop();
                  return;
                }
                _stopwatch.start();
              },
              icon: Transform.rotate(
                angle: 1.5708,
                child: Icon(
                  IconData(0xf2af, fontFamily: 'MaterialIcons'), 
                  size: 45,
                ),
              ),
            ),
          ),  
        ],
      ),
    );
  }
}