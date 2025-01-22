import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class NRGGuidanceButton extends StatefulWidget {
  final double height;
  final double width;
  final Function startGuidance;
  final Function endGuidance;
  const NRGGuidanceButton ({
    super.key, 
    required this.height, 
    required this.width, 
    required this.startGuidance, 
    required this.endGuidance, 
  }); 
  
  @override
  State<StatefulWidget> createState() => _NRGGuidanceButtonState();
}

class _NRGGuidanceButtonState extends State<NRGGuidanceButton> {
  double get _height => widget.height;
  double get _width => widget.width;
  Function get _startGuidance => widget.startGuidance;
  Function get _endGuidance => widget.endGuidance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width, 
      decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: ElevatedButton(onPressed: () => _startGuidance(), child: Text("Start w/ Guided Navigation")),
    );
  }
}