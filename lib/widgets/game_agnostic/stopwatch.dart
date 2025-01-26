import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class NRGStopwatch extends StatefulWidget {
  final String title = "Stopwatch";
  final double height = 100;
  final double width = 400;
  final int pageIndex;
  final pageController;
  final DataEntryState dataEntryState;

  final stopwatch = Stopwatch();

  NRGStopwatch({super.key, required this.pageController, required this.pageIndex, required this.dataEntryState});

  @override
  State<NRGStopwatch> createState() => _NRGStopwatchState();
}

class _NRGStopwatchState extends State<NRGStopwatch> {
  Stopwatch get _stopwatch => widget.stopwatch;
  double get _height => widget.height;
  double get _width => widget.width;

  //usually, it is enough to just use "double.parse(_height/_width)", but here,
  //it is used enough times that it's worth it to just make them
  //individual variables of their own. Due to this however you need to *restart* the
  //app to see any changes to the dimensions, not just hot reload it.
  //(I know on vscode you can just press the green circle-arrow to do this. )
  late final double height;
  late final double width;

  //We need this so that we can call setState and have the stopwatch text change.
  late Duration stopwatchResult;
  late Duration stopwatchDisplay;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch.reset();
    height = _height;
    width = _width;

    stopwatchResult = _stopwatch.elapsed;
    //value that is displayed. 
    stopwatchDisplay = widget.dataEntryState.stopwatchInitialValue;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        stopwatchResult = _stopwatch.elapsed;
        stopwatchDisplay = widget.dataEntryState.stopwatchInitialValue - stopwatchResult;
        if (stopwatchDisplay < Duration(seconds: 0)) {
          print('HELLLLLLPPPPPPPPPPP');
          stopwatchDisplay = Duration(seconds: 0);
          _stopwatch.stop();
        }
      });
    });

     widget.pageController.addListener(_pageListener);
  }

   void _pageListener() {
    if (widget.dataEntryState.isUnderGuidance) {
      if (widget.pageController.page?.round() != widget.pageIndex) {
      _stopwatch.stop(); // Stop the stopwatch when navigating away
      } else {
        _stopwatch.start(); // Restart the stopwatch when navigating back
      }
    }
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
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: height * 0.1),
            height: height * 0.8,
            width: width * 0.6,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Text(
                "${stopwatchDisplay.inMinutes} : ${(stopwatchDisplay.inSeconds % 60).toInt().toString().padLeft(2, "0")} : ${((stopwatchDisplay.inMilliseconds / 100) % 10).toInt()}",
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(height * 3 /100), //For development, we can change the height without having to change this too.
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: width *
                    6 /
                    400), //For development, we can change the width without having to change this too.
            child: IconButton(
              onPressed: () {
                _stopwatch.stop();
                _stopwatch.reset();
              },
              icon: Icon(
                IconData(0xe514, fontFamily: 'MaterialIcons'),
                size: 45,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0),
            child: IconButton(
              onPressed: () {
                if (_stopwatch.isRunning) {
                  _stopwatch.stop();
                  return;
                }
                _stopwatch.start();
              },
              icon: Icon(
                IconData(0xf2af, fontFamily: 'MaterialIcons'),
                size: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
