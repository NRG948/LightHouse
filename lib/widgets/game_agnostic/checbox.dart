import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

class CustomCheckbox extends StatefulWidget {
  final double width;
  final double height;

  final String title;
  final Function(bool value) onToggle;
  final bool initialValue;

  final Color selectColor;
  final Color textColor;
  final Color optionColor;

  const CustomCheckbox(
      {super.key,
      required this.height,
      required this.width,
      this.title = "",
      this.onToggle = _noop,
      this.initialValue = false,
      this.selectColor = Colors.black,
      this.textColor = Colors.black,
      this.optionColor = Colors.white});

  static void _noop(bool value) {}

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  double get _width => widget.width;
  double get _height => widget.height;

  String get _title => widget.title;
  Function(bool value) get _onToggle => widget.onToggle;
  bool get _initialValue => widget.initialValue;

  Color get _selectColor => widget.selectColor;
  Color get _optionColor => widget.optionColor;
  Color get _textColor => widget.textColor;

  bool currentValue = false;

  @override
  void initState() {
    super.initState();
    currentValue = _initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            spacing: _height / 2,
            children: [
              Container(
                width: _height * 0.8,
                height: _height * 0.8,
                decoration: BoxDecoration(
                  color: _optionColor,
                  borderRadius: BorderRadius.circular(_height * 0.2),
                ),
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: currentValue ? _selectColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(_height * 0.12),
                      ),
                    )),
              ),
              AutoSizeText(
                _title,
                style: comfortaaBold(_height * 0.7, color: _textColor),
                maxLines: 1,
                minFontSize: 9,
              )
            ],
          )),
    );
  }
}
