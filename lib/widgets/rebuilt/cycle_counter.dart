import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/dropdown.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';

class Cycle {
  String? accuracy;
  String? capacity;
  int index;

  Cycle({this.accuracy, this.capacity, required this.index});
}

class CycleCounter extends StatefulWidget {
  final double? margin;
  final Color color;
  final Color backgroundColor;
  final Color textColor;
  final Color lockedColor;
  final bool isCompact;

  const CycleCounter({
    super.key,
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

  final List<String> accuracyMetrics = [
    "1",
    "2",
    "3",
    "4",
    "5"
  ]; // <<50%, ~50%, ~70%, ~85%, >95%
  final List<String> capcityMetrics = [
    "Partial",
    "Most",
    "Full"
  ]; // <50%, 50%-95%, >95%

  final List<Cycle> _cycles = [];

  int lastIndex = -1;
  int currentIndex = -1;

  String? selectedAccuracy;
  String? selectedCapacity;

  bool reinitializeDropdown = false;
  bool reinitializeMultiselect = false;

  void _loadCycle(int index) {
    if (index == -1) return;

    selectedAccuracy = _cycles[index].accuracy;
    selectedCapacity = _cycles[index].capacity;
  }

  Widget _getBorder({required Widget child}) {
    if (_isCompact) {
      return Container(child: child);
    } else {
      return Container(
        padding: EdgeInsets.all(_margin / 2),
        decoration: BoxDecoration(
          color: lastIndex == -1 ? _lockedColor : _color,
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

  Widget _getLabel({required String text}) {
    return Expanded(
      flex: _isCompact ? 1 : 2,
      child: AutoSizeText(
        text,
        style: comfortaaBold(_height / 13, color: _textColor),
      ),
    );
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
                borderRadius: BorderRadius.circular(_margin)),
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
                              color: lastIndex == -1 ? _lockedColor : _color,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                onPressed: () {
                                  if (lastIndex == -1) return;
                                  setState(() {
                                    reinitializeDropdown = true;
                                    reinitializeMultiselect = true;
                                    _cycles.removeAt(currentIndex);
                                    lastIndex--;
                                    currentIndex = currentIndex == 0
                                        ? lastIndex
                                        : currentIndex - 1;
                                    _loadCycle(lastIndex);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                iconSize: _buttonSize * 0.45,
                                color: _backgroundColor,
                                icon: const Icon(Icons.delete_rounded)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: _buttonSize / 10),
                          child: CustomDropdown(
                            options: List.generate(_cycles.length, (i) => i)
                                .map((int x) => x.toString())
                                .toList(),
                            reinitializeOnBuild: reinitializeDropdown,
                            isLocked: lastIndex == -1,
                            initialValue:
                                lastIndex == -1 ? null : lastIndex.toString(),
                            onChanged: (value) {
                              setState(() {
                                reinitializeDropdown = false;
                                reinitializeMultiselect = true;
                                currentIndex = int.parse(value ?? "0");
                                _loadCycle(currentIndex);
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
                            ),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    reinitializeDropdown = true;
                                    reinitializeMultiselect = true;
                                    lastIndex++;
                                    currentIndex = lastIndex;
                                    _cycles.add(Cycle(
                                        index: lastIndex,
                                        capacity: capcityMetrics.last));
                                    _loadCycle(lastIndex);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                iconSize: _buttonSize * 0.45,
                                color: _backgroundColor,
                                icon: const Icon(Icons.add_rounded)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: _isCompact ? 2 : 3,
                    child: _getBorder(
                      child: Column(
                        spacing: _isCompact ? 0 : _margin / 2,
                        children: [
                          _getLabel(text: "Accuracy"),
                          Expanded(
                            flex: 2,
                            child: SingleChoiceSelector(
                              choices: accuracyMetrics,
                              isLocked: lastIndex == -1,
                              spacing: _margin,
                              selectColor: _backgroundColor,
                              optionColor: _color,
                              initialValue:
                                  lastIndex == -1 ? null : selectedAccuracy,
                              reinitializeOnBuild: reinitializeMultiselect,
                              lockedColor: _lockedColor,
                              onSelect: (choice) {
                                if (currentIndex == -1) return;
                                _cycles[currentIndex].accuracy = choice;
                              },
                            ),
                          ),
                          _getLabel(text: "Capacity"),
                          Expanded(
                            flex: 2,
                            child: SingleChoiceSelector(
                              choices: capcityMetrics,
                              isLocked: lastIndex == -1,
                              spacing: _margin,
                              selectColor: _backgroundColor,
                              optionColor: _color,
                              initialValue:
                                  lastIndex == -1 ? null : selectedCapacity,
                              reinitializeOnBuild: reinitializeMultiselect,
                              lockedColor: _lockedColor,
                              onSelect: (choice) {
                                if (currentIndex == -1) return;
                                _cycles[currentIndex].capacity = choice;
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
