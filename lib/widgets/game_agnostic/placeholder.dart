import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';

/// An empty widget.
class NRGPlaceholder extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  const NRGPlaceholder(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width});

  @override
  State<NRGPlaceholder> createState() => _NRGPlaceholderState();
}

class _NRGPlaceholderState extends State<NRGPlaceholder> {
  double get _height => widget.height;

  double get _width => widget.width;

  String get title => widget.title;

  get _key => widget.jsonKey;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Text("Placeholder $title"));
  }

  @override
  void initState() {
    super.initState();
    configData[_key] = "placeholder";
  }
}
