import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class NRGStopwatch extends StatefulWidget {
  final String title = "Stopwatch";
  final double height = 90;
  final double width = 360;
  final bool horizontal;
  final int pageIndex;
  final pageController;
  final DataEntryState dataEntryState;

  // Constructor for NRGStopwatch widget
  const NRGStopwatch({super.key, required this.pageController, required this.pageIndex, required this.dataEntryState, this.horizontal = false});

  @override
  State<NRGStopwatch> createState() => _NRGStopwatchState();
}

class _NRGStopwatchState extends State<NRGStopwatch> with AutomaticKeepAliveClientMixin{
  
  final _stopwatch = Stopwatch();
  double get _height => widget.height;
  double get _width => widget.width;

  // Usually, it is enough to just use "double.parse(_height/_width)", but here,
  // it is used enough times that it's worth it to just make them
  // individual variables of their own. Due to this however you need to *restart* the
  // app to see any changes to the dimensions, not just hot reload it.
  // (I know on vscode you can just press the green circle-arrow to do this. )
  late final double height;
  late final double width;
  
  // We need this so that we can call setState and have the stopwatch text change.
  late Duration stopwatchResult;
  late Duration stopwatchDisplay;
  late Timer? _timer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("RUNNING!");
    super.initState();
    DataEntry.stopwatchMap[widget.pageIndex] = Duration(seconds: 0);
    _stopwatch.reset();
    height = _height;
    width = _width;

    stopwatchResult = _stopwatch.elapsed;
    // Value that is displayed. 
    stopwatchDisplay = widget.dataEntryState.stopwatchInitialValue;
    
    // Timer that updates the stopwatch display every 100 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        stopwatchResult = _stopwatch.elapsed;
        print(stopwatchResult);
        stopwatchDisplay = widget.dataEntryState.stopwatchInitialValue - stopwatchResult;
        if (stopwatchDisplay < Duration(seconds: 0)) {
          stopwatchDisplay = Duration(seconds: 0);
          _stopwatch.stop();
        }
        if (stopwatchResult > Duration(seconds: 0)) {
        DataEntry.stopwatchMap[widget.pageIndex] = _stopwatch.elapsed;
        }
      });
    });

    // Add listener to pageController to handle page changes
     widget.pageController.addListener(_pageListener);
  }

  // Listener to handle page changes and start/stop the stopwatch accordingly
   void _pageListener() {
    if (widget.dataEntryState.isUnderGuidance) {
      if (widget.pageController.page?.round() != widget.pageIndex) {
        _stopwatch.stop(); // Stop the stopwatch when navigating away
        _stopwatch.reset();
      } else {
        _stopwatch.start(); // Restart the stopwatch when navigating back
        _stopwatch.reset();
      }
    } else if (widget.dataEntryState.isUnderGuidance) {
      if (widget.pageController.page?.round() != widget.pageIndex) {
        _stopwatch.stop(); // Stop the stopwatch when navigating away
        _stopwatch.reset();
      } else {
        _stopwatch.reset();
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
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Row(
        children: [
          // Custom widget to display the stopwatch time
          HoriVert(height: height, width: width, stopwatchDisplay: stopwatchDisplay, widget: widget, horizontal: widget.horizontal),
          Container(
            margin: EdgeInsets.only(
                left: width *
                    6 /
                    400), // For development, we can change the width without having to change this too.
            child: Transform.rotate(
              angle: widget.horizontal ? pi/2 : 0,
              child: IconButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  _stopwatch.stop();
                  _stopwatch.reset();
                },
                icon: Icon(
                  const IconData(0xe514, fontFamily: 'MaterialIcons'),
                  size: 45,
                  color: Constants.pastelGray,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0),
            child: Transform.rotate(
              angle: widget.horizontal ? pi/2 : 0,
              child: IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (_stopwatch.isRunning) {
                    _stopwatch.stop();
                    return;
                  }
                  _stopwatch.start();
                },
                icon: Icon(
                  const IconData(0xf2af, fontFamily: 'MaterialIcons'),
                  size: 45,
                  color: Constants.pastelGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoriVert extends StatelessWidget {
  const HoriVert({
    super.key,
    required this.height,
    required this.width,
    required this.stopwatchDisplay,
    required this.widget,
    this.horizontal = false
  });

  final double height;
  final double width;
  final Duration stopwatchDisplay;
  final NRGStopwatch widget;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    return horizontal ? Container(
      margin: EdgeInsets.only(left: height * 0.1),
      height: height * 0.8,
      width: width * 0.6,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: HoriVertText(stopwatchDisplay: stopwatchDisplay, height: height, width: width, horizontal: horizontal,),
    ) :Container(
      margin: EdgeInsets.only(left: height * 0.1),
      height: height * 0.8,
      width: width * 0.6,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Center(
        child: HoriVertText(stopwatchDisplay: stopwatchDisplay, height: height, horizontal: horizontal,),
      ),
    )  ;
  }
}

class HoriVertText extends StatelessWidget {
  const HoriVertText({
    super.key,
    required this.stopwatchDisplay,
    required this.height,
    required this.horizontal,
    this.width = 0
  });

  final Duration stopwatchDisplay;
  final double height;
  final bool horizontal;
  final double width;

  @override
  Widget build(BuildContext context) {
    return horizontal ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Transform.rotate(
          angle: pi/2,
          child: Text(((stopwatchDisplay.inMilliseconds / 100) % 10).toInt().toString(),style: comfortaaBold(20,color: Constants.markerDarkGray),)),
          Transform.rotate(
          angle: pi/2,
          child: Text(".",style: comfortaaBold(20,color: Constants.markerDarkGray))),
          Transform.rotate(
          angle: pi/2,
          child: Text((stopwatchDisplay.inSeconds % 60).toInt().toString().padLeft(2, "0"),style: comfortaaBold(20,color: Constants.markerDarkGray))),
          Transform.rotate(
          angle: pi/2,
          child: Text(":",style: comfortaaBold(20,color: Constants.markerDarkGray))),
          Transform.rotate(
          angle: pi/2,
          child: Text(stopwatchDisplay.inMinutes.toString(),style: comfortaaBold(20,color: Constants.markerDarkGray))),
    
      ],
    )
    : Text(
      "${stopwatchDisplay.inMinutes} : ${(stopwatchDisplay.inSeconds % 60).toInt().toString().padLeft(2, "0")} . ${((stopwatchDisplay.inMilliseconds / 100) % 10).toInt()}",
      textAlign: TextAlign.center,
      textScaler: TextScaler.linear(height * 3 /100), // For development, we can change the height without having to change this too.
      
    );
  }
}
