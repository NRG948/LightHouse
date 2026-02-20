import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/single_choice_selector.dart';
import 'package:lighthouse/widgets/game_agnostic/textbox.dart';

enum ClimbLevel { none, l1, l2, l3 }

extension ClimbLevelExtension on ClimbLevel {
  int get value {
    switch (this) {
      case ClimbLevel.none:
        return 0;
      case ClimbLevel.l1:
        return 1;
      case ClimbLevel.l2:
        return 2;
      case ClimbLevel.l3:
        return 3;
    }
  }

  String get name {
    switch (this) {
      case ClimbLevel.none:
        return "None";
      case ClimbLevel.l1:
        return "L1";
      case ClimbLevel.l2:
        return "L2";
      case ClimbLevel.l3:
        return "L3";
    }
  }

  static ClimbLevel getLevelFromName(String? name) {
    switch (name) {
      case "L1":
        return ClimbLevel.l1;
      case "L2":
        return ClimbLevel.l2;
      case "L3":
        return ClimbLevel.l3;
      default:
        return ClimbLevel.none;
    }
  }
}

class TowerLocationSelector extends StatefulWidget {
  final Color backgroundColor;
  final Color mainColor;
  final Color textColor;
  final Color lockedColor;
  final double? margin;

  const TowerLocationSelector(
      {super.key,
      this.backgroundColor = Constants.pastelWhite,
      this.mainColor = Constants.pastelRed,
      this.textColor = Constants.pastelBrown,
      this.lockedColor = Constants.pastelGray,
      this.margin});

  @override
  State<TowerLocationSelector> createState() => _TowerLocationSelectorState();
}

class _TowerLocationSelectorState extends State<TowerLocationSelector> {
  late double _width;
  double get _height => _width * 0.35 + _bottomOffset + _topOffset;
  double get _bottomOffset => _width * 0.12;
  double get _topOffset => _width * 0.15;
  double get _margin => widget.margin ?? _width / 25;

  Color get _mainColor => widget.mainColor;
  Color get _backgroundColor => widget.backgroundColor;
  Color get _textColor => widget.textColor;
  Color get _lockedColor => widget.lockedColor;

  double get _rawImageHeight => 164;
  double get _rawImageWidth => 764;

  double get _imageScaleFactor => (_width - 6 * _margin) / _rawImageWidth;

  late final AssetImage _towerImage;
  String get _towerImagePath => "assets/images/tower.png";

  String _selectedId = "";

  bool _isLocked = true;

  // ignore: unused_field
  String _startTime = "";
  // ignore: unused_field
  ClimbLevel _climbLevel = ClimbLevel.none;

  @override
  void initState() {
    super.initState();
    _towerImage = AssetImage(_towerImagePath);
  }

  Expanded _getSelectRegion({required int flex, required String id}) {
    return Expanded(
      flex: flex,
      child: Container(
        color: _selectedId == id
            ? Color.fromARGB(100, 0, 230, 200)
            : Color.fromARGB(1, 255, 255, 255),
        child: AbsorbPointer(
          absorbing: _isLocked,
          child: GestureDetector(onTapUp: (details) {
            setState(() {
              _selectedId = _selectedId == id ? "" : id;
            });
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return Center(
          child: Container(
            width: _width,
            height: _height,
            padding: EdgeInsets.all(_margin),
            decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(_margin)),
            child: Column(
              spacing: _margin,
              children: [
                Expanded(
                  flex: 15,
                  child: Row(
                    spacing: _margin,
                    children: [
                      Expanded(
                        flex: 50,
                        child: CustomCheckbox(
                          title: "Attempted",
                          textColor: _textColor,
                          optionColor: _mainColor,
                          selectColor: _backgroundColor,
                          onToggle: (value) {
                            setState(() {
                              _isLocked = !value;
                              if (_isLocked) _selectedId = "";
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: InputTextBox(
                            isNumeric: true,
                            hintText: "Start Time",
                            maxLines: 1,
                            isLocked: _isLocked,
                            onChanged: (String text) {
                              _startTime = text;
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 35,
                  child: Container(
                    //height: _height - _bottomOffset - _topOffset - 2.1 * _margin, // 2.1 to prevent overflow due to rounding error
                    decoration: BoxDecoration(
                      color: _isLocked ? _lockedColor : _mainColor,
                      borderRadius: BorderRadius.circular(_margin),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(0, -1),
                          child: Container(
                            width: _rawImageWidth * _imageScaleFactor,
                            height: _rawImageHeight * _imageScaleFactor,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _towerImage,
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                    _backgroundColor, BlendMode.modulate),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(_margin),
                          child: Row(
                            children: [
                              _getSelectRegion(flex: 20, id: "left"),
                              Expanded(
                                flex: 20,
                                child: Column(children: [
                                  _getSelectRegion(flex: 50, id: "left_back"),
                                  _getSelectRegion(flex: 50, id: "left_front")
                                ]),
                              ),
                              Expanded(
                                  flex: 20,
                                  child: Column(children: [
                                    _getSelectRegion(
                                        flex: 50, id: "center_back"),
                                    _getSelectRegion(
                                        flex: 50, id: "center_front")
                                  ])),
                              Expanded(
                                  flex: 20,
                                  child: Column(children: [
                                    _getSelectRegion(
                                        flex: 50, id: "right_back"),
                                    _getSelectRegion(
                                        flex: 50, id: "right_front")
                                  ])),
                              _getSelectRegion(flex: 20, id: "right")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Center(
                    child: SingleChoiceSelector(
                      spacing: 0.1 * _width,
                      choices: [
                        ClimbLevel.l1.name,
                        ClimbLevel.l2.name,
                        ClimbLevel.l3.name
                      ],
                      selectColor: _backgroundColor,
                      optionColor: _isLocked ? _lockedColor : _mainColor,
                      textColor: _textColor,
                      lockedColor: _lockedColor,
                      isLocked: _isLocked,
                      retainSelectionOnLock: false,
                      onSelect: (String? choice) {
                        _climbLevel =
                            ClimbLevelExtension.getLevelFromName(choice);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
