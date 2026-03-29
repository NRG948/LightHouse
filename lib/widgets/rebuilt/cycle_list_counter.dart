import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';

class SelectorItem {
  final String id;
  String? value;
  SelectorItem({required this.id, this.value});
}

class CycleListCounter extends StatefulWidget {
  final String? regionId;
  final void Function(dynamic data) onUpdate;
  final bool isLocked;

  const CycleListCounter({
    super.key,
    required this.regionId,
    required this.onUpdate,
    this.isLocked = false,
  });

  @override
  State<CycleListCounter> createState() => _CycleListCounterState();
}

class _CycleListCounterState extends State<CycleListCounter> {
  late double _width;

  bool get _isLocked => widget.isLocked;
  void Function(dynamic data) get _onUpdate => widget.onUpdate;

  final List<SelectorItem> _selectorsData = [];
  final List<String> _options = ["1", "2", "3"];

  double get _selectorHeight => _width * 0.15;
  double get _removeIconSize => _width * 0.12;
  double get _addIconSize => _width * 0.2;
  double get _selectorSpacing => _width * 0.04;

  void _addSelector() {
    setState(() {
      HapticFeedback.mediumImpact();
      _selectorsData.add(SelectorItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        value: null,
      ));
    });
    _onUpdate(_selectorsData.map((e) => e.value).toList());
  }

  void _removeSelector(int index) {
    setState(() {
      _selectorsData.removeAt(index);
    });
    _onUpdate(_selectorsData.map((e) => e.value).toList());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _selectorsData.length,
                itemBuilder: (context, index) {
                  final item = _selectorsData[index];
                  return Row(
                    key: ValueKey(item.id),
                    children: [
                      SizedBox(
                        height: _selectorHeight,
                        child: SingleChoiceSelector(
                          initialValue: item.value,
                          selectColor: context.colors.container,
                          optionColor: context.colors.accent2,
                          textColor: context.colors.containerText,
                          lockedColor: context.colors.locked,
                          isLocked: _isLocked,
                          choices: _options,
                          spacing: _selectorSpacing,
                          onSelect: (choice) {
                            setState(() {
                              item.value = choice;
                            });
                            _onUpdate(_selectorsData.map((e) => e.value).toList());
                          },
                        ),
                      ),
                      AbsorbPointer(
                        absorbing: _isLocked,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle_rounded,
                            color: _isLocked
                                ? context.colors.locked
                                : context.colors.delete,
                          ),
                          iconSize: _removeIconSize,
                          onPressed: () => _removeSelector(index),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            AbsorbPointer(
              absorbing: _isLocked,
              child: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: _addIconSize,
                  color: _isLocked ? context.colors.locked : context.colors.accent2,
                ),
                onPressed: _addSelector,
              ),
            ),
          ],
        );
      },
    );
  }
}