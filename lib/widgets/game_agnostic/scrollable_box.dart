import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';

enum Sort { LENGTH_MAX, NAME_AZ, NAME_ZA, EARLIEST, LATEST }

class ScrollableBox extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final List<List<String>> comments; // [Scouter Name, Text, Match]
  final Sort sort;

  const ScrollableBox(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      required this.comments,
      required this.sort});

  @override
  State<ScrollableBox> createState() => _ScrollableBoxState();
}

class _ScrollableBoxState extends State<ScrollableBox> {
  double get _width => widget.width;
  double get _height => widget.height;
  String get _title => widget.title;
  List<List<String>> get _comments => widget.comments;
  Sort get _sort => widget.sort;
  int Function(List<String>, List<String>)  sortingAlgorithm = (x, y) => int.parse(y[2]) - int.parse(x[2]);

  void setSortingAlgorithm() {
    switch (_sort) {
      case Sort.LENGTH_MAX:
        sortingAlgorithm = (x, y) => y[1].length - x[1].length;
      case Sort.NAME_AZ:
        sortingAlgorithm = (x, y) => x[0].compareTo(y[0]);
      case Sort.NAME_ZA:
        sortingAlgorithm = (x, y) => y[0].compareTo(x[0]);
      case Sort.EARLIEST:
        sortingAlgorithm = (x, y) => int.parse(x[2]) - int.parse(y[2]);
      case Sort.LATEST:
        sortingAlgorithm = (x, y) => int.parse(y[2]) - int.parse(x[2]);
    }
  }

  void sortComments() {
    _comments.sort(sortingAlgorithm);
  }

  @override
  void initState() {
    super.initState();
    setSortingAlgorithm();
    sortComments();
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
          spacing: 10,
          children: [
            Text(_title,
                style: comfortaaBold(24,
                    customFontWeight: FontWeight.w900, color: Colors.black)),
            Expanded(
              child: ListView.separated(
                  itemCount: _comments.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 12, color: Constants.pastelWhite),
                  itemBuilder: (BuildContext context, int index) {
                    return CommentBox(
                        name: _comments[index][0], text: _comments[index][1], time: _comments[index][2]);
                  }),
            ),
          ],
        ));
  }
}
