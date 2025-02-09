import "dart:convert";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/data_entry.dart";

class NRGTextbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  final bool numeric;
  final String defaultText;
  final double fontSize;
  final int maxLines;
  final String? autoFill;
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
      this.defaultText = "Enter Text"});

  @override
  State<NRGTextbox> createState() => _NRGTextboxState();
}

class _NRGTextboxState extends State<NRGTextbox> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  double get _height => widget.height;
  double get _width => widget.width;
  bool get _numeric => widget.numeric;
  int get _maxLines => widget.maxLines;
  double get _fontSize => widget.fontSize;
  final TextEditingController _controller = TextEditingController();

  // Apparently all this TextEditingController BS can just be done by passing a lambda to the onChanged
  // parameter of a TextField, but this method lets us set an initial value sooooooo
  // idk
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        if (widget.numeric) {
        try {
        DataEntry.exportData[_key] =jsonDecode(_controller.text);
        } catch (_) {
          DataEntry.exportData[_key] = 0;
        }
      } else {
        DataEntry.exportData[_key] = _controller.text;
      }});
    });
    DataEntry.exportData[_key] = "";
    if (widget.autoFill != null) {
      switch (widget.autoFill) {
        case "scouterName":
          _controller.text = configData["scouterName"] ?? "Scouter";
      }
    }
    
  }
  // idk what this one does but gpt demands it
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
                keyboardType:
                    _numeric ? TextInputType.number : TextInputType.text,
                inputFormatters:
                    _numeric ? [FilteringTextInputFormatter.digitsOnly] : [],
                controller: _controller,
                style: comfortaaBold(_fontSize,color: Constants.pastelReddishBrown),
                maxLines: _maxLines,
                decoration: InputDecoration(
                  
                    labelText: _title,
                    labelStyle: comfortaaBold(_fontSize,color: Constants.pastelReddishBrown,italic: true),
                    fillColor: Constants.pastelYellow,
                    filled:true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constants.borderRadius),
                      borderSide: BorderSide.none
                    )),
                ),
          ),
        ));
  }
}
