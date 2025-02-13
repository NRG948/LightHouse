import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

// This widget animates an object along a predefined path with auto-replay functionality.
class AnimatedAutoReplay extends StatefulWidget {
  final double height;
  final double width;
  final List<double> startingPosition;
  final List<List<dynamic>> waypoints;
  final bool flipStarting;
  const AnimatedAutoReplay(
      {super.key,
      required this.height,
      required this.width,
      required this.startingPosition,
      required this.waypoints,
      required this.flipStarting});

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
  List<double> get _startingPosition => widget.startingPosition;
  List<List<dynamic>> get _waypoints => widget.waypoints;
  bool get _flipStarting => widget.flipStarting;
  late Animation<Offset> _animation;

  late double _robotSideLength;

  @override
  void initState() {
    super.initState();

    // Initialize robot size and animation controller.
    _robotSideLength = (min(_height, _width) - 20) / 12;
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _resetAutoPath();
      }
    });
    _animation = _getAnimationPath();

    /*
    TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: Offset(6, 6), end: Offset(5.35, 6))
              .chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: 2),
      TweenSequenceItem(
          tween: Tween(begin: Offset(5.35, 6), end: Offset(2.2, 0))
              .chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(2.2, 0), end: Offset(-0.05, 1.3))
              .chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(-0.05, 1.3), end: Offset(-0.05, 1.3))
              .chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: 1),
    ]).animate(_controller);
    */
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
                    _startingPosition, _flipStarting),
                end: keyLocations[eventToLocation[_waypoints[0][0]]])
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1));
    for (int i = 1; i < _waypoints.length; i++) {
      items.add(TweenSequenceItem(
          tween: Tween(
            begin: keyLocations[eventToLocation[_waypoints[i - 1][0]]],
            end: keyLocations[eventToLocation[_waypoints[i][0]]],
          ).chain(CurveTween(curve: Curves.easeInOutCubic)),
          weight: _waypoints[i][1] - _waypoints[i - 1][1]));
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
      child: Stack(
        children: [
          Center(
            child: Container(
              width: min(_width, _height),
              height: min(_width, _height),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/auto_field_map.png"),
                    fit: BoxFit.contain),
              ),
              child: AnimatedBuilder(
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
            ),
          ),
          GestureDetector(
            onTap: _autoPathSingleClick,
            onLongPress: _resetAutoPath,
          ),
        ],
      ),
    );
  }
}
