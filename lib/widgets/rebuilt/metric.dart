import 'package:flutter/material.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';

class Metric extends StatefulWidget {
  final String checkboxTitle;
  final List<String> selectOptions;
  final double height;
  final double? margin;

  final Color? optionColor;
  final Color? selectColor;
  final Color? textColor;
  final Color? lockedColor;

  final String? jsonKey;

  const Metric({
    super.key,
    required this.checkboxTitle,
    required this.selectOptions,
    required this.height,
    this.margin,
    this.optionColor,
    this.selectColor,
    this.textColor,
    this.lockedColor,
    this.jsonKey,
  });

  @override
  State<Metric> createState() => _MetricState();
}

class _MetricState extends State<Metric> with AutomaticKeepAliveClientMixin {
@override
  bool get wantKeepAlive => true;
  String get _checkboxTitle => widget.checkboxTitle;
  List<String> get _selectOptions => widget.selectOptions;
  double get _height => widget.height;
  double get _margin => widget.margin ?? widget.height / 10;

  Color? get _optionColor => widget.optionColor;
  Color? get _selectColor => widget.selectColor;
  Color? get _textColor => widget.textColor;
  Color? get _lockedColor => widget.lockedColor;

  String? get _jsonKey => widget.jsonKey;

  bool _isChecked = false;
  String? _selection;

  void _serializeData() {
    if (_jsonKey == null) return;

    Map<String, dynamic> data = {
      "isChecked": _isChecked,
      "selection": _selection,
    };

    DataEntry.exportData[_jsonKey!] = data;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: _height,
      padding: EdgeInsets.all(_margin),
      decoration: BoxDecoration(
          color: context.colors.container,
          borderRadius: BorderRadius.circular(_margin)),
      child: Column(
        spacing: _margin,
        children: [
          Expanded(
            flex: 4,
            child: CustomCheckbox(
              title: _checkboxTitle,
              selectColor: _selectColor ?? context.colors.container,
              optionColor: _optionColor ?? context.colors.accent1,
              textColor: _textColor ?? context.colors.containerText,
              onToggle: (value) {
                setState(() {
                  _isChecked = value;
                  _serializeData();
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
              isLocked: !_isChecked,
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
