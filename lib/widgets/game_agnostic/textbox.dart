import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/data_entry.dart";

// Stateful widget for a custom text box
class NRGTextbox extends StatefulWidget {
  final String title; // Title of the text box
  final String jsonKey; // Key to store the text box data in JSON
  final double height; // Height of the text box
  final double width; // Width of the text box
  final bool numeric; // Whether the text box accepts only numeric input
  final String defaultText; // Default text to display in the text box
  final double fontSize; // Font size of the text
  final int maxLines; // Maximum number of lines for the text box
  final String? autoFill; // Optional autofill value
  final String? hintText; // Optional hint text

  const NRGTextbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      this.autoFill,
      this.numeric = false,
      required this.fontSize,
      required this.maxLines,
      this.defaultText = "Enter Text",
      this.hintText});

  @override
  State<NRGTextbox> createState() => _NRGTextboxState();
}

class _NRGTextboxState extends State<NRGTextbox>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Getters for widget properties
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  double get _height => widget.height;
  double get _width => widget.width;
  bool get _numeric => widget.numeric;
  int get _maxLines => widget.maxLines;
  double get _fontSize => widget.fontSize;

  // Controller for the text field
  final TextEditingController _controller = TextEditingController();

  // Initialize the state
  @override
  void initState() {
    super.initState();
    // Add listener to update exportData when text changes
    _controller.addListener(() {
      setState(() {
        if (widget.numeric) {
          try {
            // Try to parse the text as JSON
            DataEntry.exportData[_key] = jsonDecode(_controller.text);
          } catch (_) {
            // If parsing fails, store number 0
            DataEntry.exportData[_key] = 0;
          }
        } else {
          DataEntry.exportData[_key] = _controller.text;
        }
      });
    });
    // Initialize exportData with an empty string
    DataEntry.exportData[_key] = "";
    // Handle autofill if provided
    if (widget.autoFill != null) {
      switch (widget.autoFill) {
        case "scouterName":
          _controller.text = configData["scouterName"] ?? "Scouter";
      }
    }
  }

  // Dispose the controller when the widget is disposed
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Build the widget
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              keyboardType:
                  _numeric ? TextInputType.number : TextInputType.text,
              inputFormatters:
                  _numeric ? [FilteringTextInputFormatter.digitsOnly] : [],
              controller: _controller,
              style:
                  comfortaaBold(_fontSize, color: Constants.pastelReddishBrown),
              maxLines: _maxLines,
              decoration: InputDecoration(
                  labelText: _title,
                  labelStyle: comfortaaBold(_fontSize,
                      color: Constants.pastelReddishBrown, italic: true),
                  fillColor: Constants.pastelYellow,
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius),
                      borderSide: BorderSide.none)),
            ),
          ),
        ));
  }
}
