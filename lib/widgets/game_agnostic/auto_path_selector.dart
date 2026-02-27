import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/dropdown.dart';

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

class VisualNode extends StatelessWidget {
  static final double fontSizeToRadiusRatio = 1.3;

  final double radius;
  final double borderWidth;
  final Color? color;
  final Color borderColor;
  final String text;
  final Color? textColor;

  const VisualNode(
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
          style: comfortaaBold(fontSizeToRadiusRatio * (radius - borderWidth),
              color: textColor),
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}

class NodeData {
  /// note that [groupLabel] *always* takes precedence over this.
  /// if [groupLabel] exists, position **should not** be serialized.
  /// (if it's part of a group, position is used for display position *inside* that zone,
  /// meaning it's absolutely useless for export)
  Offset? position;
  Color color;
  bool draggable;
  double radius;
  String? groupLabel;

  NodeData(
      {this.position,
      required this.color,
      required this.radius,
      required this.draggable,
      this.groupLabel});
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

class UserAction {
  UserActionType actionType;
  int nodeIndice;

  /// deliberately vague name as this could be position or movement
  Offset coordinates;

  UserAction(
      {required this.actionType,
      required this.nodeIndice,
      required this.coordinates});
}

// note that each type of action must be handled by the undo function
enum UserActionType {
  move,
  place,
}

class AutoPathSelector extends StatefulWidget {
  final String imageFilePath;
  final double rawImageWidth;
  final double rawImageHeight;
  final int maximumGroupSize;

  final String? jsonKey;

  final double? margin;

  final List<Zone> zones;

  final Color mainColor;
  final Color backgroundColor;
  final Color startNodeColor;
  final Color allianceZoneNodeColor;
  final Color regionNodeColor;
  final Color lockedColor;
  final Color textColor;

  final bool debug;
  final bool canStartInZone;

  final bool showClimbOptions;
  final List<String>? climbLevels;

  const AutoPathSelector({
    super.key,
    required this.imageFilePath,
    required this.rawImageWidth,
    required this.rawImageHeight,
    required this.zones,
    exportLocation,
    this.jsonKey,
    this.margin,
    this.debug = false,
    this.canStartInZone = false,
    this.maximumGroupSize = 4,
    this.showClimbOptions = false,
    this.climbLevels,
    this.mainColor = Constants.pastelRed,
    this.backgroundColor = Constants.pastelWhite,
    this.startNodeColor = Constants.pastelGreen,
    this.allianceZoneNodeColor = Constants.pastelYellow,
    this.regionNodeColor = Constants.pastelBlue,
    this.lockedColor = Constants.pastelGray,
    this.textColor = Constants.pastelBrown,
  });

  @override
  State<AutoPathSelector> createState() => _AutoPathSelectorState();
}

class _AutoPathSelectorState extends State<AutoPathSelector>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final AssetImage _fieldImage;
  String get _imageFieldPath => widget.imageFilePath;
  double get _rawImageWidth => widget.rawImageWidth;
  double get _rawImageHeight => widget.rawImageHeight;

  String? get _jsonKey => widget.jsonKey;

  late double _width;
  double get _height =>
      _width * _imageScaingFactor * _rawImageHeight / _rawImageWidth + _bottomOffset;

  final double _imageScaingFactor = 0.75;

  double get _imageWidth => _imageScaingFactor * _width - 2 * _margin;
  double get _imageHeight => _imageWidth * _rawImageHeight / _rawImageWidth;
  double get _scaleFactor => _imageWidth / _rawImageWidth;

  double get _margin => widget.margin ?? _width / 25;
  double get _bottomOffset => _width * 0.25;

  double get _nodeRadius => _width / 18;
  double get _nodeBorderWidth => _width / 100;
  int get _maximumGroupSize => widget.maximumGroupSize;

  double get _buttonSize =>
      _bottomOffset -
      _margin; // TODO: make in terms of height AND width, to make sure no overflow

  List<NodeData> _nodeStack = [];
  List<UserAction> _history = [];

  Color get _mainColor => widget.mainColor;
  Color get _backgroundColor => widget.backgroundColor;
  Color get _startNodeColor => widget.startNodeColor;
  Color get _allianceZoneNodeColor => widget.allianceZoneNodeColor;
  Color get _regionNodeColor => widget.regionNodeColor;
  Color get _lockedColor => widget.lockedColor;
  Color get _textColor => widget.textColor;

  bool get _debug => widget.debug;
  bool get _canStartInZone => widget.canStartInZone;
  bool get _showClimbOptions => widget.showClimbOptions;
  List<String>? get _climbLevels => widget.climbLevels;
  bool _attemptedClimb = false;
  bool? _climbSuccessful;
  String? _climbLevel;

