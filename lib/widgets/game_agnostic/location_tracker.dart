import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/widgets/game_agnostic/box_region.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';

class LocationTracker extends StatefulWidget {
  final String? jsonKey;
  final String imageFilePath;
  final double rawImageWidth;
  final double rawImageHeight;
  final double? margin;
  final List<Zone> zones;
  final Map<String, Color>? assignedColors;
  final bool viewOnly;
  final Color mainColor;
  final Color backgroundColor;

  final Widget Function(BuildContext context, String? regionId,
      void Function(dynamic data) onUpdate) childBuilder;

  const LocationTracker({
    super.key,
    this.jsonKey,
    required this.imageFilePath,
    required this.rawImageWidth,
    required this.rawImageHeight,
    this.margin,
    required this.zones,
    this.assignedColors,
    this.viewOnly = false,
    this.mainColor = Constants.pastelRed,
    this.backgroundColor = Constants.pastelWhite,
    required this.childBuilder,
  });

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? get _jsonKey => widget.jsonKey;
  bool get _viewOnly => widget.viewOnly;

  late double _width;
  String? _selectedId;

  final Map<String?, dynamic> _compiledData = {};

  double get _margin => widget.margin ?? _width / 20;
  double get _availableWidth => _width - 2 * _margin;
  double get _imageWidth => _viewOnly ? _availableWidth : 0.5 * (_availableWidth - _margin);
  double get _scaleFactor => _imageWidth / widget.rawImageWidth;
  double get _imageHeight => widget.rawImageHeight * _scaleFactor;

  int get _selectedIndex {
    if (_selectedId == null) return 0;
    final index = widget.zones.indexWhere((z) => z.id == _selectedId);
    return index != -1 ? index + 1 : 0;
  }

  void _onChildUpdate(String? regionId, dynamic data) {
    _compiledData[regionId] = data;
    _serializeData();
  }

  List<BoxRegion> _getRegions() {
    return widget.zones.map((zone) {
      Color color;
      color = _selectedId == zone.id || _viewOnly
          ? (widget.assignedColors?[zone.id] ??
              const Color.fromARGB(99, 67, 189, 155))
          : const Color.fromARGB(40, 255, 255, 255);

      return BoxRegion(
        id: zone.id,
        top: zone.top * _scaleFactor,
        left: zone.left * _scaleFactor,
        width: zone.width * _scaleFactor,
        height: zone.height * _scaleFactor,
        color: color,
        borderOnly: _selectedId != zone.id && !_viewOnly,
        borderWidth: _margin / 5,
        onTap: (id, _) {
          HapticFeedback.mediumImpact();
          setState(() {
            _selectedId = (_selectedId == id) ? null : id;
          });
        },
      );
    }).toList();
  }

  void _serializeData() {
    if (_jsonKey == null || _viewOnly) return;

    DataEntry.exportData[_jsonKey!] = _compiledData;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;

        return AbsorbPointer(
          absorbing: _viewOnly,
          child: SizedBox(
            width: _width,
            height: _imageHeight + (2 * _margin),
            child: DefaultContainer(
              color: widget.backgroundColor,
              margin: _margin,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: _margin,
                children: [
                  SizedBox(
                    width: _imageWidth,
                    height: _imageHeight,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: widget.mainColor,
                            borderRadius: BorderRadius.circular(_margin / 2),
                            image: DecorationImage(
                              image: AssetImage(widget.imageFilePath),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                widget.backgroundColor,
                                BlendMode.modulate,
                              ),
                            ),
                          ),
                        ),
                        ..._getRegions(),
                      ],
                    ),
                  ),
                  if (!_viewOnly) Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        widget.childBuilder(
                          context,
                          null,
                          (data) => _onChildUpdate(null, data),
                        ),
                        ...widget.zones.map(
                          (zone) => widget.childBuilder(
                            context,
                            zone.id,
                            (data) => _onChildUpdate(zone.id, data),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
