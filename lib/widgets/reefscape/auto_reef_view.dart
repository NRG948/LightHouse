import 'dart:convert';
import 'dart:math';

import 'dart:ui' as ui;
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/star_display.dart';

// This widget animates an object along a predefined path with auto-replay functionality.
class AutoReefView extends StatefulWidget {
  double height;
  double width;
  List<String> scouterNames;
  double? dataQuality;
  int? matchNumber;
  AutoReef reef;
  bool pit;
  List<double> startingPosition;
  bool flipStartingPosition;
  bool hasNoAuto;
  
  AutoReefView(
      {super.key,
      required this.height,
      required this.width,
      required this.scouterNames,
      required this.matchNumber,
      required this.dataQuality,
      required this.reef,
      required this.startingPosition,
      required this.flipStartingPosition,
      required this.hasNoAuto,
      this.pit = false,
});

  @override
  State<AutoReefView> createState() => _AutoReefViewState();
}

class _AutoReefViewState extends State<AutoReefView>
    with SingleTickerProviderStateMixin {
  double get _height => widget.height;
  double get _width => widget.width;
  List<String> get _scouterNames => widget.scouterNames;
  int? get _matchNumber => widget.matchNumber;
  AutoReef get _autoReef => widget.reef;
  List<double> get _startingPosition => widget.startingPosition;
  bool get _flipStartingPosition => widget.flipStartingPosition;
  bool get _hasNoAuto => widget.hasNoAuto;
  FragmentProgram? program;

  @override
  void initState() {
    super.initState();
    loadShader(); // Last to avoid initState not completing autoPaths before it loads, leading to old paths being displayed
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadShader() async {
    program =
        await FragmentProgram.fromAsset('assets/shaders/stripes_shader.frag');
    setState(() {});
  }

  // Calculate offset from starting location.
  Offset _calculateOffsetFromStartingLocation(List<double> pos, bool flip) {
    if (pos.length != 2) {
      pos = [0, 0];
    }
    double x = pos[0];
    double y = pos[1];

    if (flip) {
      x = 1.0 - x;
      y = 1.0 - y;
    }

    double x_start_calculated = 0.119;
    double x_full_scout = 0.9;
    double y_full_scout = 1.0;

    return Offset(x_start_calculated + x * 0.063 / x_full_scout,
        y * 0.403 / y_full_scout);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 3,
        children: [
          Row(spacing: 10, children: [
            Text(_scouterNames.join(", "),
                style: comfortaaBold(22, color: Constants.pastelBrown)),
            Text((_matchNumber ?? "").toString(),
                style: comfortaaBold(22, color: Constants.pastelRedSuperDark)),
            if (!widget.pit && widget.dataQuality != null)
            StarDisplay(starRating: widget.dataQuality!,iconSize: 25,)
          ]),
          Row(
            spacing: _width / 16,
            children: [
              Column(
                spacing: 5,
                children: [
                  Container(
                    width: _width / 10,
                    height: _width / 10,
                    decoration: BoxDecoration(
                      color: _autoReef.bargeCS
                          ? Constants.pastelRedDark
                          : Constants.pastelGray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Container(
                    width: _width / 10,
                    height: _width / 4,
                    decoration: BoxDecoration(
                      color: _autoReef.groundIntake
                          ? Constants.pastelRedDark
                          : Constants.pastelGray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Container(
                    width: _width / 10,
                    height: _width / 10,
                    decoration: BoxDecoration(
                      color: _autoReef.processorCS
                          ? Constants.pastelRedDark
                          : Constants.pastelGray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  )
                ],
              ),
              _hasNoAuto
                  ? Container(
                      width: _width / 2 * sqrt(3) / 2,
                      height: _width / 2,
                      decoration: BoxDecoration(
                          color: Constants.pastelGray,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constants.borderRadius))),
                      child: Center(
                          child: Text("No Auto", style: comfortaaBold(20))),
                    )
                  : CustomPaint(
                      size: Size(_width / 2 * sqrt(3) / 2, _width / 2),
                      painter: AutoReefPainter(
                          program: program, autoReef: _autoReef)),
            if (!widget.pit)
              (_startingPosition[0] == 0 && _startingPosition[1] == 0)
                  ? Container(
                      width: _width / 2 * (320 / 552),
                      height: _width / 2,
                      decoration: BoxDecoration(
                          color: Constants.pastelGray,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constants.borderRadius))),
                      child: Center(
                          child: AutoSizeText("No Starting Location",
                              textAlign: TextAlign.center,
                              style: comfortaaBold(20))))
                  : Stack(
                      children: [
                        Container(
                          width: _width / 2 * (320 / 552),
                          height: _width / 2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/startingLocationField.png"),
                                  fit: BoxFit.cover)),
                        ),
                        Transform.translate(
                            offset: _calculateOffsetFromStartingLocation(
                                    _startingPosition, _flipStartingPosition) *
                                _width, // (0.147w middle, 0.175w edge, 0.028w half-width | 0.403w height)
                            child: Container(
                              width: _width / 28,
                              height: _width / 28,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constants.pastelRed,
                                  border: Border.all(
                                      width: _width / 120,
                                      color: Constants.pastelWhite)),
                            ))
                      ],
                    )
            ],
          ),
          Row(
            spacing: 15,
            children: getReefDataText(),
          )
        ],
      ),
    );
  }

  List<Widget> getReefDataText() {
    List<int> scoreDistribution = [0, 0, 0]; // L2, L3, L4

    for (String coral in _autoReef!.scores) {
      try {
      scoreDistribution[int.parse(coral[1]) - 2] += 1;
      } catch (_) {
        try {
          List<String> coralList = jsonDecode(coral);
          for (String innerCoral in coralList) {
            scoreDistribution[int.parse(innerCoral[1]) - 2] += 1;
          }
        } catch (_) {}
      }
    }

    return [
      Text("L1: ${_autoReef!.troughCount}",
          style: comfortaaBold(22, color: Constants.reefColors[0])),
      Text("L2: ${scoreDistribution[0]}",
          style: comfortaaBold(22, color: Constants.reefColors[1])),
      Text("L3: ${scoreDistribution[1]}",
          style: comfortaaBold(22, color: Constants.reefColors[2])),
      Text("L4: ${scoreDistribution[2]}",
          style: comfortaaBold(22, color: Constants.reefColors[3])),
      Text("A: ${_autoReef!.algaeRemoved.length}",
          style: comfortaaBold(22, color: Constants.reefColors[4])),
    ];
  }
}

