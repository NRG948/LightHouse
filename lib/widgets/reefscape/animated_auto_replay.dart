import 'dart:math';

import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

// This widget animates an object along a predefined path with auto-replay functionality.
class AnimatedAutoReplay extends StatefulWidget {
  double height;
  double width;
  List<String> scouterNames;
  int matchNumber;
  AutoPath? path;
  AutoReef? reef;

  AnimatedAutoReplay(
      {super.key,
      required this.height,
      required this.width,
      required this.scouterNames,
      required this.matchNumber,
      this.path,
      this.reef});

  @override
  State<AnimatedAutoReplay> createState() => _AnimatedAutoReplayState();
}

class _AnimatedAutoReplayState extends State<AnimatedAutoReplay>
    with SingleTickerProviderStateMixin {
  // Define key locations and event mappings.
  static final Map<String, Offset> keyLocations = {
    "AB": Offset(-0.8, 0),
    "CD": Offset(-0.05, 1.3),
    "EF": Offset(1.45, 1.3),
    "GH": Offset(2.2, 0),
    "IJ": Offset(1.45, -1.3),
    "KL": Offset(-0.05, -1.3),
    "ground": Offset(-4, 0),
    "processorCS": Offset(-4.4, 4.4),
    "bargeCS": Offset(-4.4, -4.4),
  };

  static final Map<String, String> eventToLocation = {
    "enterAB": "AB",
    "exitAB": "AB",
    "enterCD": "CD",
    "exitCD": "CD",
    "enterEF": "EF",
    "exitEF": "EF",
    "enterGH": "GH",
    "exitGH": "GH",
    "enterIJ": "IJ",
    "exitIJ": "IJ",
    "enterKL": "KL",
    "exitKL": "KL",
    "intakeCoral": "ground",
    "enterProcessorCS": "processorCS",
    "exitProcessorCS": "processorCS",
    "enterBargeCS": "bargeCS",
    "exitBargeCS": "bargeCS",
  };

  late AnimationController _controller;
  double get _height => widget.height;
  double get _width => widget.width;
  List<String> get _scouterNames => widget.scouterNames;
  int get _matchNumber => widget.matchNumber;
  AutoPath? get _autoPath => widget.path;
  AutoReef? get _autoReef => widget.reef;
  Animation<Offset>? _animation;
  late double _robotSideLength;
  FragmentProgram? program;

  @override
  void initState() {
    super.initState();
    loadShader();

    // Initialize robot size and animation controller.
    _robotSideLength = (_width / 2 - 20) / 12;
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _resetAutoPath();
      }
    });

    if (_autoPath != null) {
      _animation = _getAnimationPath();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Handle single click to start/stop animation.
  void _autoPathSingleClick() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  void loadShader() async {
    program = await FragmentProgram.fromAsset('assets/shaders/stripes_shader.frag');
    setState(() {});
  }

  // Reset the animation path.
  void _resetAutoPath() {
    _controller.reset();
  }

  // Calculate offset from starting location.
  Offset _calculateOffsetFromStartingLocation(List<double> pos, bool flip) {
    assert(pos.length == 2);
    double x = pos[0];
    double y = pos[1];
    if (flip) {
      x = 0.9 - x;
      y = 0.9 - y;
    }

    return Offset(6 - (0.6 - x) * 13 / 6, 2 * (y - 0.5) * 6);
  }

  // Generate animation path based on waypoints.
  Animation<Offset> _getAnimationPath() {
    List<TweenSequenceItem<Offset>> items = [];
    items.add(TweenSequenceItem(
        tween: Tween(
                begin: _calculateOffsetFromStartingLocation(
                    _autoPath!.startingPosition, _autoPath!.flipStarting),
                end: keyLocations[eventToLocation[_autoPath!.waypoints[0][0]]])
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: max(_autoPath!.waypoints[0][1], 0.1)));

    for (int i = 1; i < _autoPath!.waypoints.length; i++) {
      items.add(TweenSequenceItem(
          tween: Tween(
            begin:
                keyLocations[eventToLocation[_autoPath!.waypoints[i - 1][0]]],
            end: keyLocations[eventToLocation[_autoPath!.waypoints[i][0]]],
          ).chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: max(
              _autoPath!.waypoints[i][1] - _autoPath!.waypoints[i - 1][1],
              0.1)));
    }
    return TweenSequence(items).animate(_controller);
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
            Text(_matchNumber.toString(),
                style: comfortaaBold(22, color: Constants.pastelRedSuperDark))
          ]),
          Row(
            children: [
              _animation == null
                  ? Container(
                      width: _width / 2,
                      height: _width / 2,
                      color: Constants.pastelGray,
                      child: Center(
                        child: Text("No path data", style: comfortaaBold(21)),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: _width / 2,
                        height: _width / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/auto_field_map.png"),
                              fit: BoxFit.contain),
                        ),
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _animation!,
                              builder: (context, child) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: FractionalTranslation(
                                    translation: _animation!.value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                width: _robotSideLength,
                                height: _robotSideLength,
                                decoration: BoxDecoration(
                                  color: Constants.pastelRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _autoPathSingleClick,
                              onLongPress: _resetAutoPath,
                            ),
                          ],
                        ),
                      ),
                    ),
              _autoReef == null
                  ? Container(
                      width: _width / 2 * sqrt(3) / 2,
                      height: _width / 2,
                      color: Constants.pastelGray,
                      child: Center(
                        child: Text("No reef data", style: comfortaaBold(21)),
                      ),
                    )
                  : CustomPaint(
                      size: Size(_width / 2 * sqrt(3) / 2, _width / 2),
                      painter: AutoReefPainter(
                          program: program, autoReef: _autoReef))
            ],
          ),
          _autoReef == null
              ? Container()
              : Row(
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
      scoreDistribution[int.parse(coral[1]) - 2] += 1;
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

class AutoPath {
  final List<double> startingPosition;
  final List<List<dynamic>> waypoints;
  final bool flipStarting;
  const AutoPath(
      {required this.startingPosition,
      required this.waypoints,
      required this.flipStarting});
}

class AutoReef {
  final List<String> scores;
  final List<String> algaeRemoved;
  final int troughCount;
  const AutoReef(
      {required this.scores,
      required this.algaeRemoved,
      required this.troughCount});
}
