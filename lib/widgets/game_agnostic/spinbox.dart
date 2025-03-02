import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

/// A manual counter that counts integers greater than 0.
class NRGSpinbox extends StatefulWidget {
  final String title; // Title of the spinbox
  final String jsonKey; // Key to store the value in exportData
  final double height; // Height of the spinbox widget
  final double width; // Width of the spinbox widget
  const NRGSpinbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width});

  @override
  State<NRGSpinbox> createState() => _NRGSpinboxState();
}

class _NRGSpinboxState extends State<NRGSpinbox> {
  String get _title => widget.title; // Getter for title
  String get _key => widget.jsonKey; // Getter for jsonKey
  double get _height => widget.height; // Getter for height
  double get _width => widget.width; // Getter for width
  late int _counter; // Counter value
  String _value = ""; // String representation of the counter value

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          children: [
            SizedBox(
            width: _width * 0.8,
            child: AutoSizeText(_title, style: comfortaaBold(30,color: Constants.pastelBrown))), // Display the title
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        decrement(); // Decrement counter on button press
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      )),
                  AutoSizeText(
                    "$_counter",
                    style: comfortaaBold(30,color: Constants.pastelBrown), // Display the counter value
                  ),
                  IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        increment(); // Increment counter on button press
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                      )),
                ],
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _counter = 0; // Initialize counter to 0
    DataEntry.exportData[_key] = 0; // Initialize exportData with the counter value
  }

  void decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--; // Decrease counter if it's greater than 0
        updateState(); // Update the state in exportData
      }
    });
  }

  void increment() {
    setState(() {
      _counter++; // Increase counter
      updateState(); // Update the state in exportData
    });
  }

  void updateState() {
    DataEntry.exportData[_key] = _counter; // Update exportData with the current counter value
  }
}
