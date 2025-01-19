import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';

class NRGMCQ extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  const NRGMCQ(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      });

  @override
  State<NRGMCQ> createState() => _NRGMCQState(); 
}

class _NRGMCQState extends State<NRGMCQ> {
  String get _title => widget.title;
  double get _width => widget.width;
  double get _height => widget.height;
  String get _key => widget.jsonKey;

  @override
  Widget build(BuildContext context) {
    return NRGPlaceholder(
      title: _title,
      width: _width, 
      height: _height, 
      jsonKey: _key,
    );
  }
}