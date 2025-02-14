import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

// This widget represents a button that starts a guidance process.
class NRGGuidanceButton extends StatefulWidget {
  // The height of the button.
  final double height;
  // The width of the button.
  final double width;
  // The function to be called when the button is pressed.
  final Function startGuidance;

  // Constructor for the NRGGuidanceButton widget.
  const NRGGuidanceButton ({
    super.key, 
    required this.height, 
    required this.width, 
    required this.startGuidance, 
  }); 
  
  @override
  State<StatefulWidget> createState() => _NRGGuidanceButtonState();
}

class _NRGGuidanceButtonState extends State<NRGGuidanceButton> {
  // Getter for the height of the button.
  double get _height => widget.height;
  // Getter for the width of the button.
  double get _width => widget.width;
  // Getter for the startGuidance function.
  Function get _startGuidance => widget.startGuidance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // When the button is tapped, call the startGuidance function.
      onTap: () {
        HapticFeedback.mediumImpact();
        _startGuidance(); 
      },
      child: Container(
        // Set the height and width of the button.
        height: _height,
        width: _width, 
        // Decorate the button with a background color and rounded corners.
        decoration: BoxDecoration(
              color: Constants.pastelWhite,
              borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Row(
                // Align the text and icon evenly within the button.
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                // Display the button text with specific styling.
                Text("GUIDED NAVIGATION",style: comfortaaBold(21,color: Constants.pastelReddishBrown),),
                // Display an arrow icon next to the text.
                Icon(Icons.arrow_forward,color: Constants.pastelReddishBrown,size:33)
              ],)
      ),
    );
  }
}