import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/widgets/game_agnostic/dropdown.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';

class Cycle {
  String? accuracy;
  String? capacity;
  int? duration;
  int index;

  Cycle({this.accuracy, this.capacity, this.duration, required this.index});
}

class CycleCounter extends StatefulWidget {
  final double? margin;
  final String jsonKey;
  final Color color;
  final Color backgroundColor;
  final Color textColor;
  final Color lockedColor;
  final bool isCompact;

  const CycleCounter({
    super.key,
    required this.jsonKey,
    this.margin,
    this.color = Constants.pastelRed,
    this.backgroundColor = Constants.pastelWhite,
    this.textColor = Constants.pastelBrown,
    this.lockedColor = Constants.pastelGray,
    this.isCompact = false,
  });

  @override
  State<CycleCounter> createState() => _CycleCounterState();
}

class _CycleCounterState extends State<CycleCounter> {
  late double _width;

  double get _height => _width * (_isCompact ? 0.55 : 0.78);
  double get _buttonSize => _width * 0.25;
  double get _margin => widget.margin ?? _width / 25;
  Color get _color => widget.color;
  Color get _backgroundColor => widget.backgroundColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;
  bool get _isCompact => widget.isCompact;
  double get _fontSize => _height / 13;
  String get _jsonKey => widget.jsonKey;

  final List<String> accuracyMetrics = ["1", "2", "3", "4", "5"];
  final List<String> capcityMetrics = ["33%", "66%", "100%"];

  final List<Cycle> _cycles = [];
  final Stopwatch stopwatch = Stopwatch();

  int _currentIndex = -1;
  bool _isTimerActive = false;

  void _serializeData() {
    List<Map<String, dynamic>> data = List.empty(growable: true);
    for (Cycle cycle in _cycles) {
      Map<String, dynamic> cycleData = {
        "accuacy": cycle.accuracy ?? "none",
        "capacity": cycle.capacity ?? "none",
        "duration": cycle.duration ?? 0,
      };

      data.add(cycleData);
    }
    DataEntry.exportData[_jsonKey] = data;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _serializeData();
  }

