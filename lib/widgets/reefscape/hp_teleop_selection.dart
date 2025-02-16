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

class _HPTeleopSelectionState extends State<HPTeleopSelection> {
  double get _height => widget.height;
  double get _width => widget.width;

  Queue<String> history = Queue();
  Map<String, GlobalKey<CounterState>> counters = {};

  @override
  Widget build(BuildContext context) {
    counters.addAll({
      "redScore": GlobalKey<CounterState>(),
      "blueScore": GlobalKey<CounterState>(),
      "redMiss": GlobalKey<CounterState>(),
      "blueMiss": GlobalKey<CounterState>(),
      "redAlgaeNet": GlobalKey<CounterState>(),
      "blueAlgaeNet": GlobalKey<CounterState>(),
    });

    void undo() {
      if (history.isNotEmpty) {
        counters[history.removeLast()]!.currentState?.decrement();
      }
    }

    return Container(
        height: _height,
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
                  color: Constants.pastelRed,
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
                    color: Constants.pastelGreen,
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
                    color: Constants.pastelGreen,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("redMiss"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["redNet"],
                    title: "Remove",
                    jsonKey: "algaeRemove",
                    height: _height / 4,
                    width: _width / 2,
                    color: Constants.pastelGreen,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("algaeRemove"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Counter(
                    key: counters["coralScoredL4"],
                    title: "L4",
                    jsonKey: "coralScoredL4",
                    height: _height / 5,
                    width: _width / 2,
                    color: Constants.pastelYellow,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("coralScoredL4"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["coralScoredL3"],
                    title: "L3",
                    jsonKey: "coralScoredL3",
                    height: _height / 5,
                    width: _width / 2,
                    color: Constants.pastelYellow,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("coralScoredL3"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                  Counter(
                    key: counters["coralScoredL2"],
                    title: "L2",
                    jsonKey: "coralScoredL2",
                    height: _height / 5,
                    width: _width / 2,
                    color: Constants.pastelYellow,
                    boxColor: Constants.pastelWhite,
                    onIncrement: () => {
                      history.addLast("coralScoredL2"),
                      HapticFeedback.heavyImpact()
                    },
                  ),
                ],
              )
            ]),
          ],
        ));
  }
}
