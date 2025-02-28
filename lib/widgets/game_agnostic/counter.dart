import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class Counter extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  final Color color;
  final Color boxColor;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  const Counter(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      required this.color,
      required this.boxColor,
      this.onIncrement,
      this.onDecrement});

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> with AutomaticKeepAliveClientMixin {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  double get _height => widget.height;
  double get _width => widget.width;
  Color get _color => widget.color;
  Color get _boxColor => widget.boxColor;
  VoidCallback? get _onIncrement => widget.onIncrement;
  VoidCallback? get _onDecrement => widget.onDecrement;
  late int _counter;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: _boxColor,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              spacing: 10,
              children: [
                SizedBox(
                height: _height * 0.3,
                child: AutoSizeText(_title, style: comfortaaBold(30, color: Constants.pastelReddishBrown))),
                Center(
                  child: Container(
                    height: _height * 0.4,
                    width: _width * 0.9,
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(Constants.borderRadius)
                    ),
                    child: AutoSizeText("$_counter", style: comfortaaBold(40, color: Constants.pastelWhite), textAlign: TextAlign.center,)
                  )
                )
              ],
            ),
            GestureDetector(
              onTap: increment,
              onLongPress: decrement,
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _counter = 0;
    DataEntry.exportData[_key] = 0;
  }

  void decrement() {
    if (_onDecrement != null) _onDecrement!();
    setState(() {
      if (_counter > 0) {
        _counter--;
        updateState();
      }
    });
  }

  void increment() {
    if (_onIncrement != null) _onIncrement!();
    setState(() {
      _counter++;
      updateState();
    });
  }

  void updateState() {
    DataEntry.exportData[_key] = _counter;
  }
  
  @override
  bool get wantKeepAlive => true;
}