import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';

class MultiChoiceSelector extends StatefulWidget {
  final List<String> selectOptions;
  final double height;
  final double? margin;
  final String? title;

  final Color optionColor;
  final Color selectColor;
  final Color textColor;
  final Color lockedColor;

  final String jsonKey;

  const MultiChoiceSelector({
    super.key,
    required this.selectOptions,
    required this.height,
    this.title, 
    this.margin,
    this.optionColor = Constants.pastelRed,
    this.selectColor = Constants.pastelWhite,
    this.textColor = Constants.pastelBrown,
    this.lockedColor = Constants.pastelGray,
    required this.jsonKey,
  });

  @override
  State<MultiChoiceSelector> createState() => _MultiChoiceSelectorState();
}

class _MultiChoiceSelectorState extends State<MultiChoiceSelector> {
  List<String> get _selectOptions => widget.selectOptions;
  double get _height => widget.height;
  double get _margin => widget.margin ?? widget.height / 10;

  Color get _optionColor => widget.optionColor;
  Color get _selectColor => widget.selectColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;

  String? get _jsonKey => widget.jsonKey;

  String? _selection;

  void _serializeData() {
    if (_jsonKey == null) return;

    DataEntry.exportData[_jsonKey!] = _selection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: EdgeInsets.all(_margin),
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(_margin)),
      child: Column(
        children: [
          widget.title != null ? Text(widget.title!, style: comfortaaBold(30, color: Constants.black),) : Container(), 
          Expanded(
            flex: 3,
            child: SingleChoiceSelector(
              choices: _selectOptions,
              spacing: _margin,
              selectColor: _selectColor,
              optionColor: _optionColor,
              textColor: _textColor,
              lockedColor: _lockedColor,
              isLocked: false,
              retainSelectionOnLock: false,
              onSelect: (choice) {
                _selection = choice;
                _serializeData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
