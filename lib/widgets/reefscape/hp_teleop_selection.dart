import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/counter.dart';

class HPTeleopSelection extends StatefulWidget {
  final double height;
  final double width;
  const HPTeleopSelection(
      {super.key, required this.height, required this.width});

  @override
  State<HPTeleopSelection> createState() => _HPTeleopSelectionState();
}

class _HPTeleopSelectionState extends State<HPTeleopSelection> with AutomaticKeepAliveClientMixin {
  double get _height => widget.height;
  double get _width => widget.width;

  Queue<String> history = Queue();
  Map<String, GlobalKey<CounterState>> counters = {};

  @override
  void initState() {
    super.initState();
    counters.addAll({
      "redScore": GlobalKey<CounterState>(),
      "blueScore": GlobalKey<CounterState>(),
      "redMiss": GlobalKey<CounterState>(),
      "blueMiss": GlobalKey<CounterState>(),
      "redNetAlgae": GlobalKey<CounterState>(),
      "blueNetAlgae": GlobalKey<CounterState>(),
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    void undo() {
      if (history.isNotEmpty) {
        counters[history.removeLast()]!.currentState?.decrement();
      }
    }

    return Container(
        height: _height - 20,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius:
                BorderRadius.all(Radius.circular(Constants.borderRadius))),
        child: Column(
          children: [
            Container(
              width: _width - 20,
              height: _height / 6 - 20,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Constants.pastelGreen,
                  borderRadius: BorderRadius.all(
                      Radius.circular(Constants.borderRadius))),
              child: Stack(
                children: [
                  Center(
                    child: AutoSizeText(
                      "Undo",
                      style: comfortaaBold(40),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      undo();
                      HapticFeedback.heavyImpact();
                    },
                  )
                ],
              ),
            ),
            Row(children: [
              Column(
                children: [
                  Counter(
                    key: counters["redScore"],
                    title: "Red Score",
                    jsonKey: "redScore",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelRed,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("redScore"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["redMiss"],
                    title: "Red Miss",
                    jsonKey: "redMiss",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelRedMuted,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("redMiss"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["redNetAlgae"],
                    title: "Red Algae in Net",
                    jsonKey: "redNetAlgae",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelReddishBrown,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("redNetAlgae"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Counter(
                    key: counters["blueScore"],
                    title: "Blue Score",
                    jsonKey: "blueScore",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelBlue,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("blueScore"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["blueMiss"],
                    title: "Blue Miss",
                    jsonKey: "blueMiss",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelBlueAgain,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("blueMiss"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["blueNetAlgae"],
                    title: "Blue Algae in Net",
                    jsonKey: "blueNetAlgae",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelBlueMuted,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("blueNetAlgae"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                ],
              )
            ]),
          ],
        ));
  }
  
  @override
  bool get wantKeepAlive => true;
}
