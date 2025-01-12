import 'package:flutter/material.dart';

class NRGStopwatch extends StatefulWidget {
  NRGStopwatch({super.key});

  final stopwatch = Stopwatch();

  @override
  State<NRGStopwatch> createState() => _NRGCheckboxState();
}

class _NRGCheckboxState extends State<NRGStopwatch> {
  Stopwatch get _stopwatch => widget.stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}