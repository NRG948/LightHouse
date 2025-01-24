import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';

class ScrollableBox extends StatefulWidget {
  final double width;
  final double height;
  final String title;

  const ScrollableBox(
      {super.key,
      required this.width,
      required this.height,
      required this.title});

  @override
  State<ScrollableBox> createState() => _ScrollableBoxState();
}

class _ScrollableBoxState extends State<ScrollableBox> {
  double get _width => widget.width;
  double get _height => widget.height;
  String get _title => widget.title;

  List<String> testNames = ["Jeffery", "Bezos", "Banana"];
  List<String> testText = [
    "oh yeah that was one of the moments of all time",
    "absolute cinema",
    "sigma sigma on the wall who is the skibidiest of the all lorem ipsum sussy baka"
  ];

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
          spacing: 10,
          children: [
            Text(_title,
                style: comfortaaBold(24,
                    customFontWeight: FontWeight.w900, color: Colors.black)),
            Expanded(
              child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      Divider(height: 12, color: Constants.pastelWhite),
                  itemBuilder: (BuildContext context, int index) {
                    return CommentBox(
                        name: testNames[index], text: testText[index]);
                  }),
            ),
          ],
        ));
  }
}
