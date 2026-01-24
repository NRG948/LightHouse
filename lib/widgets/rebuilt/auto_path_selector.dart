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

  Positioned generatePositionedWidget(double scaleFactor) {
    return Positioned(
        top: top * scaleFactor,
        left: left * scaleFactor,
        child: GestureDetector(
            onTap: () {
              print("$id pressed!");
            },
            child: Container(
                width: width * scaleFactor,
                height: height * scaleFactor,
                color: Color.fromARGB(200, 255, 255, 255))));
  }
}

class _AutoPathSelectorState extends State<AutoPathSelector> {
  double margin = 10;
  double bottomOffset = 100;
  String imageFilePath = "assets/images/rebuildFieldMap.png";
  late final AssetImage fieldImage;
  double rawImageWidth = 464;
  double rawImageHeight = 647;

  double get width => 300; // The intended width of the widget
  double get height => width * rawImageHeight / rawImageWidth + bottomOffset;

  double get imageWidth => width - 2 * margin;
  double get imageHeight => imageWidth * rawImageHeight / rawImageWidth;
  double get nodeScaleFactor => imageWidth / rawImageWidth;

  List<Node> specialLocationNodes = [
    Node(id: "depot", top: 148, left: 14, width: 86, height: 78),
    Node(id: "outpost", top: 527, left: 0, width: 56, height: 70),
    Node(id: "tower", top: 302, left: 14, width: 120, height: 87),
    Node(id: "trench_depot", top: 34, left: 337, width: 91, height: 108),
    Node(id: "bump_depot", top: 142, left: 337, width: 91, height: 136),
    Node(id: "bump_outpost", top: 369, left: 337, width: 91, height: 136),
    Node(id: "trench_outpost", top: 506, left: 337, width: 91, height: 108),
  ];

  List<Positioned> generateWidgetsFromNodes(List<Node> nodes, double scaleFactor) {
    List<Positioned> widgets = [];
    for (Node node in nodes) {
      widgets.add(node.generatePositionedWidget(scaleFactor));
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    print(nodeScaleFactor);
    fieldImage = AssetImage(imageFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        color: Constants.pastelWhite,
      ),
      child: Center(
        child: Container(
          width: imageWidth,
          height: imageHeight,
          decoration: BoxDecoration(
              color: Constants.neonBlue,
              image: DecorationImage(
                  image: fieldImage,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Constants.pastelRed, BlendMode.modulate))),
          child:
              Stack(children: generateWidgetsFromNodes(specialLocationNodes, nodeScaleFactor)),
        ),
      ),
    );
  }
}
