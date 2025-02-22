import 'dart:math';

import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

// This widget animates an object along a predefined path with auto-replay functionality.
class AnimatedAutoReplay extends StatefulWidget {
  final double height;
  final double width;
  final AutoPath? path;
  final AutoReef? reef;

  const AnimatedAutoReplay(
      {super.key,
      required this.height,
      required this.width,
      this.path,
      this.reef});

  @override
  State<AnimatedAutoReplay> createState() => _AnimatedAutoReplayState();
}

class _AnimatedAutoReplayState extends State<AnimatedAutoReplay>
    with SingleTickerProviderStateMixin {
  // Define key locations and event mappings.
  Map<String, Offset> keyLocations = {
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

  Map<String, String> eventToLocation = {
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
  AutoPath? get _autoPath => widget.path;
  late Animation<Offset> _animation;
  late double _robotSideLength;
  FragmentProgram? program;

  @override
  void initState() {
    super.initState();
    loadShader();

    // Initialize robot size and animation controller.
    _robotSideLength = (min(_height / 2, _width / 2) - 20) / 12;
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _resetAutoPath();
      }
    });
    _animation = _getAnimationPath();
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
    program =
        await FragmentProgram.fromAsset('assets/shaders/stripes_shader.frag');
    print('Shader Loaded');
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
    if (_autoPath == null) {
      return TweenSequence<Offset>([]).animate(_controller);
    }

    List<TweenSequenceItem<Offset>> items = [];
    items.add(TweenSequenceItem(
        tween: Tween(
                begin: _calculateOffsetFromStartingLocation(
                    _autoPath!.startingPosition, _autoPath!.flipStarting),
                end: keyLocations[eventToLocation[_autoPath!.waypoints[0][0]]])
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1));

    for (int i = 1; i < _autoPath!.waypoints.length; i++) {
      items.add(TweenSequenceItem(
          tween: Tween(
            begin:
                keyLocations[eventToLocation[_autoPath!.waypoints[i - 1][0]]],
            end: keyLocations[eventToLocation[_autoPath!.waypoints[i][0]]],
          ).chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: _autoPath!.waypoints[i][1] - _autoPath!.waypoints[i - 1][1]));
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
          Row(
            children: [
              Center(
                child: Container(
                  width: min(_width / 2, _height / 2),
                  height: min(_width / 2, _height / 2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/auto_field_map.png"),
                        fit: BoxFit.contain),
                  ),
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Align(
                            alignment: Alignment.center,
                            child: FractionalTranslation(
                              translation: _animation.value,
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
              CustomPaint(
                  size: Size(_width / 2 * sqrt(3) / 2, _height / 2),
                  painter: AutoReefPainter(program: program))
            ],
          ),
          Row(
            spacing: 5,
            children: [
              Text("L1: 3",
                  style: comfortaaBold(11,
                      color: Color.fromARGB(255, 195, 103, 191))),
              Text("L2: 2",
                  style: comfortaaBold(11,
                      color: Color.fromARGB(255, 77, 110, 211))),
              Text("L3: 4",
                  style: comfortaaBold(11,
                      color: Color.fromARGB(255, 82, 197, 69))),
              Text("L4: 4",
                  style: comfortaaBold(11,
                      color: Color.fromARGB(255, 236, 87, 87))),
              Text("A: 2",
                  style: comfortaaBold(11,
                      color: Color.fromARGB(255, 90, 216, 179))),
            ],
          )
        ],
      ),
    );
  }
}

class AutoReefPainter extends CustomPainter {
  FragmentProgram? program;
  AutoReef? autoReef;
  List<String> orderedReefBranches = [
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

  AutoReefPainter({this.program, this.autoReef});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    double radius = size.height / 2;
    double centerX = radius * sqrt(3) / 2;
    double centerY = radius;

    autoReef = AutoReef(scores: [
      "E4",
      "F4",
      "G3",
      "H2",
      "C3",
      "D3",
      "B4",
      "A2",
      "L3",
      "K4",
      "K3"
    ],
    algaeRemoved: [
      "GH2",
      "IJ3",
      "EF3",
      "CD2",
      "AB3",
      "KL3"
    ]);

    Map<String, List<int>> scoreDistribution = {};
    for (String branch in orderedReefBranches) {
      scoreDistribution[branch] = [];
    }

    for (String scoreInstance in autoReef!.scores) {
      scoreDistribution[scoreInstance[0]]!.add(int.parse(scoreInstance[1]));
    }

    List<List<Offset>> reef = getRingPoints(Offset(centerX, centerY), radius);

    List<Color> coralColors = [
      Color.fromARGB(255, 195, 103, 191),
      Color.fromARGB(255, 77, 110, 211),
      Color.fromARGB(255, 82, 197, 69),
      Color.fromARGB(255, 236, 87, 87)
    ];

    Paint defaultPaint = Paint()
      ..color = Constants.pastelGray
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = Constants.pastelWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 12; i++) {
      Paint fillPaint = defaultPaint;
      switch (scoreDistribution[orderedReefBranches[i]]!.length) {
        case 1:
          fillPaint = Paint()
            ..color =
                coralColors[scoreDistribution[orderedReefBranches[i]]![0] - 1]
            ..style = PaintingStyle.fill;
        case 2:
          var shader = program?.fragmentShader();

          Color color1 =
              coralColors[scoreDistribution[orderedReefBranches[i]]![0] - 1];
          Color color2 =
              coralColors[scoreDistribution[orderedReefBranches[i]]![1] - 1];

          List<double> params = [
            80,
            80,
            color1.r,
            color1.g,
            color1.b,
            color2.r,
            color2.g,
            color2.b,
            80,
            pi / 4
          ];
          for (int i = 0; i < 10; i++) {
            shader?.setFloat(i, params[i]);
          }

          fillPaint = Paint()
            ..color = Colors.black
            ..shader = shader
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

        canvas.drawPath(path, defaultPaint); // TODO
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
  const AutoReef({required this.scores, required this.algaeRemoved});
}
