import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class CommentBox extends StatefulWidget {
  final String name;
  final String text;
  final String time;

  const CommentBox(
      {super.key, required this.name, required this.text, required this.time});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  String get _text => widget.text;
  String get _name => widget.name;
  String get _time => widget.time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Constants.pastelRed,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              offset: Offset.fromDirection(pi / 2, 5),
              blurRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$_name  $_time",
              textAlign: TextAlign.left,
              style: comfortaaBold(18,
                  customFontWeight: FontWeight.w900,
                  color: Constants.pastelWhite)),
          Text(_text,
              textAlign: TextAlign.left,
              style:
                  comfortaaBold(14, bold: true, color: Constants.pastelWhite)),
        ],
      ),
    );
  }
}