class AutoReefPainter extends CustomPainter {
  FragmentProgram? program;
  AutoReef? autoReef;
  static const List<String> orderedReefBranches = [
    "G",
    "F",
    "E",
    "D",
    "C",
    "B",
    "A",
    "L",
    "K",
    "J",
    "I",
    "H"
  ];
  static const List<String> orderedAlgaeSpots = [
    "EF",
    "CD",
    "AB",
    "KL",
    "IJ",
    "GH"
  ];

  AutoReefPainter({required this.program, required this.autoReef});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    double radius = size.height / 2;
    double centerX = radius * sqrt(3) / 2;
    double centerY = radius;

    Map<String, List<int>> coralDistrbution = {};
    for (String branch in orderedReefBranches) {
      coralDistrbution[branch] = [];
    }
    for (String scoreInstance in autoReef!.scores) {
      // Fixes bug where 0-score autos don't render correctly
      if (scoreInstance == "" || scoreInstance == "[]") {continue;}
      coralDistrbution[scoreInstance[0]]!.add(int.parse(scoreInstance[1]));
    }

    Map<String, bool> algaeDistrbution = {};
    for (String removeInstance in autoReef!.algaeRemoved) {
      algaeDistrbution[removeInstance.substring(0, 2)] = true;
    }

    List<List<Offset>> reef = getRingPoints(Offset(centerX, centerY), radius);

    Paint defaultPaint = Paint()
      ..color = Constants.pastelGray
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = Constants.pastelWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 12; i++) {
      Paint fillPaint = defaultPaint;
      switch (coralDistrbution[orderedReefBranches[i]]!.length) {
        case 1:
          fillPaint = Paint()
            ..color = Constants
                .reefColors[coralDistrbution[orderedReefBranches[i]]![0] - 1]
            ..style = PaintingStyle.fill;
        case 2:
          var shader = program?.fragmentShader();

          Color color1 = Constants
              .reefColors[coralDistrbution[orderedReefBranches[i]]![0] - 1];
          Color color2 = Constants
              .reefColors[coralDistrbution[orderedReefBranches[i]]![1] - 1];

          List<double> params = [
            80,
            80,
            color1.r,
            color1.g,
            color1.b,
            color2.r,
            color2.g,
            color2.b,
            30,
            pi / 4
          ];
          for (int i = 0; i < 10; i++) {
            shader?.setFloat(i, params[i]);
          }

          fillPaint = Paint()
            ..color = Colors.black
            ..shader = shader
            ..style = PaintingStyle.fill;
        case 3:
          fillPaint = Paint()
            ..color = Constants.pastelYellow
            ..style = PaintingStyle.fill;
      }

      Path path = Path()
        ..addPolygon([
          reef[0][i],
          reef[1][i],
          reef[1][(i + 1) % 12],
          reef[0][(i + 1) % 12],
        ], true)
        ..close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, borderPaint);
    }

    for (int i = 0; i < 6; i++) {
      Path path = Path()
        ..addPolygon([
          reef[1][(i * 2 + 1) % 12],
          reef[1][(i * 2 + 3) % 12],
          Offset(centerX, centerY)
        ], true)
        ..close();

      Paint fillPaint = (algaeDistrbution[orderedAlgaeSpots[i]] ?? false)
          ? (Paint()
            ..color = Constants.reefColors[4]
            ..style = PaintingStyle.fill)
          : defaultPaint;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, borderPaint);
    }
  }

  List<List<Offset>> getRingPoints(Offset center, double radius) {
    List<List<Offset>> points = [[], []];

    for (int i = 0; i < 6; i++) {
      double angle = i * pi / 3;
      for (int k = 0; k < 2; k++) {
        double ringRadius = radius * (2 - k) / 2;
        points[k].add(
            center + Offset(cos(angle), sin(angle)) * ringRadius * sqrt(3) / 2);
        points[k].add(center +
            Offset(cos(angle + pi / 6), sin(angle + pi / 6)) * ringRadius);
      }
    }

    return points;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AutoReef {
  final List<String> scores;
  final List<String> algaeRemoved;
  final int troughCount;
  final bool groundIntake;
  final bool bargeCS;
  final bool processorCS;
  const AutoReef(
      {required this.scores,
      required this.algaeRemoved,
      required this.troughCount,
      required this.groundIntake,
      required this.bargeCS,
      required this.processorCS});
}
