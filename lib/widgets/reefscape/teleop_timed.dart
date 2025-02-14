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
  late double scaleFactor;
  static List<bool> widgetStates = List.filled(8, false);
  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    DataEntry.exportData["teleopEventList"] = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 500 * scaleFactor,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.translate(
                offset: Offset(5, 5),
                child: Container(
                    width: 100,
                    height: 75,
                    decoration: BoxDecoration(
                        color: Constants.pastelGray,
                        borderRadius:
                            BorderRadius.circular(Constants.borderRadius)),
                    child: TextButton(
                        onPressed: () {
                          // TODO: Add duplicate data prevention so that only one startClimb
                          // can be added
                          DataEntry.exportData["teleopEventList"].add([
                            "startClimb",
                            (DataEntry.stopwatchMap[2] 
                            ??Duration(milliseconds: 0))
                                .deciseconds
                          ]);
                        },
                        child: Transform.rotate(
                            angle: pi / 2,
                            child: Text(
                              "Start\nClimb",
                              style: comfortaaBold(18),
                              textAlign: TextAlign.center,
                            )))),
              ),
              Transform.translate(
                offset: Offset(0, 5),
                child: Container(
                    width: 100,
                    height: 75,
                    decoration: BoxDecoration(
                        color: Constants.pastelGray,
                        borderRadius:
                            BorderRadius.circular(Constants.borderRadius)),
                    child: TextButton(
                        onPressed: () {
                          DataEntry.exportData["teleopEventList"].add([
                            "intakeCoral",
                            (DataEntry.stopwatchMap[2] ??
                                    Duration(milliseconds: 0))
                                .deciseconds
                          ]);
                        },
                        child: Transform.rotate(
                            angle: pi / 2,
                            child: Text(
                              "Intake\nCoral",
                              style: comfortaaBold(18),
                              textAlign: TextAlign.center,
                            )))),
              ),
              Transform.translate(offset: Offset(-5, 5), child: RSTTProcessor())
            ],
          ),
          // Row(children: [Container(child: Text("TODO: ADD CORAL STATIONS/CORAL INTAKE",textAlign: TextAlign.center,),)],),
          RSTTHexagon(
            radius: 150,
          ),
          Container(
            width: 100 * scaleFactor,
            height: 75 * scaleFactor,
            decoration: BoxDecoration(color: Constants.pastelGray,borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: TextButton(
                onPressed: () {
                  print(DataEntry.stopwatchMap);
                  DataEntry.exportData["teleopEventList"].add([
                    "scoreNet",
                    (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0))
                        .deciseconds
                  ]);
                },
                child: Transform.rotate(
                    angle: pi / 2,
                    child: Text(
                      "Score\nNet",
                      style: comfortaaBold(18),
                      textAlign: TextAlign.center,
                    ))),
          )
        ],
      ),
    );
  }
}

class RSTTProcessor extends StatefulWidget {
  const RSTTProcessor({super.key});
  @override
  State<RSTTProcessor> createState() => _RSTTProcessorState();
}

class _RSTTProcessorState extends State<RSTTProcessor> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 75,
        decoration: BoxDecoration(
            color: enabled ? Colors.green : Constants.pastelGray,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: TextButton(
            onPressed: () {
              if (!(_RSTeleopTimedState.widgetStates.contains(true) &&
                  !_RSTeleopTimedState.widgetStates[7])) {
                setState(() {
                  enabled = !enabled;
                  DataEntry.exportData["teleopEventList"].add([
                    "${enabled ? "enter" : "exit"}Processor",
                    (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0))
                        .deciseconds
                  ]);
                });
              }
            },
            child: Transform.rotate(
                angle: pi / 2,
                child: Text(
                  "Processor",
                  style: comfortaaBold(12),
                  textAlign: TextAlign.center,
                ))));
  }
}

class TrianglePainter extends CustomPainter {
  final bool left;
  final bool enabled;
  const TrianglePainter({this.left = true, required this.enabled});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = enabled ? Colors.green : Constants.pastelGray
      ..style = PaintingStyle.fill;

