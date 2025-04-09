import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/star_display.dart';

// CommentBox widget which is a stateful widget
class TDVCommentBox extends StatefulWidget {
  final String name; // Name of the commenter
  final String text; // Comment text
  final String time; // Time of the comment
  final String type; // Where the comment comes from (atlas, chronos, pit)
  final double quality; // Data quality (1-5 star rating)

  // Constructor for CommentBox
  const TDVCommentBox(
      {super.key, required this.name, required this.text, required this.time, required this.type, required this.quality});

  @override
  State<TDVCommentBox> createState() => _TDVCommentBoxState(); // Creating state for CommentBox
}

// State class for CommentBox
class _TDVCommentBoxState extends State<TDVCommentBox> {
  // Getters to access widget properties
  String get _text => widget.text;
  String get _name => widget.name;
  String get _time => widget.time;
  String get _type => widget.type;
  double get _quality => widget.quality;

  Color getBoxColor() {
    switch (_type) {
      case "atlas":
        return Constants.pastelRed;
      case "chronos":
        return Constants.pastelYellow;
      case "pit":
        return Constants.pastelGreen;
      case _:
        return Constants.pastelGray; // This should never happen.
    }
    
  }

  @override
  void initState() {
    super.initState(); // Initializing state
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container decoration
      decoration: BoxDecoration(
          color: getBoxColor() , // Background color
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0), // Shadow color
              offset: Offset.fromDirection(pi / 2, 5), // Shadow offset
              blurRadius: 2, // Shadow blur radius
            )
          ],
          borderRadius: BorderRadius.circular(Constants.borderRadius)), // Rounded corners
      padding: EdgeInsets.all(8), // Padding inside the container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
        children: [
          // Displaying name and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("$_name  $_time",
                  textAlign: TextAlign.left,
                  style: comfortaaBold(18,
                      customFontWeight: FontWeight.w900,
                      color: Constants.pastelWhite)),
              StarDisplay(starRating: _quality)
            ],
          ),
          // Displaying comment text
          Text(_text,
              textAlign: TextAlign.left,
              style:
                  comfortaaBold(14, bold: true, color: Constants.pastelWhite)),
        ],
      ),
    );
  }
}
