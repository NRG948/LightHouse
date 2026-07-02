import 'package:flutter/material.dart';

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

class BoxRegion extends StatefulWidget {
  final String id;
  final double width;
  final double height;
  final double top;
  final double left;
  final Color color;
  final bool borderOnly;
  final double borderWidth;
  final Function(String id, Offset center) onTap;

  const BoxRegion(
      {super.key,
      required this.id,
      required this.width,
      required this.height,
      required this.top,
      required this.left,
      this.borderOnly = false,
      this.borderWidth = 1,
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
  bool get _borderOnly => widget.borderOnly;
  double get _borderWidth => widget.borderWidth;
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
            child: Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _borderOnly ? Colors.transparent : _color,
                border: _borderOnly ? Border.all(
                  color: _color,
                  width: _borderWidth,
                ) : null,
              ),
            ),
          ),
        ));
  }
}
