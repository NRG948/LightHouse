import "dart:math" as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';

class RSAutoUntimed extends StatefulWidget {
  final double width;
  final bool isPitAuto;
  const RSAutoUntimed({super.key, required this.width, this.isPitAuto = false});

  @override
  State<RSAutoUntimed> createState() => _RSAutoUntimedState();
}

class _RSAutoUntimedState extends State<RSAutoUntimed> {
  final List<DropdownMenuItem> dropdownItems = [
    DropdownMenuItem(
      value: 1,
      child: Text(
        "      1",
        style: comfortaaBold(20, color: Colors.black),
      ),
    ),
    DropdownMenuItem(
      value: 0,
      child: Text(
        "Add",
        style: comfortaaBold(20, color: Colors.black),
      ),
    ),
    DropdownMenuItem(
      value: -1,
      child: Text(
        "Remove",
        style: comfortaaBold(20, color: Colors.black),
      ),
    ),
  ];
  bool get isPitAuto => widget.isPitAuto;
  late RSAUSharedState sharedState;
  late double scaleFactor;
  @override
  void initState() {
    super.initState();
    sharedState = RSAUSharedState();
    sharedState.initialize(widget.isPitAuto);
    scaleFactor = widget.width / 400;

    if (widget.isPitAuto) {
      assert(DataEntry.exportData['auto'] != null);
      assert(DataEntry.exportData['auto'][0] != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children =
        // widget.pit ? [
        //     SizedBox(height: 5 * scaleFactor),
        //     RSAUHexagon(sharedState: sharedState,scaleFactor: scaleFactor,),
        //     RSAUReef(sharedState: sharedState, scaleFactor: scaleFactor)] :
        [
      SizedBox(
        height: 95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: RSAUCoralStation(
                title: "Processor",
                jsonKey: "processorCS",
                scaleFactor: scaleFactor,
                flipped: false,
              ),
            ),
            Column(
              children: [
                isPitAuto
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 23,
                          child: DropdownButton(
                              value: sharedState.currentAuto,
                              items: dropdownItems,
                              onChanged: (selection) {
                                HapticFeedback.mediumImpact();
                                if (selection == 0) {
                                  DataEntry.exportData['auto']
                                      .add(sharedState._createAutoEntry());
                                  dropdownItems.insert(
                                    dropdownItems.length - 2,
                                    DropdownMenuItem(
                                      value: dropdownItems.length - 1,
                                      child: Text(
                                        "      ${dropdownItems.length - 1}",
                                        style: comfortaaBold(20,
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                  sharedState.currentAuto += 1;
                                  return;
                                }
                                if (selection == -1) {
                                  if (sharedState.currentAuto == 1) return;
                                  DataEntry.exportData['auto'].removeLast();
                                  dropdownItems
                                      .removeAt(dropdownItems.length - 3);
                                  sharedState.currentAuto -= 1;
                                  return;
                                }
                                setState(() {
                                  sharedState.setCurrentAuto(selection!
                                      as int); //flutter is being weird about this one, so I'm gonna keep this cast for now...
                                });
                              }),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RSAUGroundIntake(
                      jsonKey: 'groundIntake',
                      scaleFactor: scaleFactor,
                      isPitAuto: isPitAuto),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: RSAUCoralStation(
                title: "Barge",
                jsonKey: "bargeCS",
                scaleFactor: scaleFactor,
                flipped: true,
              ),
            ),
          ],
        ),
      ),
      RSAUHexagon(
        sharedState: sharedState,
        scaleFactor: scaleFactor,
        isPitAuto: isPitAuto,
      ),
      RSAUReef(sharedState: sharedState, scaleFactor: scaleFactor),
      NRGCheckbox(
          title: "Has No Auto",
          jsonKey: "hasNoAuto",
          jsonKeyPath: isPitAuto ? sharedState.targetData : null,
          height: 40,
          width: 400),
      isPitAuto
          ? NRGCheckbox(
              title: "Drops Algae on Ground",
              jsonKey: "dropsAlgaeAuto",
              jsonKeyPath: sharedState.targetData,
              height: 40,
              width: 400)
          : SizedBox(),
      isPitAuto
          ? NRGCheckbox(
              title: "Drives Out",
              jsonKey: "drivesOut",
              jsonKeyPath: sharedState.targetData,
              height: 40,
              width: 400)
          : SizedBox(),
    ];
    return Container(
      height: (isPitAuto ? 740 : 720) * scaleFactor,
      width: widget.width,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(children: children),
    );
  }
}

class RSAUReef extends StatefulWidget {
  final RSAUSharedState sharedState;
  final double scaleFactor;
  const RSAUReef(
      {super.key, required this.sharedState, required this.scaleFactor});

  @override
  State<RSAUReef> createState() => _RSAUReefState();
}

class _RSAUReefState extends State<RSAUReef>
    with AutomaticKeepAliveClientMixin {
  final sharedState = RSAUSharedState();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    sharedState.targetData["autoCoralScored"] = [];
    sharedState.targetData["autoAlgaeRemoved"] = [];
    super.initState();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.sharedState.activeTriangle == null) {
      return Text(
        "No Section Selected",
        style: comfortaaBold(18, color: Colors.black),
      );
    }
    String activeTriangle = widget.sharedState.activeTriangle!;
    return Container(
        height: 280 * widget.scaleFactor,
        width: 320 * widget.scaleFactor,
        padding: EdgeInsets.only(
            top: 4 * widget.scaleFactor,
            bottom: 8 * widget.scaleFactor,
            left: 8 * widget.scaleFactor,
            right: 8 * widget.scaleFactor),
        child: Column(
          spacing: 2 * widget.scaleFactor,
          children: [
            Text("Section ${widget.sharedState.activeTriangle}",
                textAlign: TextAlign.center,
                style: comfortaaBold(18 * widget.scaleFactor,
                    color: const Color.fromARGB(255, 0, 0, 0))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral4,
                    location: "${activeTriangle[0]}4",
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral4,
                    location: "${activeTriangle[1]}4",
                    scaleFactor: widget.scaleFactor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral3,
                    location: "${activeTriangle[0]}3",
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons
                        .algae3FRCLogo, // TODO: Change icon to one algae icon, not by 2 or 3
                    location: activeTriangle,
                    algae: true,
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral3,
                    location: "${activeTriangle[1]}3",
                    scaleFactor: widget.scaleFactor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral2,
                    location: "${activeTriangle[0]}2",
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral2,
                    location: "${activeTriangle[1]}2",
                    scaleFactor: widget.scaleFactor),
              ],
            ),
            RSAUTrough(
              scaleFactor: widget.scaleFactor,
            )
          ],
        ));
  }
}

