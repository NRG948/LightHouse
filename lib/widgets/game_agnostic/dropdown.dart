import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String? initialValue;
  final String hintText;

  final Color color;
  final Color hintColor;
  final Color textColor;
  final Color lockedColor;

  final bool isLocked;

  final double fontSize;

  /// If ```true```, the selected value will be set to the initial value when this widget is rebuilt externally.
  final bool reinitializeOnBuild;

  final void Function(String? value) onChanged;

  const CustomDropdown(
      {super.key,
      required this.options,
      this.initialValue,
      this.hintText = "",
      this.color = Constants.pastelRed,
      this.textColor = Constants.pastelBrown,
      this.lockedColor = Constants.pastelGray,
      this.hintColor = Constants.pastelRedDark,
      this.onChanged = _noop,
      this.isLocked = false,
      this.fontSize = 17,
      this.reinitializeOnBuild = false});

  static void _noop(String? value) {}

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late double _width;
  late double _height;

  List<String> get _options => widget.options;
  String get _hintText => widget.hintText;
  String? get _initialValue => widget.initialValue;
  Color get _color => widget.color;
  Color get _hintColor => widget.hintColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;
  bool get _isLocked => widget.isLocked;
  double get _fontSize => widget.fontSize;
  bool get _reinitializeOnBuild => widget.reinitializeOnBuild;
  Function(String? value) get _onChanged => widget.onChanged;

  String? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = _initialValue;
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_reinitializeOnBuild) _currentValue = _initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        _height = constraints.maxHeight;
        return AbsorbPointer(
          absorbing: _isLocked,
          child: Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
                color: _isLocked ? _lockedColor : _color,
                borderRadius: BorderRadius.circular(_height * 0.2)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  focusColor: _isLocked ? _lockedColor : _color,
                  dropdownColor: _isLocked ? _lockedColor : _color,
                  borderRadius: BorderRadius.circular(_height * 0.2),
                  padding: EdgeInsets.only(left: _height * 0.2),
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      color: Constants.pastelWhite),
                  iconSize: _height,
                  style: comfortaaBold(_fontSize, color: _isLocked ? Colors.black.withAlpha(100) : _textColor),
                  hint: AutoSizeText(_hintText,
                      style: comfortaaBold(_fontSize, color: _isLocked ? Colors.black.withAlpha(100) : _hintColor)),
                  items: _options
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: AutoSizeText(value,
                                style:
                                    comfortaaBold(_fontSize, color: _isLocked ? Colors.black.withAlpha(100) : _textColor)),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _currentValue = value;
                    });
                    _onChanged(value);
                  },
                  value: _currentValue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
