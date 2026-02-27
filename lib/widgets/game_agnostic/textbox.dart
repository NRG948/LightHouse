import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/filemgr.dart';

class InputTextBox extends StatefulWidget {
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

  /// Font of the text written.
  ///
  /// Defaults to ```0.55``` of the height, divided by [maxLines] if it isn't null.
  final double? fontSize;

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

  /// The key which stores the value of this widget in [DataEntry]
  final String? jsonKey;

  /// The key from which the autofill value is taken from [configData]
  final String? autofillKey;

  /// Creates a text input field.
  const InputTextBox({
    super.key,
    this.maxLines,
    this.maxLength,
    this.isNumeric = false,
    this.obscure = false,
    this.isLocked = false,
    this.fontSize,
    this.color = Constants.pastelRed,
    this.textColor = Constants.pastelBrown,
    this.hintColor = Constants.pastelRedDark,
    this.lockedColor = Constants.pastelGray,
    this.hintText = "",
    this.onChanged = _noop,
    this.jsonKey,
    this.autofillKey,
  });

  static void _noop(String text) {}

  @override
  State<InputTextBox> createState() => _InputTextBoxState();
}

class _InputTextBoxState extends State<InputTextBox>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // ignore: unused_field
  late double _width;
  late double _height;
  int? get _maxLines => widget.maxLines;
  int? get _maxLength => widget.maxLength;
  bool get _isNumeric => widget.isNumeric;
  bool get _obscure => widget.obscure;
  bool get _isLocked => widget.isLocked;
  double get _fontSize => widget.fontSize ?? _height * 0.55 / (_maxLines ?? 1);
  Color get _color => widget.color;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;
  Color get _hintColor => widget.hintColor;
  String get _hintText => widget.hintText;
  String? get _jsonKey => widget.jsonKey;
  String? get _autofillKey => widget.autofillKey;
  String _value = "";
  void Function(String text) get _onChanged => widget.onChanged;

  @override
  void initState() {
    super.initState();
    if (_autofillKey != null && configData.containsKey(_autofillKey)) {
      _value = configData[_autofillKey!]!;
      _serializeData();
    }
  }

  void _serializeData() {
    if (_jsonKey != null) {
      DataEntry.exportData[_jsonKey!] = _value;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        _height = constraints.maxHeight;
        return TextFormField(
            style: comfortaaBold(_fontSize,
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
                        color: _isLocked
                            ? Colors.black.withAlpha(100)
                            : _hintColor,
                        width: _height * 0.05)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_height * 0.2),
                    borderSide: BorderSide.none),
                hintText: _hintText,
                hintStyle: comfortaaBold(_fontSize,
                    color:
                        _isLocked ? Colors.black.withAlpha(100) : _hintColor),
                contentPadding: EdgeInsets.only(
                    left: _height * 0.2,
                    top: _height * 0.1,
                    bottom: _height * 0.1,
                    right: _height * 0.1)),
            scrollController: ScrollController(),
            maxLength: _maxLength,
            maxLines: _maxLines,
            initialValue:
                _autofillKey == null ? null : configData[_autofillKey],
            inputFormatters:
                _isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
            obscureText: _obscure,
            cursorColor: _isLocked ? Colors.black.withAlpha(100) : _textColor,
            keyboardType: _isNumeric ? TextInputType.number : null,
            onChanged: (value) {
              _value = value;
              _serializeData();
              _onChanged(value);
            },
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onTap: () {
              HapticFeedback.lightImpact();
            });
      },
    );
  }
}
