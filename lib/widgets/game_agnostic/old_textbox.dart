import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/data_entry.dart";
import "package:lighthouse/themes.dart";

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
  final Map<String, dynamic>?
      dataMap; // If set, writes here instead of DataEntry.exportData

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
      this.hintText,
      this.dataMap});

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
  Map<String, dynamic>? get _dataMap => widget.dataMap;

  // Controller for the text field
  final TextEditingController _controller = TextEditingController();

  // Initialize the state
  @override
  void initState() {
    super.initState();
    var target = _dataMap ?? DataEntry.exportData;
    target[_key] = "";
    // Add listener to update data when text changes
    _controller.addListener(() {
      setState(() {
        _serializeData();
      });
    });
    // Handle autofill if provided
    if (widget.autoFill != null) {
      switch (widget.autoFill) {
        case "scouterName":
          _controller.text = configData["scouterName"] ?? "Scouter";
      }
    }
  }

  void _serializeData() {
    var target = _dataMap ?? DataEntry.exportData;
    if (widget.numeric) {
      try {
        target[_key] = jsonDecode(_controller.text);
      } catch (_) {
        target[_key] = 0;
      }
    } else {
      target[_key] = _controller.text;
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
            color: context.colors.container,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Center(
          child: TextField(
            keyboardType: _numeric ? TextInputType.number : TextInputType.text,
            inputFormatters:
                _numeric ? [FilteringTextInputFormatter.digitsOnly] : [],
            controller: _controller,
            style: comfortaaBold(_fontSize, color: context.colors.text),
            maxLines: _maxLines,
            decoration: InputDecoration(
                labelText: _title,
                labelStyle: comfortaaBold(_fontSize,
                    color: context.colors.hintText, italic: true),
                fillColor: context.colors.accent2,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                    borderSide: BorderSide.none)),
          ),
        ));
  }
}
