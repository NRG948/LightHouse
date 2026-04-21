import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/box_region.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/dropdown.dart';

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
  final bool flip;

  const VisualNode({
    super.key,
    required this.radius,
    this.color,
    this.borderWidth = 0,
    this.borderColor = Colors.black,
    required this.text,
    this.textColor,
    this.flip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: flip ? pi : 0,
      child: Container(
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

  final Color? mainColor;
  final Color? backgroundColor;
  final Color? startNodeColor;
  final Color? allianceZoneNodeColor;
  final Color? regionNodeColor;
  final Color? lockedColor;
  final Color? textColor;

  final bool debug;
  final bool canStartInZone;
  final bool flipField;

  /// If the widget is used in pit scouting.
  ///
  /// If ```true```, labels will be changed to present tense instead of past tense.
  /// Climb levels or climb success will not be shown even if [showDetails] is ```true```.
  final bool pit;

  /// If auto details should be shown.
  ///
  /// If ```true```, options will be given about whether preload is scored,
  /// whether climb was attempted, and the climb result.
  final bool showDetails;

  /// The list of possible climb results in auto.
  ///
  /// The options will be displayed in a dropdown that is unlocked when "Attempted Climb" is selected.
  /// If ```null```, the dropdown will be replaced by a checkbox labeled "Climb Successful".
  final List<String>? climbLevels;

  /// Whether the widget is shown for viewing.
  ///
  /// If ```true```, the widget will not be interactive and the undo button and any details will be hidden.
  final bool viewOnly;

  /// The scaling factor of the field map.
  final double imageScalingFactor;

  final double nodeScalingFactor;

  /// The output of [converter] when the pixel offsets of the nodes are passed in is saved to [DataEntry].
  final Offset Function(Offset position, {bool inverse})? converter;

  /// The initial path displayed.
  ///
  /// This is often used in tandum with [viewOnly].
  /// It is a list of [String] and [List\<num\>] representing region IDs and coordinates respectively.
  final List<dynamic>? initialPath;

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
    this.showDetails = false,
    this.flipField = false,
    this.climbLevels,
    this.mainColor,
    this.backgroundColor,
    this.startNodeColor,
    this.allianceZoneNodeColor,
    this.regionNodeColor,
    this.lockedColor,
    this.textColor,
    required this.pit,
    this.converter,
    this.viewOnly = false,
    this.imageScalingFactor = 1,
    this.nodeScalingFactor = 1,
    this.initialPath,
  });

  /// Returns a conversion function that transforms coordinates between a Pixel system
  /// and a Field system based on two anchor points.
  ///
  /// * Set [inverse] to `false` (default) to convert Pixels to Field units.
  /// * Set [inverse] to `true` to convert Field units back to Pixels.
  ///
  /// Note: Anchor points must not share the same X or Y values in either system.
  static Offset Function(Offset position, {bool inverse})
      getConverterFromPoints(
    Offset p1,
    Offset f1,
    Offset p2,
    Offset f2,
  ) {
    final double scaleX = (f2.dx - f1.dx) / (p2.dx - p1.dx);
    final double scaleY = (f2.dy - f1.dy) / (p2.dy - p1.dy);

    final double invScaleX = 1.0 / scaleX;
    final double invScaleY = 1.0 / scaleY;

    return (Offset pos, {bool inverse = false}) {
      return inverse
          ? Offset((pos.dx - f1.dx) * invScaleX + p1.dx,
              (pos.dy - f1.dy) * invScaleY + p1.dy)
          : Offset((pos.dx - p1.dx) * scaleX + f1.dx,
              (pos.dy - p1.dy) * scaleY + f1.dy);
    };
  }

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
      _width * _imageScaingFactor * _rawImageHeight / _rawImageWidth +
      (_viewOnly ? 0 : _bottomOffset) +
      5; // 5 extra pixels for safety

  double get _imageScaingFactor => widget.imageScalingFactor;

  double get _imageWidth => _imageScaingFactor * _width - 2 * _margin;
  double get _imageHeight => _imageWidth * _rawImageHeight / _rawImageWidth;
  double get _scaleFactor => _imageWidth / _rawImageWidth;

  double get _margin => widget.margin ?? _width / 25;
  double get _bottomOffset => _pit ? _width * 0.225 : _width * 0.35;

  double get _nodeRadius => _imageWidth / 17;
  double get _nodeBorderWidth => _width / 100;
  double get _nodeScalingFactor => widget.nodeScalingFactor;
  int get _maximumGroupSize => widget.maximumGroupSize;

  Offset Function(Offset pixelPosition, {bool inverse})? get _converter =>
      widget.converter;

  List<dynamic>? get _initialPath => widget.initialPath;

  double get _buttonSize =>
      _bottomOffset -
      _margin; // TODO: make in terms of height AND width, to make sure no overflow

  final List<NodeData> _nodeStack = [];
  final List<UserAction> _history = [];

  Color? get _mainColor => widget.mainColor;
  Color? get _backgroundColor => widget.backgroundColor;
  Color? get _startNodeColor => widget.startNodeColor;
  Color? get _allianceZoneNodeColor => widget.allianceZoneNodeColor;
  Color? get _regionNodeColor => widget.regionNodeColor;
  Color? get _lockedColor => widget.lockedColor;
  Color? get _textColor => widget.textColor;

  bool get _flipField => widget.flipField;

  bool get _debug => widget.debug;
  bool get _canStartInZone => widget.canStartInZone;
  bool get _showDetails => widget.showDetails;
  bool get _pit => widget.pit;
  List<String>? get _climbLevels => widget.climbLevels;
  bool _attemptedClimb = false;
  bool _shotPreload = false;
  bool? _climbSuccessful;
  String? _climbLevel;

  bool get _viewOnly => widget.viewOnly;

  List<Zone> get _zones => widget.zones;

  @override
  void initState() {
    super.initState();
    _fieldImage = AssetImage(_imageFieldPath);
    if (_climbLevels == null) _climbSuccessful = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _resetToInitialPath();
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _serializeData();
  }

  void _resetToInitialPath() {
    while (_nodeStack.isNotEmpty) {
      _nodeStack.removeLast();
      _history.removeLast();
    }
    if (_initialPath != null) {
      for (dynamic node in _initialPath!) {
        switch (node) {
          case [num x, num y]:
            Offset pixelPosition = Offset(x.toDouble(), y.toDouble());
            addNodeFromMap((_converter == null
                    ? pixelPosition
                    : _converter!(pixelPosition, inverse: true)) *
                _scaleFactor);

          case String region:
            addNodeFromRegion(region);

          default:
            break;
        }
      }
    }
  }

  void _serializeData() {
    if (_jsonKey == null || _viewOnly) return;

    Map<String, dynamic> data = {};

    // each element can either be a string or another list for x-y coords
    List<dynamic> positions = List.empty(growable: true);
    for (NodeData node in _nodeStack) {
      if (node.groupLabel != null) {
        positions.add(node.groupLabel);
      } else {
        double pixelX = node.position!.dx / _scaleFactor;
        double pixelY = node.position!.dy / _scaleFactor;

        if (_converter == null) {
          positions.add([pixelX, pixelY]);
        } else {
          Offset convertedOffset =
              _converter!(Offset(pixelX, pixelY), inverse: false);
          positions.add([convertedOffset.dx, convertedOffset.dy]);
        }
      }
    }

    data["path"] = positions;
    data["attemptedClimb"] = _attemptedClimb;
    data["climbSuccessful"] = _climbSuccessful;
    data["climbLevel"] = _climbLevel;
    data["shotPreload"] = _shotPreload;

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
        node.radius = _nodeRadius * _nodeScalingFactor -
            ((numNodes - 1) * 1.5); // TODO: tweak based on testing

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
  VisualNode buildVisualNode(NodeData node, int index, bool flip) {
    return VisualNode(
      radius: node.radius,
      color: node.color,
      borderColor: context.colors.container,
      borderWidth: _nodeBorderWidth,
      text: "${index + 1}",
      textColor: context.colors.container,
      flip: flip,
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
                  feedback: Opacity(
                      opacity: 0.5, child: buildVisualNode(node, i, false)),
                  childWhenDragging: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Colors.grey, BlendMode.modulate),
                      child: buildVisualNode(node, i, _flipField)),
                  child: buildVisualNode(node, i, _flipField),
                  onDragEnd: (details) {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final Offset localPosition = renderBox
                              .globalToLocal(details.offset) -
                          Offset(0.5 * (1 - _imageScaingFactor) * _width, 0);

                      Offset newPosition =
                          localPosition + Offset(node.radius, node.radius) / 2;

                      if (_flipField) {
                        newPosition = Offset(_imageWidth - newPosition.dx,
                            _imageHeight - newPosition.dy);
                      }

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

  NodeData addNodeFromRegion(String groupLabel) {
    NodeData newNode = NodeData(
      groupLabel: groupLabel,
      radius: _nodeRadius * _nodeScalingFactor,
      draggable: false,
      color: _regionNodeColor ?? context.colors.accent4,
    );
    _nodeStack.add(newNode);
    _history.add(UserAction(
        actionType: UserActionType.place,
        nodeIndice: _nodeStack.length - 1,
        coordinates: Offset
            .zero)); // Very hacky, I know, but it literally does not matter
    return newNode;
  }

  NodeData addNodeFromMap(Offset position) {
    NodeData newNode = NodeData(
        position: position,
        radius: _nodeRadius * _nodeScalingFactor,
        draggable: true,
        color: _nodeStack.isEmpty
            ? _startNodeColor ?? context.colors.confirm
            : _allianceZoneNodeColor ?? context.colors.accent2);
    _nodeStack.add(newNode);
    _history.add(UserAction(
        actionType: UserActionType.place,
        nodeIndice: _nodeStack.length - 1,
        coordinates: Offset.zero)); // Refer to the comment about hackiness
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
            addNodeFromRegion(groupLabel);
          });
        },
      ));
    }

    return regions;
  }

  Widget _getAutoDetails() {
    if (!_showDetails) {
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
        color: _mainColor ?? context.colors.accent1,
        textColor: _textColor ?? context.colors.text,
        lockedColor: _lockedColor ?? context.colors.locked,
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
            title: _pit ? "Scores Preload" : "Scored Preload",
            onToggle: (value) {
              setState(() {
                _shotPreload = value;
                _serializeData();
              });
            },
          )),
          Expanded(
              child: CustomCheckbox(
            selectColor: _backgroundColor,
            optionColor: _mainColor,
            lockedColor: _lockedColor,
            textColor: _textColor,
            title: _pit ? "Attempts Climb" : "Attempted Climb",
            onToggle: (value) {
              setState(() {
                _attemptedClimb = value;
                _serializeData();
              });
            },
          )),
          _pit ? Container() : Expanded(child: climbOutcome),
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
            color: _backgroundColor ?? context.colors.container,
            strokeWidth: _nodeBorderWidth));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        if (_viewOnly) _resetToInitialPath();
        setPositionsForGroupedNodes();

        return IgnorePointer(
          ignoring: _viewOnly,
          child: Center(
            child: Container(
              width: _width,
              height: _height,
              padding: EdgeInsets.all(_margin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_margin),
                color: _backgroundColor ?? context.colors.container,
              ),
              child: Column(
                spacing: _margin,
                children: [
                  Center(
                    child: Transform.rotate(
                      angle: _flipField ? pi : 0,
                      child: Container(
                        width: _imageWidth,
                        height: _imageHeight,
                        decoration: BoxDecoration(
                          color: _mainColor ?? context.colors.accent1,
                          borderRadius: BorderRadius.circular(_margin),
                          image: DecorationImage(
                            image: _fieldImage,
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              _backgroundColor ?? context.colors.container,
                              BlendMode.modulate,
                            ),
                          ),
                        ),
                        child: Semantics(
                          button: true,
                          child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onHorizontalDragStart: (details) {},
                              onTapUp: (TapUpDetails details) {
                                setState(() {
                                  HapticFeedback.mediumImpact();
                                  addNodeFromMap(details.localPosition);
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
                  ),
                  if (!_viewOnly)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: _margin,
                      children: [
                        _getAutoDetails(),
                        Container(
                          width: _buttonSize,
                          height: _buttonSize,
                          decoration: BoxDecoration(
                              color: context.colors.delete,
                              borderRadius:
                                  BorderRadius.circular(_buttonSize / 4)),
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
                            highlightColor: context.colors.delete,
                            icon: Icon(
                              Icons.undo_rounded,
                              color: context.colors.container,
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
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
