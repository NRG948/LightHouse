import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

class InputTextBox extends StatefulWidget {
  final double width;
  final double height;

  /// The maximum number of lines that can be input. Set to null for unbounded.
  final int? maxLines;

  /// The maximum number of characters that can be input.
  final int? maxLength;

  /// If the input is constrained to unformatted nonegative integers.
  /// 
  /// For example, ```948``` is allowed, but not ```-948```, ```9.48```, or ```9,480```.
  final bool isNumeric;

  /// If the input preview is hidden.
  final bool obscure;

  /// If the widget is allowing inputs.
  /// 
  /// If ```true```, the color of the widget will become [lockedColor]. Inputs will be retained upon lock.
  final bool isLocked;

  /// The color of the input field if [isLocked] is ```false```.
  final Color color;

  /// The color of the text.
  final Color textColor;

  /// The color of the input field if [isLocked] is ```true```.
  final Color lockedColor;

  /// The color of the hint text.
  final Color hintColor;

  /// The text displayed when the input field is empty.
  final String hintText;

  /// Called when the user changes the input field.
  final void Function(String text) onChanged;

  /// Creates a text input field.
  const InputTextBox({
    super.key,
    required this.width,
    required this.height,
    this.maxLines,
    this.maxLength,
    this.isNumeric = false,
    this.obscure = false,
    this.isLocked = false,
    this.color = Constants.pastelRed,
    this.textColor = Constants.pastelBrown,
    this.hintColor = Constants.pastelRedDark,
    this.lockedColor = Constants.pastelGray,
    this.hintText = "",
    this.onChanged = _noop,
  });

  static void _noop(String text) {}

  @override
  State<InputTextBox> createState() => _InputTextBoxState();
}

class _InputTextBoxState extends State<InputTextBox> {
  double get _width => widget.width;
  double get _height => widget.height;
  int? get _maxLines => widget.maxLines;
  int? get _maxLength => widget.maxLength;
  bool get _isNumeric => widget.isNumeric;
  bool get _obscure => widget.obscure;
  bool get _isLocked => widget.isLocked;
  Color get _color => widget.color;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;
  Color get _hintColor => widget.hintColor;
  String get _hintText => widget.hintText;
  void Function(String text) get _onChanged => widget.onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        height: _height,
        child: TextFormField(
          style: comfortaaBold(_height * 0.55,
              color: _isLocked ? Colors.black.withAlpha(100) : _textColor),
          decoration: InputDecoration(
              filled: true,
              fillColor: _isLocked ? _lockedColor : _color,
              enabled: !_isLocked,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_height * 0.2),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_height * 0.2),
                  borderSide: BorderSide(
                      color:
                          _isLocked ? Colors.black.withAlpha(100) : _hintColor,
                      width: _height * 0.05)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_height * 0.2),
                  borderSide: BorderSide.none),
              hintText: _hintText,
              hintStyle: comfortaaBold(_height * 0.55,
                  color: _isLocked ? Colors.black.withAlpha(100) : _hintColor),
              contentPadding: EdgeInsets.only(left: _height * 0.2)),
          scrollController: ScrollController(),
          maxLength: _maxLength,
          maxLines: _maxLines,
          inputFormatters:
              _isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
          obscureText: _obscure,
          cursorColor: _isLocked ? Colors.black.withAlpha(100) : _textColor,
          keyboardType: _isNumeric ? TextInputType.number : null,
          onChanged: _onChanged,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          onTap: () {
            HapticFeedback.lightImpact();
          }
        ));
  }
}
