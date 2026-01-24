import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class AutoPathSelector extends StatefulWidget {
  const AutoPathSelector({super.key});

  @override
  State<AutoPathSelector> createState() => _AutoPathSelectorState();
}

class Node {
  String id;
  double width;
  double height;
  double top;
  double left;
  Color? color;

  Node(
      {required this.id,
      required this.width,
      required this.height,
      required this.top,
      required this.left,
      this.color});

  Positioned generatePositionedWidget() {
    return Positioned(
        top: top,
        left: left,
        child: GestureDetector(
            onTap: () {
              print("$id pressed!");
            },
            child: Container(width: width, height: height, color: Color.fromARGB(200, 255, 255, 255))));
  }
}

class _AutoPathSelectorState extends State<AutoPathSelector> {
  String imageFilePath = "assets/images/rebuildFieldMap.png";
  late AssetImage fieldImage;
  double rawImageWidth = 464;
  double rawImageHeight = 647;
  double margin = 10;
  double bottomOffset = 100;

  double width = 350; // The intended width of the widget
  late double height;

  List<Node> specialLocationNodes = [
    Node(id: "depot", top: 105, left: 10, width: 61, height: 56),
    Node(id: "outpost", top: 375, left: 0, width: 40, height: 50),
    Node(id: "tower", top: 215, left: 10, width: 85, height: 62),
    Node(id: "trench_depot", top: 24, left: 240, width: 65, height: 77),
    Node(id: "bump_depot", top: 101, left: 240, width: 65, height: 97),
    Node(id: "bump_outpost", top: 263, left: 240, width: 65, height: 97),
    Node(id: "trench_outpost", top: 360, left: 240, width: 65, height: 77),

  ];

  List<Positioned> generateWidgetsFromNodes(List<Node> nodes) {
    List<Positioned> widgets = [];
    for (Node node in nodes) {
      widgets.add(node.generatePositionedWidget());
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    fieldImage = AssetImage(imageFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * rawImageHeight / rawImageWidth + bottomOffset,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        color: Constants.pastelWhite,
      ),
      child: Center(
        child: Container(
          width: width - 2 * margin,
          height: (width - 2 * margin) * rawImageHeight / rawImageWidth,
          decoration: BoxDecoration(
              color: Constants.neonBlue,
              image: DecorationImage(
                  image: fieldImage,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Constants.pastelRed, BlendMode.modulate))),
          child: Stack(
            children: generateWidgetsFromNodes(specialLocationNodes)
          ),
        ),
      ),
    );
  }
}
