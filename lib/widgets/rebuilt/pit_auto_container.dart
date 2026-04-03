import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/themes.dart';

class PitAutoContainer extends StatefulWidget {
  final double height;
  final List<String> jsonKeys;
  final Widget Function(int index) childBuilder;

  const PitAutoContainer({
    super.key,
    required this.height,
    required this.jsonKeys,
    required this.childBuilder,
  });

  @override
  State<PitAutoContainer> createState() => _PitAutoContainerState();
}

class _PitAutoContainerState extends State<PitAutoContainer> {
  int _optionCount = 1;
  int _selectedOption = 0;
  late List<Widget> _children;

  double get _margin => 10;

  void _addOption() {
    setState(() {
      _optionCount++;
      _selectedOption = _optionCount - 1;
      _children = List.generate(
        _optionCount,
        (int x) =>
            KeyedSubtree(key: ValueKey(x), child: widget.childBuilder(x)),
      );
    });
  }

  void _removeOption() {
    if (_optionCount > 1) {
      setState(() {
        _optionCount--;
        _selectedOption = _optionCount - 1;
        _children = List.generate(
          _optionCount,
          (int x) =>
              KeyedSubtree(key: ValueKey(x), child: widget.childBuilder(x)),
        );
        for (String jsonKey in widget.jsonKeys) {
          DataEntry.exportData.remove("$jsonKey${_optionCount + 1}");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _children = List.generate(
      _optionCount,
      (int x) => KeyedSubtree(key: ValueKey(x), child: widget.childBuilder(x)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