    final path = Path();
    if (left) {
      path.moveTo(size.width, 0); // Top-right corner (90-degree angle)
      path.lineTo(0, 0); // Bottom-left corner
      path.lineTo(0, size.width); // Bottom-right corner
      path.close(); // Closes the path
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(size.width, size.height);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RSTTHexagon extends StatefulWidget {
  final double radius;
  const RSTTHexagon({super.key, required this.radius});
  @override
  State<RSTTHexagon> createState() => _RSTTHexagonState();
}

class _RSTTHexagonState extends State<RSTTHexagon> {
  //List<bool> _RSTeleopTimedState.widgetStates = List.filled(6, false); // Track state of each section
  static List<String> triangleLabels = [
    "IJ",
    "GH",
    "EF",
    "CD",
    "AB",
    "KL",
  ];
  static List<ui.Image> triangleCache = [];
  bool imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    for (String label in triangleLabels) {
      ui.Image image =
          await assetImageToUiImage("assets/images/reef-chronos/$label.png");
      triangleCache.add(image);
    }

    setState(() {
      imagesLoaded = true; // Ensure repaint after images are ready
    });
  }

  void toggleSection(int index) {
    setState(() {
      if (!(_RSTeleopTimedState.widgetStates.contains(true) &&
          !_RSTeleopTimedState.widgetStates[index])) {
        _RSTeleopTimedState.widgetStates[index] =
            !_RSTeleopTimedState.widgetStates[index];
        print(DataEntry.stopwatchMap);
        DataEntry.exportData["teleopEventList"].add([
          "${_RSTeleopTimedState.widgetStates[index] ? "enter" : "exit"}${triangleLabels[index]}",
          (DataEntry.stopwatchMap[2] ?? Duration(milliseconds: 0)).deciseconds
        ]);
      }
    });
  }

  Future<ui.Image> assetImageToUiImage(String assetPath) async {
    // Load the asset image as bytes
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // Decode the image into a ui.Image
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        int? tappedIndex = getTappedSection(details.localPosition);
        if (tappedIndex != null) {
          toggleSection(tappedIndex);
        }
      },
      child: CustomPaint(
        size: Size(widget.radius * 2, widget.radius * 2),
        painter: HexagonPainter(_RSTeleopTimedState.widgetStates.sublist(0, 6)),
      ),
    );
  }

  int? getTappedSection(Offset tap) {
    double size = widget.radius; // Radius of the hexagon
    double centerX = size;
    double centerY = size;
    List<List<Offset>> triangles =
        HexagonPainter.getTrianglePoints(centerX, centerY, size);

    for (int i = 0; i < triangles.length; i++) {
      if (isPointInTriangle(
          tap, triangles[i][0], triangles[i][1], triangles[i][2])) {
        return i;
      }
    }
    return null;
  }

  bool isPointInTriangle(Offset p, Offset a, Offset b, Offset c) {
    double sign(Offset p1, Offset p2, Offset p3) {
      return (p1.dx - p3.dx) * (p2.dy - p3.dy) -
          (p2.dx - p3.dx) * (p1.dy - p3.dy);
    }

    double d1 = sign(p, a, b);
    double d2 = sign(p, b, c);
    double d3 = sign(p, c, a);

    bool hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    bool hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(hasNeg && hasPos);
  }
}

class HexagonPainter extends CustomPainter {
  final List<bool> sectionStates;
  HexagonPainter(this.sectionStates);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = radius;
    double centerY = radius;

    Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    List<List<Offset>> triangles = getTrianglePoints(centerX, centerY, radius);

    for (int i = 0; i < 6; i++) {
      Paint fillPaint = Paint()
        ..color = sectionStates[i] ? Colors.green : Constants.pastelWhite
        ..style = PaintingStyle.fill;

      Path path = Path()
        ..moveTo(triangles[i][0].dx, triangles[i][0].dy)
        ..lineTo(triangles[i][1].dx, triangles[i][1].dy)
        ..lineTo(triangles[i][2].dx, triangles[i][2].dy)
        ..close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, borderPaint);

      // Draw text labels
      Offset center = getTriangleCenter(triangles[i]);
      drawImage(canvas, _RSTTHexagonState.triangleCache[i], center);
    }
  }

  static List<List<Offset>> getTrianglePoints(
      double cx, double cy, double radius) {
    List<Offset> hexagonPoints = [];
    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i;
      hexagonPoints
          .add(Offset(cx + radius * cos(angle), cy + radius * sin(angle)));
    }

    return [
      [Offset(cx, cy), hexagonPoints[0], hexagonPoints[1]],
      [Offset(cx, cy), hexagonPoints[1], hexagonPoints[2]],
      [Offset(cx, cy), hexagonPoints[2], hexagonPoints[3]],
      [Offset(cx, cy), hexagonPoints[3], hexagonPoints[4]],
      [Offset(cx, cy), hexagonPoints[4], hexagonPoints[5]],
      [Offset(cx, cy), hexagonPoints[5], hexagonPoints[0]],
    ];
  }

  Offset getTriangleCenter(List<Offset> triangle) {
    return Offset(
      (triangle[0].dx + triangle[1].dx + triangle[2].dx) / 3,
      (triangle[0].dy + triangle[1].dy + triangle[2].dy) / 3,
    );
  }

  void drawImage(Canvas canvas, ui.Image image, Offset position) {
    //final image = await assetImageToUiImage("assets/images/reef-chronos/$text.png");
    paintImage(
        canvas: canvas,
        rect: Rect.fromCircle(center: position, radius: 30),
        image: image);
  }

  void drawText(Canvas canvas, String text, Offset position) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: comfortaaBold(18, color: Constants.pastelReddishBrown),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    Offset textOffset = Offset(
      position.dx - textPainter.width / 2,
      position.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => true;
}
