import 'package:flutter/material.dart';
// Importing necessary packages and files
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/reefscape/animated_auto_replay.dart';

// Stateful widget to display scrollable auto paths
class ScrollableAutoPaths extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final List<AnimatedAutoReplay> autos;

  // Constructor for ScrollableAutoPaths
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
  // Getters to access widget properties
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
        // Container to hold the scrollable list
        width: _width,
        height: _height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          // Column to arrange title and list
          spacing: 8,
          children: [
            // Display title with the count of autos
            Text("$_title (${_autos.length})",
                style: comfortaaBold(20, color: Colors.black)),
            Expanded(
              // Expanded widget to make the list take available space
              child: ListView.separated(
                  // ListView to display autos
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
