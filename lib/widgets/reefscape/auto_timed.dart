import 'dart:async';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import "dart:math";
import "dart:ui" as ui;

import 'package:lighthouse/pages/data_entry.dart';

// TODO: Turn coral intake into a TextButton
// TODO: Make Coral Station buttons more evident (add an icon?)

class RSAutoTimed extends StatefulWidget {
  final double width;
  const RSAutoTimed({super.key, required this.width});

  @override
  State<RSAutoTimed> createState() => _RSAutoTimedState();
}

class _RSAutoTimedState extends State<RSAutoTimed> {
  late double scaleFactor;
  static List<bool> widgetStates = List.filled(8, false);
  double _textAngle = pi / 2;

  @override
  void initState() {
    super.initState();
    scaleFactor = widget.width / 400;
    DataEntry.exportData["autoEventList"] = [];
  }

  @override
  void dispose() {
    super.dispose();
    widgetStates = List.filled(10, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 550 * scaleFactor,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: GestureDetector(
        onLongPress: () => {
          setState(() {
            _textAngle += pi;
            if (_textAngle > 2 * pi) {
              _textAngle -= 2 * pi;
            }
          })
        },
        child: Column(
          spacing: 20,
          children: [
            Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                      offset: Offset(5, 5),
                      child: RSATCoralStation(left: true, index: 6, textAngle: _textAngle)),
                  Transform.translate(
                    offset: Offset(0, 5),
                    child: Container(
                      width: 125,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Constants.pastelGray,
                          borderRadius:
                              BorderRadius.circular(Constants.borderRadius)),
                      child: TextButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          DataEntry.exportData["autoEventList"].add([
                            "intakeCoral",
                            (DataEntry.stopwatchMap[1] ??
                                    Duration(milliseconds: 0))
                                .deciseconds
                          ]);
                        },
                        child: Transform.rotate(
                          angle: _textAngle,
                          child: Column(
                            children: [
                              Text(
                                "Ground",
                                style: comfortaaBold(18),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Coral",
                                style: comfortaaBold(18),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                      offset: Offset(-5, 5),
                      child: RSATCoralStation(left: false, index: 7, textAngle: _textAngle))
                ],
              ),
            ]),
            // Row(children: [Container(child: Text("TODO: ADD CORAL STATIONS/CORAL INTAKE",textAlign: TextAlign.center,),)],),
            RSATHexagon(
              radius: 170,
              textAngle: _textAngle
            )
          ],
        ),
      ),
    );
  }
}

class RSATCoralStation extends StatefulWidget {
  final bool left;
  final int index;
  final double textAngle;
  const RSATCoralStation({super.key, this.left = true, required this.index, required this.textAngle});

  @override
  State<RSATCoralStation> createState() => _RSATCoralStationState();
}

class _RSATCoralStationState extends State<RSATCoralStation> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          setState(() {
            if (!(_RSAutoTimedState.widgetStates.contains(true) &&
                !_RSAutoTimedState.widgetStates[widget.index])) {
              enabled = !enabled;
              _RSAutoTimedState.widgetStates[widget.index] =
                  !_RSAutoTimedState.widgetStates[widget.index];
              DataEntry.exportData["autoEventList"].add([
                "${_RSAutoTimedState.widgetStates[widget.index] ? "enter" : "exit"}${widget.left ? "ProcessorCS" : "BargeCS"}",
                (DataEntry.stopwatchMap[1] ?? Duration(milliseconds: 0))
                    .deciseconds
              ]);
            }
          });
        },
        child: Stack(
          children: [
            SizedBox(
              //I don't know why this is neccesary, but it is...? Otherwise it paints wrong...
              width: 100, // Set a specific width
              height: 100, // Set a specific height
              child: CustomPaint(
                painter: TrianglePainter(left: widget.left, enabled: enabled),
              ),
            ),
            Transform.translate(
                offset: Offset(widget.left ? 14 : 30, 10),
                child: Transform.rotate(
                    angle: widget.textAngle,
                    child: AutoSizeText("CS", style: comfortaaBold(30))))
          ],
        ),
      ),
    );
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
    final radius = 10.0; // Adjust the radius for rounded corners

    if (left) {
      path.moveTo(size.width - radius, 0); // Top-right corner
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(radius, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - radius);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.close();
    } else {
      path.moveTo(size.width - radius, 0); // Top-right corner
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(
          size.width, size.height, size.width - radius, size.height);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RSATHexagon extends StatefulWidget {
  final double radius;
  final double textAngle;

  const RSATHexagon({super.key, required this.radius, required this.textAngle});
  @override
  State<RSATHexagon> createState() => _RSATHexagonState();
}

class _RSATHexagonState extends State<RSATHexagon> {
  //List<bool> _RSAutoTimedState.widgetStates = List.filled(6, false); // Track state of each section
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
    HapticFeedback.heavyImpact();
    setState(() {
      if (!(_RSAutoTimedState.widgetStates.contains(true) &&
          !_RSAutoTimedState.widgetStates[index])) {
        _RSAutoTimedState.widgetStates[index] =
            !_RSAutoTimedState.widgetStates[index];
        DataEntry.exportData["autoEventList"].add([
          "${_RSAutoTimedState.widgetStates[index] ? "enter" : "exit"}${triangleLabels[index]}",
          (DataEntry.stopwatchMap[1] ?? Duration(milliseconds: 0)).deciseconds
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
        painter: HexagonPainter(_RSAutoTimedState.widgetStates.sublist(0, 6), widget.textAngle),
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
  final double textAngle;
  HexagonPainter(this.sectionStates, this.textAngle);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = radius;
    double centerY = radius;

    Paint borderPaint = Paint()
      ..color = Constants.pastelWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    List<List<Offset>> triangles = getTrianglePoints(centerX, centerY, radius);

    for (int i = 0; i < 6; i++) {
      Paint fillPaint = Paint()
        ..color = sectionStates[i] ? Colors.green : Constants.pastelGray
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
      //drawText(canvas, _RSATHexagonState.triangleLabels[i], center);
      drawImage(canvas, _RSATHexagonState.triangleCache[i], center, textAngle);
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

  void drawImage(Canvas canvas, ui.Image image, Offset position, double angle) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle - pi / 2);
    canvas.translate(-position.dx, -position.dy);
    //final image = await assetImageToUiImage("assets/images/reef-chronos/$text.png");
    paintImage(
        canvas: canvas,
        rect: Rect.fromCircle(center: position, radius: 30),
        image: image);

    canvas.restore();
  }

  void drawText(Canvas canvas, String text, Offset position) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: comfortaaBold(18, color: Constants.pastelBrown),
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
