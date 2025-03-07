import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';

// Enum to define different sorting options
enum Sort { LENGTH_MAX, NAME_AZ, NAME_ZA, EARLIEST, LATEST }

class ScrollableBox extends StatefulWidget {
  final double width; // Width of the scrollable box
  final double height; // Height of the scrollable box
  final String title; // Title of the scrollable box
  final List<List<String>>
      comments; // List of comments [Scouter Name, Text, Match]

  const ScrollableBox(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      required this.comments});

  @override
  State<ScrollableBox> createState() => _ScrollableBoxState();
}

class _ScrollableBoxState extends State<ScrollableBox> {
  double get _width => widget.width; // Getter for width
  double get _height => widget.height; // Getter for height
  String get _title => widget.title; // Getter for title
  List<List<String>> get _comments => widget.comments; // Getter for comments
  Sort _sort = Sort.LATEST; // Getter for sorting option

  // Default sorting algorithm (by match number in descending order)
  int Function(List<String>, List<String>) sortingAlgorithm =
      (x, y) => int.parse(y[2]) - int.parse(x[2]);

  // Set the sorting algorithm based on the selected sorting option
  void setSortingAlgorithm() {
    switch (_sort) {
      case Sort.LENGTH_MAX:
        sortingAlgorithm = (x, y) =>
            y[1].length - x[1].length; // Sort by comment length (descending)
      case Sort.NAME_AZ:
        sortingAlgorithm =
            (x, y) => x[0].compareTo(y[0]); // Sort by scouter name (A-Z)
      case Sort.NAME_ZA:
        sortingAlgorithm =
            (x, y) => y[0].compareTo(x[0]); // Sort by scouter name (Z-A)
      case Sort.EARLIEST:
        sortingAlgorithm = (x, y) =>
            int.parse(x[2]) -
            int.parse(y[2]); // Sort by match number (ascending)
      case Sort.LATEST:
        sortingAlgorithm = (x, y) =>
            int.parse(y[2]) -
            int.parse(x[2]); // Sort by match number (descending)
    }
  }

  // Sort the comments using the selected sorting algorithm
  void sortComments() {
    _comments.sort(sortingAlgorithm);
  }

  @override
  void initState() {
    super.initState();
    setSortingAlgorithm(); // Set the sorting algorithm on initialization
    sortComments(); // Sort the comments on initialization
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => {setState(() {
        if (_sort == Sort.LATEST) {
          _sort = Sort.LENGTH_MAX;
        } else {
          _sort = Sort.LATEST;
        }
        setSortingAlgorithm();
        sortComments();
      })},
      child: Container(
          width: _width, // Set the width of the container
          height: _height, // Set the height of the container
          padding: const EdgeInsets.all(10), // Add padding inside the container
          decoration: BoxDecoration(
              color: Constants.pastelWhite, // Set the background color
              borderRadius: BorderRadius.circular(
                  Constants.borderRadius)), // Set the border radius
          child: Column(
            spacing: 8, // Add spacing between children
            children: [
              // Display the title and the number of comments
              Text("$_title (${_comments.length})",
                  style: comfortaaBold(20, color: Constants.pastelBrown)),
              Expanded(
                child: ListView.separated(
                    itemCount: _comments.length, // Number of comments
                    separatorBuilder: (context, index) => Divider(
                        height: 12,
                        color:
                            Constants.pastelWhite), // Divider between comments
                    itemBuilder: (BuildContext context, int index) {
                      // Build each comment box
                      return CommentBox(
                          name: _comments[index][0], // Scouter name
                          text: _comments[index][1], // Comment text
                          time: _comments[index][2]); // Match number
                    }),
              ),
            ],
          )),
    );
  }
}
