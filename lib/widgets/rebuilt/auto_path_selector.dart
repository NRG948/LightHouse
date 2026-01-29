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
  final Color? color;
  final String text;
  final Color? textColor;

  const CircleLabelIcon(
      {super.key,
      required this.radius,
      this.color,
      required this.text,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
            child: DefaultTextStyle(
                style: comfortaaBold(fontSizeToRadiusRatio * radius,
                    color: textColor),
                child: Text(
                  text,
                ))));
  }
}

class Node extends StatefulWidget {
  final String label;
  final int index;
  final double top;
  final double left;
  final double radius;
  final Color? color;
  final bool draggable;
  final Function(Node self, DraggableDetails details, Offset localEndPosition,
      Offset dragOffset) onDragEnd;
  final Function(Node self, Offset position) onPositionUpdate;
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
      required this.label,
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
      this.onDragEnd = _onDragEndNoop,
      this.onPositionUpdate = _onPositionUpdateNoop})
      : assert(
          color == null || iconBuilder == null,
          'NodeIcon: color and iconBuilder are mutually exclusive.',
        );

  static void _onDragEndNoop(Node self, DraggableDetails details,
      Offset localEndPosition, Offset dragOffset) {}

  static void _onPositionUpdateNoop(Node self, Offset position) {}

  Node copyNodeWithNewLocalIndex(int newGroupIndex, int newGroupTotal) {
    return Node(
      key: super.key,
      label: label,
      index: index,
      top: top,
      left: left,
      radius: radius,
      color: color,
      iconBuilder: iconBuilder,
      draggable: draggable,
      groupIndex: newGroupIndex,
      groupTotal: newGroupTotal,
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
  bool get _draggable => widget.draggable;
  double get _scaledRadius => widget.scaledRadius;
  Function(Node self, DraggableDetails details, Offset localEndPosition,
      Offset dragOffset) get _onDragEnd => widget.onDragEnd;
  Function(Node self, Offset position) get _onPositionUpdate =>
      widget.onPositionUpdate;
  NodeIconBuilder get _iconBuilder => widget.iconBuilder ?? _defaultIconBuilder;

  Offset _dragOffset = Offset.zero;
  Offset get _center => widget.visualCenter(_dragOffset);

  Widget _defaultIconBuilder(BuildContext context, String text) {
    return CircleLabelIcon(
        color: _color,
        textColor: Colors.white,
        text: text,
        radius: _scaledRadius);
  }

  @override
  void initState() {
    super.initState();
    _onPositionUpdate(widget, widget.visualCenter(_dragOffset));
  }

  @override
  void didUpdateWidget(Node oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onPositionUpdate(widget, widget.visualCenter(_dragOffset));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _center.dy - _scaledRadius,
        left: _center.dx - _scaledRadius,
        child: IgnorePointer(
          ignoring: !_draggable,
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

                  _onDragEnd(widget, details, widget.visualCenter(_dragOffset),
                      _dragOffset);
                  _onPositionUpdate(widget, widget.visualCenter(_dragOffset));
                });
              },
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
      this.color = const Color.fromARGB(100, 230, 159, 255),
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
        child: GestureDetector(
            onTap: () {
              _onTap(_id, getCenter());
            },
            child: Container(width: _width, height: _height, color: _color)));
  }
}

class AutoPathSelector extends StatefulWidget {
  const AutoPathSelector({super.key});

  @override
  State<AutoPathSelector> createState() => _AutoPathSelectorState();
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
  double get scaleFactor => imageWidth / rawImageWidth;

  double get nodeRadius => width / 20;
  List<Node> nodeStack = [];
  Map<Node, Offset> nodePositions = {};
  Map<Node, Offset> nodeDragOffsets = {};

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

  List<BoxRegion> _getRegions() {
    List<BoxRegion> regions = [];
    for (Zone zone in zones) {
      regions.add(BoxRegion(
        id: zone.id,
        top: zone.top * scaleFactor,
        left: zone.left * scaleFactor,
        width: zone.width * scaleFactor,
        height: zone.height * scaleFactor,
        onTap: (id, center) {
          if (nodeStack.isEmpty) return; // Starting position must be selected

          setState(() {
            List<Node> newNodeStack = [];
            int sameIdNodeCount = 0;
            for (final Node node in nodeStack) {
              if (id != "" && node.label == id) {
                sameIdNodeCount++;
                Node replacementNode = node.copyNodeWithNewLocalIndex(
                    node.groupIndex, node.groupTotal + 1);
                newNodeStack.add(replacementNode);
              } else {
                newNodeStack.add(node);
              }
            }
            Node newNode = Node(
                label: id,
                index: nodeStack.length + 1,
                top: center.dy,
                left: center.dx,
                radius: nodeRadius,
                draggable: false,
                color: Constants.pastelRedDark,
                groupIndex: sameIdNodeCount,
                groupTotal: sameIdNodeCount + 1);
            newNodeStack.add(newNode);
            nodeStack = newNodeStack;
            _rebuildNodeOffsets();
          });
        },
      ));
    }

    return regions;
  }

  void _rebuildNodeOffsets() {
    nodePositions = {};
    for (final Node node in nodeStack) {
      nodePositions[node] =
          node.visualCenter(nodeDragOffsets[node] ?? Offset.zero);
    }
  }

  CustomPaint _getPathPainter() {
    List<Offset> vertices = [];
    for (final Node node in nodeStack) {
      vertices.add(nodePositions[node]!);
    }

    return CustomPaint(painter: PathPainter(vertices: vertices));
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
          child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                setState(() {
                  Node newNode = Node(
                      label: "alliance_zone",
                      index: nodeStack.length + 1,
                      left: details.localPosition.dx,
                      top: details.localPosition.dy,
                      radius: nodeRadius,
                      draggable: true,
                      onDragEnd: (self, details, localEndPosition, dragOffset) {
                        setState(() {
                          nodeDragOffsets[self] = dragOffset;
                          _rebuildNodeOffsets();
                        });
                      },
                      color: nodeStack.isEmpty
                          ? Constants.pastelGreenDark
                          : Constants.pastelBlueDark);
                  nodeStack.add(newNode);
                  _rebuildNodeOffsets();
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
