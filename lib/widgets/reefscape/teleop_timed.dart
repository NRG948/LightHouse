import 'dart:async';

//TODO: Bugfixes
//  - Timer starts at 2:00 instead of 2:15
//  - Start climb should be a button and also stay on
// TODO: Add score net button
//TODO: Make start climb only clickable once

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import "dart:math";
import "dart:ui" as ui;

import 'package:lighthouse/pages/data_entry.dart';

class RSTeleopTimed extends StatefulWidget {
  final double width;
  const RSTeleopTimed({super.key, required this.width});

  @override
  State<RSTeleopTimed> createState() => _RSTeleopTimedState();
}

class _RSTeleopTimedState extends State<RSTeleopTimed> {
  static late double scaleFactor;
  static late double screenHeight;
  static List<bool> widgetStates = List.filled(5, false);
  double _textAngle = pi / 2;

  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;

    DataEntry.exportData["teleopEventList"] = [];
  }

  @override
  void dispose() {
    super.dispose();
    widgetStates = List.filled(5, false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => {
        setState(() {
          _textAngle += pi;
          if (_textAngle > 2 * pi) {
            _textAngle -= 2 * pi;
          }
        })
      },
      child: Container(
        width: widget.width,
        height: 600 * scaleFactor,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          spacing: 25 * scaleFactor,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(5, 5),
                  child: RSTTClimb(textAngle: _textAngle),
                ),
                Transform.translate(
                    offset: Offset(-5, 5),
                    child: RSTTCoral(textAngle: _textAngle)),
              ],
            ),
            // Row(children: [Container(child: Text("TODO: ADD CORAL STATIONS/CORAL INTAKE",textAlign: TextAlign.center,),)],),
            RSTTHexagon(radius: 165 * scaleFactor, textAngle: _textAngle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(5, 0),
                  child: RSTTNet(textAngle: _textAngle),
                ),
                Transform.translate(
                    offset: Offset(-5, 0),
                    child: RSTTProcessor(textAngle: _textAngle)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RSTTNet extends StatefulWidget {
  final double textAngle;
  const RSTTNet({super.key, required this.textAngle});
  @override
  State<RSTTNet> createState() => _RSTTNet();
}

class _RSTTNet extends State<RSTTNet> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165 * _RSTeleopTimedState.scaleFactor,
      height: 130 * _RSTeleopTimedState.scaleFactor,
      decoration: BoxDecoration(
          color: enabled ? Colors.green : Constants.pastelGray,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: TextButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            if (!(_RSTeleopTimedState.widgetStates.contains(true) &&
                !_RSTeleopTimedState.widgetStates[2])) {
              setState(() {
                enabled = !enabled;
                _RSTeleopTimedState.widgetStates[2] = enabled;
                DataEntry.exportData["teleopEventList"].add([
                  "${enabled ? "enter" : "exit"}NetShoot",
                  (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0))
                      .deciseconds
                ]);
              });
            }
          },
          child: Transform.rotate(
              angle: widget.textAngle,
              child: Text(
                "Score\nNet",
                style: comfortaaBold(18 * _RSTeleopTimedState.scaleFactor),
                textAlign: TextAlign.center,
              ))),
    );
  }
}

class RSTTClimb extends StatefulWidget {
  final double textAngle;
  const RSTTClimb({super.key, required this.textAngle});
  @override
  State<RSTTClimb> createState() => _RSTTClimbState();
}

class _RSTTClimbState extends State<RSTTClimb> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 165 * _RSTeleopTimedState.scaleFactor,
        height: 130 * _RSTeleopTimedState.scaleFactor,
        decoration: BoxDecoration(
            color: enabled ? Colors.green : Constants.pastelGray,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: TextButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              if (!(_RSTeleopTimedState.widgetStates.contains(true) &&
                  !_RSTeleopTimedState.widgetStates[3])) {
                setState(() {
                  enabled = !enabled;
                  _RSTeleopTimedState.widgetStates[3] = enabled;
                  DataEntry.exportData["teleopEventList"].add([
                    "${enabled ? "enter" : "exit"}ClimbArea",
                    (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0))
                        .deciseconds
                  ]);
                });
              }
            },
            child: Transform.rotate(
                angle: widget.textAngle,
                child: Text(
                  "Climb",
                  style: comfortaaBold(18),
                  textAlign: TextAlign.center,
                ))));
  }
}

class RSTTCoral extends StatefulWidget {
  final double textAngle;
  const RSTTCoral({super.key, required this.textAngle});
  @override
  State<RSTTCoral> createState() => _RSTTCoralState();
}

