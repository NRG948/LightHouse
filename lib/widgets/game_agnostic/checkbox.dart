import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

class CustomCheckbox extends StatefulWidget {
  /// The text displayed to the right of the checkbox.
  final String title;

  /// Called when the checkbox is toggled.
  final Function(bool value) onToggle;

  /// The initial value of the checkbox.
  ///
  /// The checkbox is checked if this value is ```true```, and not if this value is ```false```.
  final bool initialValue;

  /// The color of the select icon when the checkbox is checked.
  final Color selectColor;

  /// The color of the [title].
  final Color textColor;

  /// The color of the checkbox.
  final Color optionColor;

  /// The color of the checkbox when [isLocked] is ```true```.
  final Color lockedColor;

  /// If the checkbox stops accepting inputs.
  final bool isLocked;

  /// Creates a checkbox that registers clicks on the checkbox and the title text.
  const CustomCheckbox(
      {super.key,
      this.title = "",
      this.onToggle = _noop,
      this.initialValue = false,
      this.selectColor = Colors.black,
      this.textColor = Colors.black,
      this.optionColor = Colors.white,
      this.lockedColor = Colors.grey,
      this.isLocked = false,});

  static void _noop(bool value) {}

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late double _width;
  late double _height;

  String get _title => widget.title;
  Function(bool value) get _onToggle => widget.onToggle;
  bool get _initialValue => widget.initialValue;

  Color get _selectColor => widget.selectColor;
  Color get _optionColor => widget.optionColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;

  bool get _isLocked => widget.isLocked;
  bool currentValue = false;

  @override
  void initState() {
    super.initState();
    currentValue = _initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        _height = constraints.maxHeight;
        return AbsorbPointer(
          absorbing: _isLocked,
          child: GestureDetector(
            onTapUp: (details) {
              setState(() {
                currentValue = !currentValue;
                HapticFeedback.mediumImpact();
              });
              _onToggle(currentValue);
            },
            child: Container(
              width: _width,
              height: _height,
              color: Color.fromARGB(1, 255, 255, 255),
              child: Row(
                spacing: _height * 0.3,
                children: [
                  Container(
                    width: _height * 0.6,
                    height: _height * 0.6,
                    decoration: BoxDecoration(
                      color: _isLocked ? _lockedColor : _optionColor,
                      borderRadius: BorderRadius.circular(_height * 0.2),
                    ),
                    child: FractionallySizedBox(
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                currentValue ? _selectColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(_height * 0.12),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: _width - _height,
                    child: AutoSizeText(
                      _title,
                      style: comfortaaBold(_height * 0.7, color: _isLocked ? Colors.black.withAlpha(100) : _textColor),
                      maxLines: 1,
                      minFontSize: 9,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
