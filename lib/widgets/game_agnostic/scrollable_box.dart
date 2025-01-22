import 'package:flutter/material.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';

class ScrollableBox extends StatefulWidget {
  final double width;
  final double height;

  const ScrollableBox({super.key, required this.width, required this.height});

  @override
  State<ScrollableBox> createState() => _ScrollableBoxState();
}

class _ScrollableBoxState extends State<ScrollableBox> {
  double get _width => widget.width;
  double get _height => widget.height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _width,
        height: _height,
        child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              return CommentBox();
            }));
  }
}
