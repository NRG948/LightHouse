import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';
import 'package:lighthouse/widgets/reefscape/animated_atuo_replay.dart';

class ScrollableAutoPaths extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final List<AnimatedAutoReplay> autos;

  const ScrollableAutoPaths(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      required this.autos});

  @override
  State<ScrollableAutoPaths> createState() => _ScrollableAutoPathsState();
}

class _ScrollableAutoPathsState extends State<ScrollableAutoPaths> {
  double get _width => widget.width;
  double get _height => widget.height;
  String get _title => widget.title;
  List<AnimatedAutoReplay> get _autos => widget.autos;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _width,
        height: _height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          spacing: 8,
          children: [
            Text("$_title (${_autos.length})",
                style: comfortaaBold(20, color: Colors.black)),
            Expanded(
              child: ListView.separated(
                  itemCount: _autos.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 12, color: Colors.transparent),
                  itemBuilder: (BuildContext context, int index) {
                    return _autos[index];
                  }),
            ),
          ],
        ));
  }
}
