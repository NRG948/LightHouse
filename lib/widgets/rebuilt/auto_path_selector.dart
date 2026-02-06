import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class Zone {
  String id;
  double top;
  double left;
  double width;
  double height;

  Zone(
      {required this.id,
      required this.top,
      required this.left,
      required this.width,
      required this.height});
}

typedef NodeIconBuilder = Widget Function(
  BuildContext context,
  String text,
);

class CircleLabelIcon extends StatelessWidget {
  static final double fontSizeToRadiusRatio = 1.3;

  final double radius;
  final double borderWidth;
  final Color? color;
  final Color borderColor;
  final String text;
  final Color? textColor;

  const CircleLabelIcon(
      {super.key,
      required this.radius,
      this.color,
      this.borderWidth = 0,
      this.borderColor = Colors.black,
      required this.text,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderWidth == 0
                ? null
                : Border.all(color: borderColor, width: borderWidth)),
        child: Center(
            child: DefaultTextStyle(
                style: comfortaaBold(
                    fontSizeToRadiusRatio * (radius - borderWidth),
                    color: textColor),
                child: Text(
                  text,
                ))));
  }
}

class Node extends StatefulWidget {
  final String? groupLabel;
  final int index;
  final double top;
  final double left;
  final double radius;
  final Color? color;
  final Color borderColor;
  final double borderWidth;
  final bool draggable;
  final Function(int index, DraggableDetails details, Offset localEndPosition,
      Offset dragOffset) onDragEnd;
  final Function(int index, Offset position) onPositionUpdate;
  final int groupIndex;
  final int groupTotal;
  final double groupScaling;
  final NodeIconBuilder? iconBuilder;
  double get scaledRadius =>
      radius / ((groupTotal + 1 / groupScaling - 1) * groupScaling);

  Offset baseCenter() => Offset(left, top);

  Offset groupOffset() => Offset(
        0,
        (groupIndex + 0.5 - groupTotal / 2) * 2 * scaledRadius,
      );

  Offset visualCenter(Offset dragOffset) =>
      baseCenter() + groupOffset() + dragOffset;

  const Node(
      {super.key,
      this.groupLabel,
      required this.index,
      required this.top,
      required this.left,
      required this.radius,
      required this.draggable,
      this.iconBuilder,
      this.groupIndex = 0,
      this.groupTotal = 1,
      this.groupScaling = 0.25,
      this.color,
      this.borderColor = Constants.pastelWhite,
      this.borderWidth = 0,
      this.onDragEnd = _onDragEndNoop,
      this.onPositionUpdate = _onPositionUpdateNoop})
      : assert(
          color == null || iconBuilder == null,
          'NodeIcon: color and iconBuilder are mutually exclusive.',
        );

  static void _onDragEndNoop(int index, DraggableDetails details,
      Offset localEndPosition, Offset dragOffset) {}

  static void _onPositionUpdateNoop(int index, Offset position) {}

  Node copyWithNewValues(
      {int? newGroupIndex, int? newGroupTotal, int? newIndex}) {
    return Node(
      key: super.key,
      groupLabel: groupLabel,
      index: newIndex ?? index,
      top: top,
      left: left,
      radius: radius,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      iconBuilder: iconBuilder,
      draggable: draggable,
      groupIndex: newGroupIndex ?? groupIndex,
      groupTotal: newGroupTotal ?? groupTotal,
      groupScaling: groupScaling,
      onDragEnd: onDragEnd,
      onPositionUpdate: onPositionUpdate,
    );
  }

  @override
  String toStringShort() => "Node(index: $index)";

  @override
  State<Node> createState() => _NodeState();
}

class _NodeState extends State<Node> {
  int get _index => widget.index;
  Color? get _color => widget.color;
  Color get _borderColor => widget.borderColor;
  double get _borderWidth => widget.borderWidth;
  bool get _draggable => widget.draggable;
  double get _scaledRadius => widget.scaledRadius;
  Function(int index, DraggableDetails details, Offset localEndPosition,
      Offset dragOffset) get _onDragEnd => widget.onDragEnd;
  Function(int index, Offset position) get _onPositionUpdate =>
      widget.onPositionUpdate;
  NodeIconBuilder get _iconBuilder => widget.iconBuilder ?? _defaultIconBuilder;

  Offset _dragOffset = Offset.zero;
  Offset get _center => widget.visualCenter(_dragOffset);

  Widget _defaultIconBuilder(BuildContext context, String text) {
    return CircleLabelIcon(
        color: _color,
        borderColor: _borderColor,
        borderWidth: _borderWidth,
        textColor: Constants.pastelWhite,
        text: text,
        radius: _scaledRadius);
  }

  @override
  void initState() {
    super.initState();
    _onPositionUpdate(_index, widget.visualCenter(_dragOffset));
  }