  List<Zone> get _zones => widget.zones;

  @override
  void initState() {
    super.initState();
    _fieldImage = AssetImage(_imageFieldPath);
    if (_climbLevels == null) _climbSuccessful = false;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _serializeData();
  }

  void _serializeData() {
    if (_jsonKey == null) return;

    Map<String, dynamic> data ={};

    // each element can either be a string or another list for x-y coords
    List<dynamic> positions = List.empty(growable: true);
    for (NodeData node in _nodeStack) {
      if (node.groupLabel != null) {
        positions.add(node.groupLabel);
      } else {
        positions.add([node.position!.dx, node.position!.dy]);
      }
    }

    data["path"] = positions;
    data["attemptedClimb"] = _attemptedClimb;
    data["climbSuccessful"] = _climbSuccessful;
    data["climbLevel"] = _climbLevel;

    DataEntry.exportData[_jsonKey!] = data;
  }

  void setPositionsForGroupedNodes() {
    for (Zone zone in _zones) {
      int i = 0;
      int numNodes = _nodeStack
          .where((final NodeData node) => node.groupLabel == zone.id)
          .length;
      for (NodeData node in _nodeStack
          .where((final NodeData node) => node.groupLabel == zone.id)) {
        node.radius =
            _nodeRadius - ((numNodes - 1) * 3); // TODO: tweak based on testing

        final scaledLeft = zone.left * _scaleFactor;
        final scaledTop = zone.top * _scaleFactor;
        final scaledWidth = zone.width * _scaleFactor;
        final scaledHeight = zone.height * _scaleFactor;

        node.position = Offset(
          scaledLeft + (scaledWidth / 2),
          scaledTop +
              (scaledHeight / 2) +
              (i + 0.5 - numNodes / 2) * 2 * node.radius,
        );

        i++;
      }
    }
  }

  /// note that index is 0-based (adds one in the function itself)
  VisualNode buildVisualNode(NodeData node, int index) {
    return VisualNode(
      radius: node.radius,
      color: node.color,
      borderColor: Constants.pastelWhite,
      borderWidth: _nodeBorderWidth,
      text: "${index + 1}",
      textColor: Constants.pastelWhite,
    );
  }

  List<Widget> buildNodeDebugCenters() {
    double debugMarkerWidth = 10;
    List<Widget> widgets = [];

    if (!_debug) {
      return widgets;
    }

    for (int i = 0; i < _nodeStack.length; i++) {
      NodeData node = _nodeStack[i];
      widgets.add(
        Positioned(
          top: node.position!.dy - debugMarkerWidth / 2,
          left: node.position!.dx - debugMarkerWidth / 2,
          child: IgnorePointer(
            child: Container(
              width: debugMarkerWidth,
              height: debugMarkerWidth,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  /// Returns a list of widgets that are the (possibly) draggable nodes to be displayed
  List<Widget> buildNodes() {
    List<Widget> widgets = List.empty(growable: true);

    for (int i = 0; i < _nodeStack.length; i++) {
      NodeData node = _nodeStack[i];
      widgets.add(Positioned(
          top: node.position!.dy - node.radius,
          left: node.position!.dx - node.radius,
          child: IgnorePointer(
            ignoring: !node.draggable,
            child: Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Draggable(
                  maxSimultaneousDrags: node.draggable ? 1 : 0,
                  feedback:
                      Opacity(opacity: 0.5, child: buildVisualNode(node, i)),
                  childWhenDragging: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Colors.grey, BlendMode.modulate),
                      child: buildVisualNode(node, i)),
                  child: buildVisualNode(node, i),
                  onDragEnd: (details) {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final Offset localPosition =
                          renderBox.globalToLocal(details.offset);

                      Offset newPosition =
                          localPosition + Offset(node.radius, node.radius) / 2;

                      _history.add(UserAction(
                          actionType: UserActionType.move,
                          nodeIndice: i,
                          // I can use bang operator here b/c only non-grouped nodes can be dragged
                          coordinates: newPosition - node.position!));

                      node.position = newPosition;
                    });
                  },
                ),
              ),
            ),
          )));
    }

    return widgets;
  }

  void undo() {
    UserAction action = _history[_history.length - 1];
    UserActionType actionType = action.actionType;
    setState(() {
      HapticFeedback.mediumImpact();
      if (actionType == UserActionType.place) {
        _nodeStack.removeLast();
      } else if (actionType == UserActionType.move) {
        // use of bang operator is ok because only *non-grouped* nodes can be moved
        _nodeStack[action.nodeIndice].position =
            _nodeStack[action.nodeIndice].position! - action.coordinates;
      }
      _history.removeLast();
    });
  }

