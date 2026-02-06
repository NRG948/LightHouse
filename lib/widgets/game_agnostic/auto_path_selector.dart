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
  final String imageFilePath;
  final double rawImageWidth;
  final double rawImageHeight;
  final double width;
  final int maximumGroupSize;

  final List<Zone> zones;

  final Color mainColor;
  final Color backgroundColor;
  final Color startNodeColor;
  final Color allianceZoneNodeColor;
  final Color regionNodeColor;

  final bool debug;
  final bool canStartInZone;

  const AutoPathSelector(
      {super.key,
      required this.imageFilePath,
      required this.rawImageWidth,
      required this.rawImageHeight,
      required this.width,
      required this.zones,
      this.debug = false,
      this.canStartInZone = false,
      this.maximumGroupSize = 4,
      this.mainColor = Constants.pastelRed,
      this.backgroundColor = Constants.pastelWhite,
      this.startNodeColor = Constants.pastelGreen,
      this.allianceZoneNodeColor = Constants.pastelYellow,
      this.regionNodeColor = Constants.pastelBlue});

  @override
  State<AutoPathSelector> createState() => _AutoPathSelectorState();
}

class _AutoPathSelectorState extends State<AutoPathSelector> {
  late final AssetImage _fieldImage;
  String get _imageFieldPath => widget.imageFilePath ;
  double get _rawImageWidth => widget.rawImageWidth;
  double get _rawImageHeight => widget.rawImageHeight;

  double get _width => widget.width; // The intended width of the widget
  double get _height => _width * _rawImageHeight / _rawImageWidth + _bottomOffset;

  double get _imageWidth => _width - 2 * _margin;
  double get _imageHeight => _imageWidth * _rawImageHeight / _rawImageWidth;
  double get _scaleFactor => _imageWidth / _rawImageWidth;

  double get _margin => _width / 25;
  double get _bottomOffset => _width * 0.2;

  double get _nodeRadius => _width / 18;
  double get _nodeBorderWidth => _width / 100;
  int get _maximumGroupSize => widget.maximumGroupSize;

  double get _buttonSize =>
      _bottomOffset - _margin; // TODO: make in terms of height AND width, to make sure no overflow

  List<Node> _nodeStack = [];
  Map<Node, Offset> _nodePositions = {};
  Map<int, Offset> _nodeDragOffsets = {};

  Color get _mainColor => widget.mainColor;
  Color get _backgroundColor => widget.backgroundColor;
  Color get _startNodeColor => widget.startNodeColor;
  Color get _allianceZoneNodeColor => widget.allianceZoneNodeColor;
  Color get _regionNodeColor => widget.regionNodeColor;

  bool get _debug => widget.debug;
  bool get _canStartInZone => widget.canStartInZone;

  List<Zone> get _zones => widget.zones;

  @override
  void initState() {
    super.initState();
    _fieldImage = AssetImage(_imageFieldPath);
  }