  @override
  void didUpdateWidget(Node oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onPositionUpdate(_index, widget.visualCenter(_dragOffset));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _center.dy - _scaledRadius,
        left: _center.dx - _scaledRadius,
        child: IgnorePointer(
          ignoring: !_draggable,
          child: Semantics(
            button: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Draggable(
                maxSimultaneousDrags: _draggable ? 1 : 0,
                feedback: Opacity(
                    opacity: 0.5, child: _iconBuilder(context, "$_index")),
                childWhenDragging: ColorFiltered(
                    colorFilter:
                        const ColorFilter.mode(Colors.grey, BlendMode.modulate),
                    child: _iconBuilder(context, "$_index")),
                child: _iconBuilder(context, "$_index"),
                onDragEnd: (details) {
                  setState(() {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final Offset localOffsetDifference =
                        renderBox.globalToLocal(details.offset);
                    _dragOffset += localOffsetDifference;

                    _onDragEnd(_index, details,
                        widget.visualCenter(_dragOffset), _dragOffset);
                    _onPositionUpdate(_index, widget.visualCenter(_dragOffset));
                  });
                },
              ),
            ),
          ),
        ));
  }
}

class BoxRegion extends StatefulWidget {
  final String id;
  final double width;
  final double height;
  final double top;
  final double left;
  final Color color;
  final Function(String id, Offset center) onTap;

  const BoxRegion(
      {super.key,
      required this.id,
      required this.width,
      required this.height,
      required this.top,
      required this.left,
      this.color = const Color.fromARGB(1, 255, 255, 255),
      this.onTap = _noop});

  static void _noop(String _, Offset __) {}

  @override
  State<BoxRegion> createState() => _BoxRegionState();

  @override
  String toStringShort() => "${runtimeType.toString()}(id: $id)";
}

class _BoxRegionState extends State<BoxRegion> {
  String get _id => widget.id;
  double get _width => widget.width;
  double get _height => widget.height;
  double get _top => widget.top;
  double get _left => widget.left;
  Color get _color => widget.color;
  Function(String id, Offset center) get _onTap => widget.onTap;

  Offset getCenter() => Offset(_left + _width / 2, _top + _height / 2);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _top,
        left: _left,
        child: Semantics(
          button: true,
          child: GestureDetector(
              onTap: () {
                _onTap(_id, getCenter());
              },
              child: Container(width: _width, height: _height, color: _color)),
        ));
  }
}

class AutoPathSelector extends StatefulWidget {
  const AutoPathSelector({super.key});

  @override
  State<AutoPathSelector> createState() => _AutoPathSelectorState();
}

class _AutoPathSelectorState extends State<AutoPathSelector> {
  double get margin => width / 25;
  double get bottomOffset => width * 0.2;
  String imageFilePath = "assets/images/rebuildFieldMap.png";
  late final AssetImage fieldImage;
  double rawImageWidth = 464;
  double rawImageHeight = 647;

  double get width => 300; // The intended width of the widget
  double get height => width * rawImageHeight / rawImageWidth + bottomOffset;

  double get buttonSize =>
      width /
      10; // TODO: make in terms of height AND width, to make sure no overflow

  double get nodeBorderWidth => width / 100;
  double get imageWidth => width - 2 * margin;
  double get imageHeight => imageWidth * rawImageHeight / rawImageWidth;
  double get scaleFactor => imageWidth / rawImageWidth;

  double get nodeRadius => width / 18;
  int maximumGroupSize = 4;
  List<Node> nodeStack = [];
  Map<Node, Offset> nodePositions = {};
  Map<int, Offset> nodeDragOffsets = {};

  Color mainColor = Constants.pastelRed;
  Color backgroundColor = Constants.pastelWhite;

  Color startNodeColor = Constants.pastelGreen;
  Color allianceZoneNodeColor = Constants.pastelYellow;
  Color regionNodeColor = Constants.pastelBlue;

  final List<Zone> zones = [
    Zone(id: "depot", top: 148, left: 14, width: 86, height: 78),
    Zone(id: "outpost", top: 527, left: 0, width: 56, height: 70),
    Zone(id: "tower", top: 302, left: 14, width: 120, height: 87),
    Zone(id: "trench_depot", top: 34, left: 337, width: 91, height: 108),
    Zone(id: "bump_depot", top: 142, left: 337, width: 91, height: 136),
    Zone(id: "bump_outpost", top: 369, left: 337, width: 91, height: 136),
    Zone(id: "trench_outpost", top: 506, left: 337, width: 91, height: 108),
  ];

  @override
  void initState() {
    super.initState();
    fieldImage = AssetImage(imageFilePath);
  }

  void removeNode(Node target) {
    if (!nodeStack.contains(target)) return;

    List<Node> newNodeStack = [];
    for (final Node node in nodeStack) {
      if (node == target) continue;

      Node replacementNode = node.copyWithNewValues(
          newGroupIndex: node.groupLabel != null &&
                  node.groupLabel == target.groupLabel &&
                  node.groupIndex > target.groupIndex
              ? node.groupIndex - 1
              : node.groupIndex,
          newGroupTotal:
              node.groupLabel != null && node.groupLabel == target.groupLabel
                  ? node.groupTotal - 1
                  : node.groupTotal,
          newIndex: node.index > target.index ? node.index - 1 : node.index);
      newNodeStack.add(replacementNode);
    }

    nodeStack = newNodeStack;
    _recalculateNodeOffsets();
    nodeDragOffsets.remove(target.index);
  }

