import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class TowerLocationSelector extends StatefulWidget {
  final double width;
  final Color backgroundColor;
  final Color mainColor;
  const TowerLocationSelector(
      {super.key,
      required this.width,
      this.backgroundColor = Constants.pastelWhite,
      this.mainColor = Constants.pastelRed});

  @override
  State<TowerLocationSelector> createState() => _TowerLocationSelectorState();
}

class _TowerLocationSelectorState extends State<TowerLocationSelector> {
  double get _width => widget.width;
  double get _height => _width * 0.5;
  double get _margin => _width / 25;

  Color get _mainColor => widget.mainColor;
  Color get _backgroundColor => widget.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: EdgeInsets.all(_margin),
      decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(_margin)),
    );
  }
}