  NodeData addNodeFromRegion(String groupLabel, Offset position) {
    NodeData newNode = NodeData(
      groupLabel: groupLabel,
      radius: _nodeRadius,
      draggable: false,
      color: _regionNodeColor,
    );
    _nodeStack.add(newNode);
    _history.add(UserAction(
        actionType: UserActionType.place,
        nodeIndice: _nodeStack.length - 1,
        coordinates: Offset
            .zero)); // Very hacky, I know, but it literally does not matter

    setState(() {});
    return newNode;
  }

  NodeData addNodeFromMap(TapUpDetails details) {
    NodeData newNode = NodeData(
        position: details.localPosition,
        radius: _nodeRadius,
        draggable: true,
        color: _nodeStack.isEmpty ? _startNodeColor : _allianceZoneNodeColor);
    _nodeStack.add(newNode);
    _history.add(UserAction(
        actionType: UserActionType.place,
        nodeIndice: _nodeStack.length - 1,
        coordinates: Offset.zero)); // Refer to the comment about hackiness

    setState(() {});
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
        color: _debug
            ? Color.fromARGB(99, 67, 189, 155)
            : Color.fromARGB(1, 255, 255, 255),
        onTap: (groupLabel, center) {
          if (!_canStartInZone && _nodeStack.isEmpty) return;
          HapticFeedback.mediumImpact();
          int sameIdNodeCount = _nodeStack
              .where((final NodeData node) => node.groupLabel == groupLabel)
              .length;

          if (sameIdNodeCount >= _maximumGroupSize) return;

          setState(() {
            addNodeFromRegion(groupLabel, center);
          });
        },
      ));
    }

    return regions;
  }

  Widget _getClimbOptions() {
    if (!_showClimbOptions) {
      return Container();
    }

    Widget climbOutcome;
    if (_climbLevels == null) {
      climbOutcome = CustomCheckbox(
        selectColor: _backgroundColor,
        optionColor: _mainColor,
        lockedColor: _lockedColor,
        textColor: _textColor,
        title: "Climb Successful",
        isLocked: !_attemptedClimb,
        onToggle: (value) {
          _climbSuccessful = value;
          _serializeData();
        },
      );
    } else {
      climbOutcome = CustomDropdown(
        color: _mainColor,
        textColor: _textColor,
        lockedColor: _lockedColor,
        options: _climbLevels!,
        isLocked: !_attemptedClimb,
        onChanged: (value) {
          _climbLevel = value;
          _serializeData();
        },
      );
    }

    return SizedBox(
      width: _width - _buttonSize - _margin * 3,
      height: _buttonSize,
      child: Column(
        children: [
          Expanded(
              child: CustomCheckbox(
            selectColor: _backgroundColor,
            optionColor: _mainColor,
            lockedColor: _lockedColor,
            textColor: _textColor,
            title: "Attempted Climb",
            onToggle: (value) {
              setState(() {
                _attemptedClimb = value;
                _serializeData();
              });
            },
          )),
          Expanded(child: climbOutcome),
        ],
      ),
    );
  }

  CustomPaint _getPathPainter() {
    List<Offset> vertices = [];
    for (final NodeData node in _nodeStack) {
      vertices.add(node.position!);
    }

    return CustomPaint(
        painter: PathPainter(
            vertices: vertices,
            color: _backgroundColor,
            strokeWidth: _nodeBorderWidth));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        setPositionsForGroupedNodes();

        return Center(
          child: Container(
            width: _width,
            height: _height,
            padding: EdgeInsets.all(_margin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_margin),
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
                              HapticFeedback.mediumImpact();
                              addNodeFromMap(details);
                            });
                          },
                          child: Container(
                              color: Color.fromARGB(1, 255, 255, 255),
                              child: Stack(children: [
                                ..._getRegions(),
                                _getPathPainter(),
                                ...buildNodes(),
                                ...buildNodeDebugCenters(),
                              ]))),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: _margin,
                  children: [
                    _getClimbOptions(),
                    Container(
                      width: _buttonSize,
                      height: _buttonSize,
                      decoration: BoxDecoration(
                          color: Constants.pastelRedDark,
                          borderRadius: BorderRadius.circular(_buttonSize / 4)),
                      child: IconButton(
                          padding: EdgeInsets.all(_buttonSize / 8),
                          onPressed: () {
                            setState(() {
                              if (_nodeStack.isNotEmpty) {
                                undo();
                              }
                            });
                          },
                          iconSize: _buttonSize * 0.7,
                          color: _backgroundColor,
                          highlightColor: Constants.pastelRedSuperDark,
                          icon: const Icon(Icons.undo_rounded)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
