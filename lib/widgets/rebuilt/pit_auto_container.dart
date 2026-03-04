import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class PitAutoContainer extends StatefulWidget {
  final double height;
  final String jsonKey;
  final Widget Function(int index) childBuilder;

  const PitAutoContainer({
    super.key,
    required this.height,
    required this.jsonKey,
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
        (int x) => KeyedSubtree(key: ValueKey(x), child: widget.childBuilder(x)),
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
          (int x) => KeyedSubtree(key: ValueKey(x), child: widget.childBuilder(x)),
        );
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
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          child: DropdownButton<int>(
            value: _selectedOption,
            isExpanded: true,
            items: [
              ...List.generate(_optionCount, (i) => DropdownMenuItem(
                    value: i,
                    child: Text('${i + 1}'),
                  )),
              const DropdownMenuItem(
                value: -1,
                child: Text('Add'),
              ),
              const DropdownMenuItem(
                value: -2,
                child: Text('Remove'),
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