  void removeNode(Node target) {
    if (!_nodeStack.contains(target)) return;

    List<Node> newNodeStack = [];
    for (final Node node in _nodeStack) {
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

    _nodeStack = newNodeStack;
    _recalculateNodeOffsets();
    _nodeDragOffsets.remove(target.index);
  }

  List<Widget> _getNodeOffsetDebugOverlay() {
    double markerWidth = _width / 50;
    List<Widget> overlays = [];
    for (Node node in _nodePositions.keys) {
      overlays.add(Positioned(
          top: _nodePositions[node]!.dy - markerWidth / 2,
          left: _nodePositions[node]!.dx - markerWidth / 2,
          child: Container(width: markerWidth, height: markerWidth, color: Colors.red)));
    }

    return overlays;
  }

  Node addNodeFromRegion(
      String groupLabel, Offset center, int sameIdNodeCount) {
    List<Node> newNodeStack = [];
    for (final Node node in _nodeStack) {
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
        index: _nodeStack.length + 1,
        top: center.dy,
        left: center.dx,
        radius: _nodeRadius,
        draggable: false,
        color: _regionNodeColor,
        borderWidth: _nodeBorderWidth,
        borderColor: _backgroundColor,
        groupIndex: sameIdNodeCount,
        groupTotal: sameIdNodeCount + 1);
    newNodeStack.add(newNode);
    _nodeStack = newNodeStack;
    _recalculateNodeOffsets();

    return newNode;
  }

  Node addNodeFromMap(TapUpDetails details) {
    int index = _nodeStack.length + 1;

    Node newNode = Node(
        index: index,
        left: details.localPosition.dx,
        top: details.localPosition.dy,
        radius: _nodeRadius,
        draggable: true,
        onDragEnd: (self, details, localEndPosition, dragOffset) {
          setState(() {
            _nodeDragOffsets[index] = dragOffset;
            _recalculateNodeOffsets();
          });
        },
        borderWidth: _nodeBorderWidth,
        borderColor: _backgroundColor,
        color: _nodeStack.isEmpty ? _startNodeColor : _allianceZoneNodeColor);
    _nodeStack.add(newNode);
    _recalculateNodeOffsets();

    return newNode;
  }

  List<BoxRegion> _getRegions() {
    List<BoxRegion> regions = [];
    for (Zone zone in _zones) {
      regions.add(BoxRegion(
        id: zone.id,
        top: zone.top * _scaleFactor,
        left: zone.left * _scaleFactor,
        width: zone.width * _scaleFactor,
        height: zone.height * _scaleFactor,
        color: _debug ? Color.fromARGB(99, 67, 189, 155) : Color.fromARGB(1, 255, 255, 255),
        onTap: (groupLabel, center) {
          if (!_canStartInZone && _nodeStack.isEmpty) return;
          int sameIdNodeCount = _nodeStack
              .where((final Node node) => node.groupLabel == groupLabel)
              .length;

          if (sameIdNodeCount >= _maximumGroupSize) return;

          setState(() {
            addNodeFromRegion(groupLabel, center, sameIdNodeCount);
          });
        },
      ));
    }

    return regions;
  }

  void _recalculateNodeOffsets() {
    _nodePositions = {};
    for (final Node node in _nodeStack) {
      _nodePositions[node] =
          node.visualCenter(_nodeDragOffsets[node.index] ?? Offset.zero);
    }
  }

  CustomPaint _getPathPainter() {
    List<Offset> vertices = [];
    for (final Node node in _nodeStack) {
      vertices.add(_nodePositions[node]!);
    }

    return CustomPaint(
        painter: PathPainter(
            vertices: vertices,
            color: _backgroundColor,
            strokeWidth: _nodeBorderWidth));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: EdgeInsets.all(_margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        color: _backgroundColor,
      ),
      child: Column(
        spacing: _margin,
        children: [
          Center(
            child: Container(
              width: _imageWidth,
              height: _imageHeight,
              decoration: BoxDecoration(
                  color: _mainColor,
                  borderRadius: BorderRadius.circular(_margin),
                  image: DecorationImage(
                      image: _fieldImage,
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          _backgroundColor, BlendMode.modulate))),
              child: Semantics(
                button: true,
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (details) {},
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
                          ..._nodeStack,
                          ..._debug ? _getNodeOffsetDebugOverlay() : [Container()],
                        ]))),
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: _margin,
              children: [
                Container(
                  width: _buttonSize,
                  height: _buttonSize,
                  decoration: BoxDecoration(
                      color: Constants.pastelRedDark,
                      borderRadius: BorderRadius.circular(_margin)),
                  child: IconButton(
                      padding: EdgeInsets.all(_margin / 2),
                      onPressed: () {
                        setState(() {
                          if (_nodeStack.isNotEmpty) removeNode(_nodeStack.last);
                        });
                      },
                      iconSize: _buttonSize * 0.7,
                      color: _backgroundColor,
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
