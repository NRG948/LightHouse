import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';

class ShiftContainer extends StatefulWidget {
  final double height;
  final double? margin;
  final List<String> shifts;
  final Widget Function(int index) childBuilder;

  const ShiftContainer({
    super.key,
    required this.height,
    this.margin,
    required this.shifts,
    required this.childBuilder,
  });

  @override
  State<ShiftContainer> createState() => _ShiftContainerState();
}

class _ShiftContainerState extends State<ShiftContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double get _height => widget.height;
  double get _fontSize => 15;
  double get _margin => widget.margin ?? _height / 8;
  Widget Function(int index) get _childBuilder => widget.childBuilder;
  List<String> get _shifts => widget.shifts;

  int currentIndex = 0;
  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = List.generate(_shifts.length,
        (int x) => KeyedSubtree(key: ValueKey(x), child: _childBuilder(x)));
  }

  Widget buildSelector(int index) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          color: Color.fromARGB(1, 255, 255, 255),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(_margin / 2),
              decoration: BoxDecoration(
                  color: index == currentIndex ? Constants.pastelYellow : Color.fromARGB(1, 255, 255, 255),
                  borderRadius: BorderRadius.circular(_margin / 2)),
              child: AutoSizeText(
                _shifts[index],
                style: comfortaaBold(_fontSize,
                    color: index == currentIndex ? Constants.pastelWhite : Constants.pastelBrown,
                    customFontWeight: index == currentIndex ? FontWeight.w900 : FontWeight.bold),
              ),
            ),
          ),
        ),
        onTapUp: (details) {
          setState(() {
            currentIndex = index;
          });
          HapticFeedback.mediumImpact();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      spacing: _margin,
      children: [
        Center(
            child: Container(
          height: _height,
          decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(_margin),
          ),
          child: Row(
            children:
                List.generate(_shifts.length, (int x) => buildSelector(x)),
          ),
        )),
        IndexedStack(
          index: currentIndex,
          children: _children,
        ),
      ],
    );
  }
}