  Widget _getBorder({required Widget child}) {
    if (_isCompact) {
      return child;
    } else {
      return Container(
        padding: EdgeInsets.all(_margin / 2),
        decoration: BoxDecoration(
          color: _cycles.isEmpty ? _lockedColor : _color,
          borderRadius: BorderRadius.circular(_margin),
        ),
        child: Container(
          padding: EdgeInsets.all(_margin),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(_margin / sqrt(2)),
          ),
          child: child,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;

        return Center(
          child: Container(
            width: _width,
            height: _height,
            padding: EdgeInsets.all(_margin),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(_margin),
            ),
            child: Column(
              spacing: _margin,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    spacing: _isCompact ? 0 : _margin,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            width: _buttonSize,
                            height: _buttonSize,
                            decoration: BoxDecoration(
                              color: _cycles.isEmpty || _isTimerActive
                                  ? _lockedColor
                                  : _color,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (_cycles.isEmpty || _isTimerActive) return;

                                setState(() {
                                  _cycles.removeAt(_currentIndex);

                                  if (_cycles.isEmpty) {
                                    _currentIndex = -1;
                                  } else if (_currentIndex >= _cycles.length) {
                                    _currentIndex = _cycles.length - 1;
                                  }
                                });
                              },
                              padding: EdgeInsets.zero,
                              iconSize: _buttonSize * 0.45,
                              color: _backgroundColor,
                              icon: const Icon(Icons.delete_rounded),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: _buttonSize / 10),
                          child: CustomDropdown(
                            key: ValueKey("${_cycles.length}-$_currentIndex"),
                            options: List.generate(
                              _cycles.length,
                              (i) => i.toString(),
                            ),
                            isLocked: _cycles.isEmpty || _isTimerActive,
                            initialValue: _cycles.isEmpty
                                ? null
                                : _currentIndex.toString(),
                            onChanged: (value) {
                              setState(() {
                                _currentIndex = int.parse(value ?? "0");
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            width: _buttonSize,
                            height: _buttonSize,
                            decoration: BoxDecoration(
                              color: _color,
                              shape: BoxShape.circle,
                              border: _isTimerActive
                                  ? Border.all(
                                      width: _buttonSize * 0.05,
                                      color: Constants.pastelGreen)
                                  : null,
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_isTimerActive) {
                                    stopwatch.stop();
                                    _cycles.last.duration =
                                        stopwatch.elapsedMilliseconds;
                                    stopwatch.reset();
                                  } else {
                                    final newIndex = _cycles.length;

                                    _cycles.add(
                                      Cycle(
                                        index: newIndex,
                                        capacity: capcityMetrics.last,
                                      ),
                                    );

                                    _currentIndex = newIndex;
                                    stopwatch.start();
                                  }
                                  _isTimerActive = !_isTimerActive;
                                });
                              },
                              padding: EdgeInsets.zero,
                              iconSize: _buttonSize * 0.45,
                              color: _backgroundColor,
                              icon: _isTimerActive
                                  ? const Icon(Icons.stop_rounded)
                                  : const Icon(Icons.add_rounded),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: _isCompact ? 2 : 3,
                  child: _getBorder(
                    child: IndexedStack(
                      index: _cycles.isEmpty ? 0 : _currentIndex,
                      children: _cycles.isEmpty
                          ? [
                              CycleView(
                                  key: const ValueKey("locked"),
                                  cycle: Cycle(index: -1),
                                  isLocked: true,
                                  accuracyMetrics: accuracyMetrics,
                                  capacityMetrics: capcityMetrics,
                                  margin: _margin,
                                  color: _color,
                                  backgroundColor: _backgroundColor,
                                  textColor: _textColor,
                                  lockedColor: _lockedColor,
                                  isCompact: _isCompact,
                                  fontSize: _fontSize,
                                  parentSetState: setState)
                            ]
                          : _cycles.map((cycle) {
                              return CycleView(
                                key: ValueKey(cycle.index),
                                cycle: cycle,
                                isLocked: false,
                                accuracyMetrics: accuracyMetrics,
                                capacityMetrics: capcityMetrics,
                                margin: _margin,
                                color: _color,
                                backgroundColor: _backgroundColor,
                                textColor: _textColor,
                                lockedColor: _lockedColor,
                                isCompact: _isCompact,
                                fontSize: _fontSize,
                                parentSetState: setState,
                              );
                            }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CycleView extends StatefulWidget {
  final Cycle cycle;
  final bool isLocked;
  final List<String> accuracyMetrics;
  final List<String> capacityMetrics;
  final double margin;
  final Color color;
  final Color backgroundColor;
  final Color textColor;
  final Color lockedColor;
  final bool isCompact;
  final double fontSize;

  /// used to update [DataEntry.exportData], as the code to do that
  /// is in the parent [setState()] function
  final Function(VoidCallback fn) parentSetState;

  const CycleView({
    super.key,
    required this.cycle,
    required this.isLocked,
    required this.accuracyMetrics,
    required this.capacityMetrics,
    required this.margin,
    required this.color,
    required this.backgroundColor,
    required this.textColor,
    required this.lockedColor,
    required this.isCompact,
    required this.fontSize,
    required this.parentSetState,
  });

  @override
  State<CycleView> createState() => _CycleViewState();
}

class _CycleViewState extends State<CycleView> {
  Cycle get _cycle => widget.cycle;
  bool get _isLocked => widget.isLocked;
  List<String> get _accuracyMetrics => widget.accuracyMetrics;
  List<String> get _capacityMetrics => widget.capacityMetrics;
  double get _margin => widget.margin;
  Color get _color => widget.color;
  Color get _backgroundColor => widget.backgroundColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;
  bool get _isCompact => widget.isCompact;
  double get _fontSize => widget.fontSize;
  Function(VoidCallback fn) get _parentSetState => widget.parentSetState;

  String? selectedAccuracy;
  String? selectedCapacity;

  Widget _getLabel({required String text}) {
    return Expanded(
      flex: _isCompact ? 1 : 2,
      child: AutoSizeText(
        text,
        style: comfortaaBold(_fontSize, color: _textColor),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedAccuracy = _cycle.accuracy;
    selectedCapacity = _cycle.capacity;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _parentSetState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: _isCompact ? 0 : _margin / 2,
      children: [
        _getLabel(text: "Accuracy"),
        Expanded(
          flex: 2,
          child: SingleChoiceSelector(
            choices: _accuracyMetrics,
            initialValue: selectedAccuracy,
            isLocked: _isLocked,
            spacing: _margin,
            selectColor: _backgroundColor,
            optionColor: _color,
            lockedColor: _lockedColor,
            textColor: _textColor,
            onSelect: (choice) {
              setState(() {
                selectedAccuracy = choice;
                _cycle.accuracy = choice;
              });
            },
          ),
        ),
        _getLabel(text: "Capacity"),
        Expanded(
          flex: 2,
          child: SingleChoiceSelector(
            choices: _capacityMetrics,
            initialValue: selectedCapacity,
            isLocked: _isLocked,
            spacing: _margin,
            selectColor: _backgroundColor,
            optionColor: _color,
            lockedColor: _lockedColor,
            textColor: _textColor,
            onSelect: (choice) {
              setState(() {
                selectedCapacity = choice;
                _cycle.capacity = choice;
              });
            },
          ),
        ),
      ],
    );
  }
}
