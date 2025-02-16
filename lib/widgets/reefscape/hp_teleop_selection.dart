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
      "coralScoredL1": GlobalKey<CounterState>(),
      "coralScoredL2": GlobalKey<CounterState>(),
      "coralScoredL3": GlobalKey<CounterState>(),
      "coralScoredL4": GlobalKey<CounterState>(),
      "algaeRemove": GlobalKey<CounterState>(),
      "algaeScoreProcessor": GlobalKey<CounterState>(),
      "algaeScoreNet": GlobalKey<CounterState>(),
      "coralPickups": GlobalKey<CounterState>(),
      "algaePickups": GlobalKey<CounterState>()
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
        child: Row(children: [
          Column(
            children: [
              Container(
                width: _width / 2 - 20,
                height: _height / 5 - 20,
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
              Counter(
                key: counters["algaeScoreNet"],
                title: "Net",
                jsonKey: "algaeScoreNet",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelGreen,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("algaeScoreNet"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["algaeScoreProcessor"],
                title: "Processor",
                jsonKey: "algaeScoreProcessor",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelGreen,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("algaeScoreProcessor"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["algaeRemove"],
                title: "Remove",
                jsonKey: "algaeRemove",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelGreen,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("algaeRemove"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["algaePickups"],
                title: "Algae Intake",
                jsonKey: "algaePickups",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelBlue,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("algaePickups"), HapticFeedback.heavyImpact()},
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
                onIncrement: () => {history.addLast("coralScoredL4"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["coralScoredL3"],
                title: "L3",
                jsonKey: "coralScoredL3",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelYellow,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("coralScoredL3"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["coralScoredL2"],
                title: "L2",
                jsonKey: "coralScoredL2",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelYellow,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("coralScoredL2"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["coralScoredL1"],
                title: "L1",
                jsonKey: "coralScoredL1",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelYellow,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("coralScoredL1"), HapticFeedback.heavyImpact()},
              ),
              Counter(
                key: counters["coralPickups"],
                title: "Coral Intake",
                jsonKey: "coralPickups",
                height: _height / 5,
                width: _width / 2,
                color: Constants.pastelBlue,
                boxColor: Constants.pastelWhite,
                onIncrement: () => {history.addLast("coralPickups"), HapticFeedback.heavyImpact()},
              ),
            ],
          )
        ]));
  }
}
