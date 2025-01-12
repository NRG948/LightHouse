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

  @override
  void initState() {
    super.initState();
    _stopwatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ,
    );
  }
}