class _RSTTCoralState extends State<RSTTCoral> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165 * _RSTeleopTimedState.scaleFactor,
      height: 130 * _RSTeleopTimedState.scaleFactor,
      decoration: BoxDecoration(
          color: enabled ? Colors.green : Constants.pastelGray,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: TextButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            if (!(_RSTeleopTimedState.widgetStates.contains(true) &&
                !_RSTeleopTimedState.widgetStates[4])) {
              setState(() {
                enabled = !enabled;
                _RSTeleopTimedState.widgetStates[4] = enabled;
                DataEntry.exportData["teleopEventList"].add([
                  "${enabled ? "enter" : "exit"}CoralStation",
                  (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0))
                      .deciseconds
                ]);
              });
            }
          },
          child: Transform.rotate(
              angle: widget.textAngle,
              child: Text(
                "Intake\nCoral",
                style: comfortaaBold(18 * _RSTeleopTimedState.scaleFactor),
                textAlign: TextAlign.center,
              ))),
    );
  }
}

class RSTTProcessor extends StatefulWidget {
  final double textAngle;
  const RSTTProcessor({super.key, required this.textAngle});
  @override
  State<RSTTProcessor> createState() => _RSTTProcessorState();
}

class _RSTTProcessorState extends State<RSTTProcessor> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 165 * _RSTeleopTimedState.scaleFactor,
        height: 130 * _RSTeleopTimedState.scaleFactor,
        decoration: BoxDecoration(
            color: enabled ? Colors.green : Constants.pastelGray,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: TextButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              if (!(_RSTeleopTimedState.widgetStates.contains(true) &&
                  !_RSTeleopTimedState.widgetStates[1])) {
                setState(() {
                  enabled = !enabled;
                  _RSTeleopTimedState.widgetStates[1] = enabled;
                  DataEntry.exportData["teleopEventList"].add([
                    "${enabled ? "enter" : "exit"}Processor",
                    (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0))
                        .deciseconds
                  ]);
                });
              }
            },
            child: Transform.rotate(
                angle: widget.textAngle,
                child: Text(
                  "Processor",
                  style: comfortaaBold(12),
                  textAlign: TextAlign.center,
                ))));
  }
}

class RSTTHexagon extends StatefulWidget {
  final double radius;
  final double textAngle;
  const RSTTHexagon({super.key, required this.radius, required this.textAngle});
  @override
  State<RSTTHexagon> createState() => _RSTTHexagonState();
}

class _RSTTHexagonState extends State<RSTTHexagon> {
  void toggleSection(int index) {
    setState(() {
      print(_RSTeleopTimedState.widgetStates);
      if (!_RSTeleopTimedState.widgetStates.contains(true) ||
          _RSTeleopTimedState.widgetStates[index]) {
        HapticFeedback.heavyImpact();
        _RSTeleopTimedState.widgetStates[index] =
            !_RSTeleopTimedState.widgetStates[index];
        DataEntry.exportData["teleopEventList"].add([
          "${_RSTeleopTimedState.widgetStates[index] ? "enter" : "exit"}Reef",
          (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0)).deciseconds
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (getTappedSection(details.localPosition)) {
          toggleSection(0);
        }
      },
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius * sqrt(3),
        child: CustomPaint(
          size: Size(widget.radius * 2, widget.radius * sqrt(3)),
          painter: HexagonPainter(_RSTeleopTimedState.widgetStates[0]),
          child: Center(
            child: Transform.rotate(
                angle: widget.textAngle,
                child: Text(
                  "Score Coral",
                  style: comfortaaBold(18),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ),
    );
  }

  bool getTappedSection(Offset tap) {
    double size = widget.radius;
    double centerX = size;
    double centerY = size * sqrt(3) / 2;

    return (Offset(centerX, centerY) - tap).distance < size;
  }
}

class HexagonPainter extends CustomPainter {
  final bool isHighlighted;
  HexagonPainter(this.isHighlighted);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = radius;
    double centerY = radius * sqrt(3) / 2;

    List<Offset> hexagon = getHexagonPoints(centerX, centerY, radius);

    Paint fillPaint = Paint()
      ..color = isHighlighted ? Colors.green : Constants.pastelGray
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..addPolygon(hexagon, true)
      ..close();

    canvas.drawPath(path, fillPaint);
  }

  static List<Offset> getHexagonPoints(double cx, double cy, double radius) {
    List<Offset> hexagonPoints = [];
    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i;
      hexagonPoints
          .add(Offset(cx + radius * cos(angle), cy + radius * sin(angle)));
    }

    return hexagonPoints;
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => true;
}
