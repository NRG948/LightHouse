import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';

class Metric extends StatefulWidget {
  final String checkboxTitle;
  final List<String> selectOptions;
  final double height;
  final double? margin;

  final Color optionColor;
  final Color selectColor;
  final Color textColor;
  final Color lockedColor;

  const Metric({
    super.key,
    required this.checkboxTitle,
    required this.selectOptions,
    required this.height,
    this.margin,
    this.optionColor = Constants.pastelRed,
    this.selectColor = Constants.pastelWhite,
    this.textColor = Constants.pastelBrown,
    this.lockedColor = Constants.pastelGray,
  });

  @override
  State<Metric> createState() => _MetricState();
}

class _MetricState extends State<Metric> {
  String get _checkboxTitle => widget.checkboxTitle;
  List<String> get _selectOptions => widget.selectOptions;
  double get _height => widget.height;
  double get _margin => widget.margin ?? widget.height / 10;

  Color get _optionColor => widget.optionColor;
  Color get _selectColor => widget.selectColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;

  bool _isLocked = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: EdgeInsets.all(_margin),
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(_margin)),
      child: Column(
        spacing: _margin,
        children: [
          Expanded(
            flex: 4,
            child: CustomCheckbox(
              title: _checkboxTitle,
              selectColor: _selectColor,
              optionColor: _optionColor,
              textColor: _textColor,
              onToggle: (value) {
                setState(() {
                  _isLocked = !value;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChoiceSelector(
              choices: _selectOptions,
              spacing: _margin,
              selectColor: _selectColor,
              optionColor: _optionColor,
              textColor: _textColor,
              lockedColor: _lockedColor,
              isLocked: _isLocked,
              retainSelectionOnLock: false,
            ),
          ),
        ],
      ),
    );
  }
}
