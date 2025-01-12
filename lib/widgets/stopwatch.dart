import 'package:flutter/material.dart';

class NRGStopwatch extends StatefulWidget {
  NRGStopwatch({super.key});

  final String title = "Stopwatch";
  final String height = "100";
  final String width = "400";

  final stopwatch = Stopwatch();

  @override
  State<NRGStopwatch> createState() => _NRGCheckboxState();
}

class _NRGCheckboxState extends State<NRGStopwatch> {
  Stopwatch get _stopwatch => widget.stopwatch;
  String get _height => widget.height;
  String get _width => widget.width;

  //usually, it is enought to just use "double.parse(_height/width)", but here, 
  //it is used enough times that it's worth it to just make them 
  //individual variables of their own. 
  late final double height;
  late final double width;

  @override
  void initState() {
    super.initState();
    _stopwatch.reset();
    height = double.parse(_height);
    width = double.parse(_width);
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
            child: Center(
              child: Text(
                "test", 
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(3),
              ),
            ), 
          ),
          Container(
            margin: EdgeInsets.only(left: 6), 
            child: IconButton(
              onPressed: _stopwatch.reset,
              icon: Icon(
                IconData(0xe514, fontFamily: 'MaterialIcons'), 
                size: 45,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0), 
            child: IconButton(
              onPressed: _stopwatch.start,
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