class RSAUTrough extends StatefulWidget {
  final double scaleFactor;
  const RSAUTrough({super.key, required this.scaleFactor});

  @override
  State<RSAUTrough> createState() => _RSAUTroughState();
}

class _RSAUTroughState extends State<RSAUTrough> {
  final sharedState = RSAUSharedState();

  @override
  void initState() {
    super.initState();
    sharedState.targetData["autoCoralScoredL1"] = "0";
  }

  void increment() {
    setState(() {
      if (int.parse(sharedState.targetData["autoCoralScoredL1"]) < 99) {
        sharedState.targetData["autoCoralScoredL1"] =
            (int.parse(sharedState.targetData["autoCoralScoredL1"]) + 1)
                .toString();
      }
    });
  }

  void decrement() {
    setState(() {
      if (int.parse(sharedState.targetData["autoCoralScoredL1"]) > 0) {
        sharedState.targetData["autoCoralScoredL1"] =
            (int.parse(sharedState.targetData["autoCoralScoredL1"]) - 1)
                .toString();
        ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        increment();
        HapticFeedback.lightImpact();
      },
      child: Container(
        height: 65 * widget.scaleFactor,
        width: 301 * widget.scaleFactor,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: int.parse(sharedState.targetData["autoCoralScoredL1"]) > 0
                ? Constants.pastelRed
                : Constants.pastelGray),
        child: Center(
          child: GestureDetector(
            onTap: () {
              increment();
              HapticFeedback.lightImpact();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  children: [
                    Icon(
                      CoralAlgaeIcons.coral,
                      size: 20 * widget.scaleFactor,
                      color: Constants.pastelWhite,
                    ),
                    Text(
                      "Coral Scored L1 (Trough)",
                      textAlign: TextAlign.center,
                      style: comfortaaBold(15 * widget.scaleFactor,
                          color: Constants.pastelWhite),
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    height: 30 * widget.scaleFactor,
                    child: Row(
                      spacing: 0,
                      children: [
                        SizedBox(
                            width: 250 * widget.scaleFactor,
                            //the number count of the coral being scored on that level
                            child: Text(
                              sharedState.targetData["autoCoralScoredL1"],
                              style: comfortaaBold(23 * widget.scaleFactor,
                                  color: Constants.pastelWhite),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(
                            width: 30,
                            child: IconButton(
                                onPressed: () {
                                  decrement();
                                  HapticFeedback.lightImpact();
                                },
                                icon: Icon(Icons.keyboard_arrow_down,
                                    size: 25 * widget.scaleFactor),
                                color: Constants.pastelWhite,
                                iconSize: 25 * widget.scaleFactor))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RSAUReefButton extends StatefulWidget {
  final IconData icon;
  final bool algae;
  final String location;
  final double scaleFactor;
  const RSAUReefButton(
      {super.key,
      required this.icon,
      required this.location,
      required this.scaleFactor,
      this.algae = false});

  @override
  State<RSAUReefButton> createState() => _RSAUReefButtonState();
}

class _RSAUReefButtonState extends State<RSAUReefButton> {
  final sharedState = RSAUSharedState();
  late bool active;

  @override
  void initState() {
    super.initState();
    active = false;
  }

  void setActive() {
    setState(() {
      if (!active) {
        HapticFeedback.heavyImpact();
        if (widget.algae) {
          sharedState.targetData["autoAlgaeRemoved"].add(widget.location);
        } else {
          sharedState.targetData["autoCoralScored"].add(widget.location);
        }
      } else {
        HapticFeedback.lightImpact();
        if (widget.algae) {
          sharedState.targetData["autoAlgaeRemoved"].remove(widget.location);
        } else {
          sharedState.targetData["autoCoralScored"].remove(widget.location);
        }
      }
      active = !active;
    });
  }

  @override
  Widget build(BuildContext context) {
    active = sharedState.targetData["autoCoralScored"]
            .contains(widget.location) ||
        sharedState.targetData["autoAlgaeRemoved"].contains(widget.location);
    return GestureDetector(
      onTap: setActive,
      child: Container(
          height: 55 * widget.scaleFactor,
          width: (widget.algae ? 75 : 100) * widget.scaleFactor,
          decoration: BoxDecoration(
              color: active
                  ? (widget.algae ? Constants.pastelGreenDark : Constants.pastelRed)
                  : Constants.pastelGray),
          //coral icons for the corals that you can choose to click within the map within auto section within atlas section
          child: Center(
            child: IconButton(
              onPressed: setActive,
              icon: Icon(widget.icon, size: 45 * widget.scaleFactor),
              iconSize: 45 * widget.scaleFactor,
              color: Constants.pastelWhite,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          )),
    );
  }
}

class RSAUHexagon extends StatelessWidget {
  final RSAUSharedState sharedState;
  final double scaleFactor;
  final bool isPitAuto;
  const RSAUHexagon(
      {super.key,
      required this.sharedState,
      required this.scaleFactor,
      required this.isPitAuto});

  @override
  Widget build(BuildContext context) {
    // TODO: Change these labels to more accurately match reef locations (top ones are flipped)
    final triangleLabels = [
      "IJ",
      "GH",
      "EF",
      "CD",
      "AB",
      "KL",
    ];
    return Container(
        color: Constants.pastelWhite,
        height: (isPitAuto ? 200 : 280) * scaleFactor,
        width: (isPitAuto ? 200 : 280) * scaleFactor,
        alignment: Alignment.center,
        child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                CustomPaint(
                    size: Size.infinite, painter: HexagonPainter(sharedState)),
                for (int i = 0; i < 6; i++)
                  TriangleTapRegion(
                      index: i,
                      label: triangleLabels[i],
                      sharedState: sharedState,
                      scaleFactor: scaleFactor),
              ],
            )));
  }
}

class HexagonPainter extends CustomPainter {
  final RSAUSharedState sharedState;
  List<String> labels = ["IJ", "GH", "EF", "CD", "AB", "KL"];
  HexagonPainter(this.sharedState);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Constants.pastelWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final Paint highlightFillPaint = Paint()
      ..color = Constants.pastelBlue
      ..style = PaintingStyle.fill;

    final Paint fillPaint = Paint()
      ..color = Constants.pastelGray
      ..style = PaintingStyle.fill;

    final double R = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final List<Offset> hexagonVertices = [];
    for (int k = 0; k < 6; k++) {
      double angle = k * (math.pi / 3);
      hexagonVertices.add(Offset(
        center.dx + R * math.cos(angle),
        center.dy + R * math.sin(angle),
      ));
    }

    final List<List<Offset>> triangleVertices = [];
    for (int k = 0; k < 6; k++) {
      triangleVertices
          .add([hexagonVertices[k], hexagonVertices[(k + 1) % 6], center]);
    }

    for (int i = 0; i < 6; i++) {
      final Path hexagonPath = Path()
        ..moveTo(triangleVertices[i][0].dx, triangleVertices[i][0].dy)
        ..lineTo(triangleVertices[i][1].dx, triangleVertices[i][1].dy)
        ..lineTo(triangleVertices[i][2].dx, triangleVertices[i][2].dy)
        ..close();

      canvas.drawPath(
          hexagonPath,
          sharedState.activeTriangle != null &&
                  i == labels.indexOf(sharedState.activeTriangle!)
              ? highlightFillPaint
              : fillPaint);
      canvas.drawPath(hexagonPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TriangleTapRegion extends StatefulWidget {
  final int index;
  final String label;
  final RSAUSharedState sharedState;
  final double scaleFactor;
  const TriangleTapRegion(
      {super.key,
      required this.index,
      required this.label,
      required this.sharedState,
      required this.scaleFactor});

  @override
  State<TriangleTapRegion> createState() => _TriangleTapRegionState();
}

class _TriangleTapRegionState extends State<TriangleTapRegion> {
  @override
  void initState() {
    super.initState();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget returnIfHighlighted =
        widget.sharedState.activeTriangle == widget.label
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Text(
                  widget.label,
                  style: comfortaaBold(20 * widget.scaleFactor,
                      color: Constants.pastelWhite),
                ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Text(widget.label,
                    style: comfortaaBold(20 * widget.scaleFactor,
                        color: Constants.pastelWhite)));
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double R = width / 2;
        final Offset center = Offset(width / 2, height / 2);

        // Calculate vertices of the hexagon
        final List<Offset> vertices = [];
        for (int k = 0; k < 6; k++) {
          double angle = k * (math.pi / 3);
          vertices.add(Offset(
            center.dx + R * math.cos(angle),
            center.dy + R * math.sin(angle),
          ));
        }

        // Define the triangle for this region
        final Offset vertex1 = vertices[widget.index];
        final Offset vertex2 = vertices[(widget.index + 1) % 6];

        // Calculate the centroid (approximate center) of the triangle
        final Offset labelPosition = Offset(
          (center.dx + vertex1.dx + vertex2.dx) / 3,
          (center.dy + vertex1.dy + vertex2.dy) / 3,
        );

        return Stack(
          children: [
            // Tap area for the triangle
            ClipPath(
              clipper: TriangleClipper(center, vertex1, vertex2),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Triangle label
            Positioned(
                left: labelPosition.dx - 10, // Adjust for text centering
                top: labelPosition.dy - 10, // Adjust for text centering
                child: returnIfHighlighted),
          ],
        );
      },
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  final Offset center;
  final Offset vertex1;
  final Offset vertex2;

  TriangleClipper(this.center, this.vertex1, this.vertex2);

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(vertex1.dx, vertex1.dy)
      ..lineTo(vertex2.dx, vertex2.dy)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) {
    return center != oldClipper.center ||
        vertex1 != oldClipper.vertex1 ||
        vertex2 != oldClipper.vertex2;
  }
}

class RSAUGroundIntake extends StatefulWidget {
  final String jsonKey;
  final double scaleFactor;
  final bool isPitAuto;
  const RSAUGroundIntake(
      {super.key,
      required this.jsonKey,
      required this.scaleFactor,
      required this.isPitAuto});

  @override
  State<StatefulWidget> createState() => _RSAUGroundIntakeState();
}

class _RSAUGroundIntakeState extends State<RSAUGroundIntake> {
  final sharedState = RSAUSharedState();

  @override
  void initState() {
    super.initState();
    sharedState.targetData[widget.jsonKey] = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = 180 * widget.scaleFactor;
    double height = (widget.isPitAuto ? 40 : 80) * widget.scaleFactor;
    List<Widget> rowChildren = [
      Container(
        width: width,
        height: height,
        color: sharedState.targetData[widget.jsonKey]
            ? Constants.pastelRedDark
            : Constants.pastelGray,
        child: TextButton(
            onPressed: () {
              setState(() {
                HapticFeedback.heavyImpact();
                sharedState.targetData[widget.jsonKey] =
                    !sharedState.targetData[widget.jsonKey];
              });
            },
            child: Text(
              "Ground Intake",
              style: comfortaaBold(20 * widget.scaleFactor,
                  color: Constants.pastelWhite),
              textAlign: TextAlign.center,
            )),
      ),
    ];

    return Row(children: rowChildren);
  }
}

class RSAUCoralStation extends StatefulWidget {
  final String jsonKey;
  final String title;
  final double scaleFactor;
  final bool flipped;
  const RSAUCoralStation(
      {super.key,
      required this.jsonKey,
      required this.title,
      required this.scaleFactor,
      required this.flipped});

  @override
  State<RSAUCoralStation> createState() => _RSAUCoralStationState();
}

class _RSAUCoralStationState extends State<RSAUCoralStation> {
  final sharedState = RSAUSharedState();
  @override
  void initState() {
    super.initState();
    sharedState.targetData[widget.jsonKey] = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = 100 * widget.scaleFactor;
    double height = 100 * widget.scaleFactor;
    List<Widget> rowChildren = [
      Container(
        width: width,
        height: height,
        color: sharedState.targetData[widget.jsonKey]
            ? Constants.pastelRedDark
            : Constants.pastelGray,
        child: TextButton(
            onPressed: () {
              setState(() {
                HapticFeedback.heavyImpact();
                sharedState.targetData[widget.jsonKey] =
                    !sharedState.targetData[widget.jsonKey];
              });
            },
            child: Text(
              "CS",
              style: comfortaaBold(40 * widget.scaleFactor,
                  color: Constants.pastelWhite),
              textAlign: TextAlign.center,
            )),
      ),
    ];

    return Row(
        children: widget.flipped ? rowChildren.reversed.toList() : rowChildren);
  }
}

class RSAUSharedState extends ChangeNotifier {
  static final RSAUSharedState _instance = RSAUSharedState._internal();
  factory RSAUSharedState() => _instance;
  RSAUSharedState._internal();

  final List<VoidCallback> _listeners = [];
  int currentAuto = 1;
  String? activeTriangle;
  late bool pitMode = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    _listeners.remove(listener);
  }

  /// returns EITHER a Map<String, dynamic> or List<dynamic>
  dynamic get targetData {
    if (!pitMode) return DataEntry.exportData;

    return (DataEntry.exportData['auto'][currentAuto - 1]
        as Map<String, dynamic>);
  }

  void initialize(bool pit) {
    for (final listener in List.of(_listeners)) {
      removeListener(listener);
    }
    activeTriangle = null;
    pitMode = pit;
    if (pitMode) {
      DataEntry.exportData['auto'] = [
        _createAutoEntry(),
      ] as List<dynamic>;
    }
  }

  Map<String, dynamic> _createAutoEntry() => {
        'bargeCS': false,
        'processorCS': false,
        'groundIntake': false,
        'autoCoralScored': [],
        'autoAlgaeRemoved': [],
        'autoCoralScoredL1': '0',
        'dropsAlgaeAuto': false,
        'hasNoAuto': false,
        'drivesOut': false
      };

  void setCurrentAuto(int auto) {
    currentAuto = auto;
    notifyListeners();
  }

  void setActiveTriangle(String triangle) {
    activeTriangle = triangle;
    notifyListeners();
  }
}
