import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

class SingleChoiceSelector extends StatefulWidget {
  final List<String> choices;
  final Function(String choice) onSelect;
  final double height;
  final double spacing;
  final Color optionColor;
  final Color selectColor;
  final Color textColor;
  final bool isLocked;
  final bool retainSelectionOnLock;

  const SingleChoiceSelector({
    super.key,
    required this.choices,
    required this.height,
    required this.spacing,
    this.onSelect = _noop,
    required this.selectColor,
    this.optionColor = const Color.fromARGB(1, 255, 255, 255),
    this.textColor = Colors.black,
    this.isLocked = false,
    this.retainSelectionOnLock = true,
  });

  static void _noop(String choice) {}

  @override
  State<SingleChoiceSelector> createState() => _SingleChoiceSelectorState();
}

class _SingleChoiceSelectorState extends State<SingleChoiceSelector> {
  List<String> get _choices => widget.choices;
  Function(String choice) get _onSelect => widget.onSelect;
  double get _height => widget.height;
  double get _choiceWidth => _height * 0.7;
  double get _spacing => widget.spacing;
  Color get _optionColor => widget.optionColor;
  Color get _selectColor => widget.selectColor;
  Color get _textColor => widget.textColor;
  bool get _isLocked => widget.isLocked;
  bool get _retainSelectionOnLock => widget.retainSelectionOnLock;

  String _selectedChoice = "";

  Widget getChoiceButtons(String choice) {
    if (_isLocked && !_retainSelectionOnLock) _selectedChoice = "";
    return AbsorbPointer(
      absorbing: _isLocked,
      child: GestureDetector(
        onTapUp: (details) {
          setState(() {
            _selectedChoice = _selectedChoice == choice ? "" : choice;
          });
          HapticFeedback.mediumImpact;
          _onSelect(_selectedChoice);
        },
        child: Container(
          color: Color.fromARGB(1, 255, 255, 255),
          child: Row(
            spacing: _choiceWidth / 2,
            children: [
              AutoSizeText(choice,
                  style: comfortaaBold(_height * 0.71, color: _textColor),
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  minFontSize: 5),
              Container(
                  width: _choiceWidth,
                  height: _choiceWidth,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: _optionColor),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: choice == _selectedChoice
                              ? _selectColor
                              : Color.fromARGB(1, 255, 255, 255)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: _spacing,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _choices.map((choice) => getChoiceButtons(choice)).toList(),
    );
  }
}
