import 'package:flutter/material.dart';
import 'package:lighthouse/models/general/point_data.dart';
import 'package:lighthouse/models/rebuilt/zone_data.dart';

// okay...!
//
// Suffice to say this is a little hacky.
//
// But: base Zone class, then
// different subclasses for different use cases
//
// As always, types triumph everything.

sealed class Zone {
  double top;
  double left;
  double width;
  double height;

  Zone(
      {required this.top,
      required this.left,
      required this.width,
      required this.height});
}

/// Used for auto path selector
class AutoZone extends Zone {
  AutoZoneId id;

  AutoZone(
      {required this.id,
      required super.top,
      required super.left,
      required super.width,
      required super.height});
}

/// Used for Location Tracker widget
class LocationTrackerZone extends Zone {
  LocationZoneId id;

  LocationTrackerZone(
      {required this.id,
      required super.top,
      required super.left,
      required super.width,
      required super.height});
}

/// Used by other widgets to define "boxes" on a map selector.
class BoxRegion extends StatefulWidget {
  final Zone zone;
  final double scaleFactor;
  final Color color;
  final bool borderOnly;
  final double borderWidth;
  final Function(Zone zone, Offset center) onTap;

  const BoxRegion(
      {super.key,
      required this.zone,
      required this.scaleFactor,
      this.borderOnly = false,
      this.borderWidth = 1,
      this.color = const Color.fromARGB(1, 255, 255, 255),
      this.onTap = _noop});

  static void _noop(Zone _, Offset __) {}

  @override
  State<BoxRegion> createState() => _BoxRegionState();

  @override
  String toStringShort() => "${runtimeType.toString()}(zone: $zone)";
}

class _BoxRegionState extends State<BoxRegion> {
  Zone get _zone => widget.zone;
  double get _scalefactor => widget.scaleFactor;
  double get _width => widget.zone.width;
  double get _height => widget.zone.height;
  double get _top => widget.zone.top;
  double get _left => widget.zone.left;
  Color get _color => widget.color;
  bool get _borderOnly => widget.borderOnly;
  double get _borderWidth => widget.borderWidth;
  Function(Zone zone, Offset center) get _onTap => widget.onTap;

  Offset getCenter() => Offset(
      (_left * _scalefactor) + (_width * _scalefactor) / 2,
      (_top * _scalefactor) + (_height * _scalefactor) / 2);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _top * _scalefactor,
        left: _left * _scalefactor,
        child: Semantics(
          button: true,
          child: GestureDetector(
            onTap: () {
              _onTap(_zone, getCenter());
            },
            child: Container(
              width: _width * _scalefactor,
              height: _height * _scalefactor,
              decoration: BoxDecoration(
                color: _borderOnly ? Colors.transparent : _color,
                border: _borderOnly
                    ? Border.all(
                        color: _color,
                        width: _borderWidth,
                      )
                    : null,
              ),
            ),
          ),
        ));
  }
}