  // ignore: unused_element
  List<Widget> _getNodeOffsetDebugOverlay() {
    List<Widget> overlays = [];
    for (Node node in nodePositions.keys) {
      overlays.add(Positioned(
          top: nodePositions[node]!.dy,
          left: nodePositions[node]!.dx,
          child: Container(width: 10, height: 10, color: Colors.red)));
    }

    return overlays;
  }

  Node addNodeFromRegion(
      String groupLabel, Offset center, int sameIdNodeCount) {
    List<Node> newNodeStack = [];
    for (final Node node in nodeStack) {
      if (node.groupLabel == groupLabel) {
        Node replacementNode =
            node.copyWithNewValues(newGroupTotal: node.groupTotal + 1);
        newNodeStack.add(replacementNode);
      } else {
        newNodeStack.add(node);
      }
    }

    Node newNode = Node(
        groupLabel: groupLabel,
        index: nodeStack.length + 1,
        top: center.dy,
        left: center.dx,
        radius: nodeRadius,
        draggable: false,
        color: regionNodeColor,
        borderWidth: nodeBorderWidth,
        borderColor: backgroundColor,
        groupIndex: sameIdNodeCount,
        groupTotal: sameIdNodeCount + 1);
    newNodeStack.add(newNode);
    nodeStack = newNodeStack;
    _recalculateNodeOffsets();

    return newNode;
  }

  Node addNodeFromMap(TapUpDetails details) {
    int index = nodeStack.length + 1;

    Node newNode = Node(
        index: index,
        left: details.localPosition.dx,
        top: details.localPosition.dy,
        radius: nodeRadius,
        draggable: true,
        onDragEnd: (self, details, localEndPosition, dragOffset) {
          setState(() {
            nodeDragOffsets[index] = dragOffset;
            _recalculateNodeOffsets();
          });
        },
        borderWidth: nodeBorderWidth,
        borderColor: backgroundColor,
        color: nodeStack.isEmpty
            ? startNodeColor
            : allianceZoneNodeColor);
    nodeStack.add(newNode);
    _recalculateNodeOffsets();

    return newNode;
  }

  List<BoxRegion> _getRegions() {
    List<BoxRegion> regions = [];
    for (Zone zone in zones) {
      regions.add(BoxRegion(
        id: zone.id,
        top: zone.top * scaleFactor,
        left: zone.left * scaleFactor,
        width: zone.width * scaleFactor,
        height: zone.height * scaleFactor,
        onTap: (groupLabel, center) {
          if (nodeStack.isEmpty) return; // Starting position must be selected
          int sameIdNodeCount = nodeStack
              .where((final Node node) => node.groupLabel == groupLabel)
              .length;

          if (sameIdNodeCount >= maximumGroupSize) return;

          setState(() {
            addNodeFromRegion(groupLabel, center, sameIdNodeCount);
          });
        },
      ));
    }

    return regions;
  }

  void _recalculateNodeOffsets() {
    nodePositions = {};
    for (final Node node in nodeStack) {
      nodePositions[node] =
          node.visualCenter(nodeDragOffsets[node.index] ?? Offset.zero);
    }
  }

  CustomPaint _getPathPainter() {
    List<Offset> vertices = [];
    for (final Node node in nodeStack) {
      vertices.add(nodePositions[node]!);
    }

    return CustomPaint(painter: PathPainter(vertices: vertices, color: backgroundColor, strokeWidth: nodeBorderWidth));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        color: backgroundColor,
      ),
      child: Column(
        spacing: margin,
        children: [
          Center(
            child: Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(margin),
                  image: DecorationImage(
                      image: fieldImage,
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          backgroundColor, BlendMode.modulate))),
              child: Semantics(
                button: true,
                child: GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        addNodeFromMap(details);
                      });
                    },
                    child: Container(
                        color: Color.fromARGB(1, 255, 255, 255),
                        child: Stack(children: [
                          ..._getRegions(),
                          _getPathPainter(),
                          ...nodeStack,
                        ]))),
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: margin,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Constants.pastelRedDark,
                      borderRadius: BorderRadius.circular(margin)),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (nodeStack.isNotEmpty) removeNode(nodeStack.last);
                        });
                      },
                      iconSize: buttonSize,
                      color: backgroundColor,
                      highlightColor: Constants.pastelRedSuperDark,
                      icon: const Icon(Icons.undo_rounded)),
                )
              ])
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> vertices;
  final double strokeWidth;
  final Color color;

  const PathPainter(
      {required this.vertices,
      this.strokeWidth = 3,
      this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = PointMode.polygon;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, vertices, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
