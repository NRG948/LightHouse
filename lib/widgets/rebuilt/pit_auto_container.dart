import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/themes.dart';

class PitAutoContainer extends StatefulWidget {
  final double height;
  final String listJsonKey;
  final Widget Function(int index, Map<String, dynamic> dataMap) childBuilder;

  const PitAutoContainer({
    super.key,
    required this.height,
    required this.listJsonKey,
    required this.childBuilder,
  });

  @override
  State<PitAutoContainer> createState() => _PitAutoContainerState();
}

class _PitAutoContainerState extends State<PitAutoContainer> {
  int _optionCount = 1;
  int _selectedOption = 0;
  late List<Widget> _children;
  late List<Map<String, dynamic>> _autoData;

  double get _margin => 10;

  void _addOption() {
    setState(() {
      _optionCount++;
      _selectedOption = _optionCount - 1;
      _autoData.add({});
      _rebuildChildren();
    });
    DataEntry.exportData[widget.listJsonKey] = _autoData;
  }

  void _removeOption() {
    if (_optionCount > 1) {
      setState(() {
        _optionCount--;
        _selectedOption = _optionCount - 1;
        _autoData.removeLast();
        _rebuildChildren();
      });
      DataEntry.exportData[widget.listJsonKey] = _autoData;
    }
  }

  void _rebuildChildren() {
    _children = List.generate(
      _optionCount,
      (int x) => KeyedSubtree(
        key: ValueKey(x),
        child: widget.childBuilder(x, _autoData[x]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _autoData = [{}];
    _rebuildChildren();
  }

  @override
  Widget build(BuildContext context) {
    DataEntry.exportData[widget.listJsonKey] = _autoData;
    return Column(
      spacing: _margin,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          decoration: BoxDecoration(
            color: context.colors.container,
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          child: DropdownButton<int>(
            value: _selectedOption,
            dropdownColor: context.colors.container,
            isExpanded: true,
            items: [
              ...List.generate(
                  _optionCount,
                  (i) => DropdownMenuItem(
                        value: i,
                        child: Text('${i + 1}',
                            style: comfortaaBold(17,
                                color: context.colors.containerText)),
                      )),
              DropdownMenuItem(
                value: -1,
                child: Text('Add',
                    style:
                        comfortaaBold(17, color: context.colors.containerText)),
              ),
              DropdownMenuItem(
                value: -2,
                child: Text('Remove Last',
                    style:
                        comfortaaBold(17, color: context.colors.containerText)),
              ),
            ],
            onChanged: (value) {
              if (value == -1) {
                _addOption();
              } else if (value == -2) {
                _removeOption();
              } else if (value != null) {
                setState(() {
                  _selectedOption = value;
                });
              }
            },
          ),
        ),
        IndexedStack(
          index: _selectedOption,
          children: _children,
        ),
      ],
    );
  }
}
