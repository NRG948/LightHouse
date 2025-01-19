import "dart:math" as math;

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/data_entry.dart';

class RSAutoUntimed extends StatefulWidget {
  const RSAutoUntimed({super.key});

  @override
  State<RSAutoUntimed> createState() => _RSAutoUntimedState();
}

class _RSAutoUntimedState extends State<RSAutoUntimed> {
  late SharedState sharedState;
  @override
  void initState() {
    super.initState();
    sharedState = SharedState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height:725,
      width:400,
      color: Constants.pastelWhite,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RSAUCoralStation(title: "Processor", jsonKey: "autoProcessorCS"),
          RSAUCoralStation(title: "Barge", jsonKey: "autoBargeCS"),
        ],),
        SizedBox(height: 10),
        RSAUHexagon(sharedState: sharedState,),
        RSAUReef(sharedState: sharedState)
      ],),
    );
  }
}

class RSAUReef extends StatefulWidget {
  final SharedState sharedState;
  const RSAUReef({super.key, required this.sharedState});

  @override
  State<RSAUReef> createState() => _RSAUReefState();
}

class _RSAUReefState extends State<RSAUReef> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
     DataEntry.exportData["autoCoralScored"] = [];
    DataEntry.exportData["autoAlgaeRemoved"] = [];
    super.initState();
    widget.sharedState.addListener(() {setState(() {
    });});
  }
  @override
  void dispose() {
    super.dispose();
    widget.sharedState.addListener(() {setState(() {

    });});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sharedState.activeTriangle == null) {
      return Text("No Section Selected", style: comfortaaBold(18, color: Colors.black),);
    }
    String at = widget.sharedState.activeTriangle!;
    return Container(
      height: 330,
      width: 318,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        border: Border.all(color: Colors.black,width: 1)),
      child: Column(
        spacing: 2,
        children: [
        Text("Section ${widget.sharedState.activeTriangle}",
        textAlign: TextAlign.center,
        style: comfortaaBold(18, color: Colors.black)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          RSAUReefButton(icon: CoralAlgaeIcons.coral4,location: "${at[0]}4",),
          RSAUReefButton(icon: CoralAlgaeIcons.coral4,location: "${at[1]}4",),
        ],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          RSAUReefButton(icon: CoralAlgaeIcons.coral3,location: "${at[0]}3",),
          RSAUReefButton(icon: CoralAlgaeIcons.algae3FRCLogo, location: "${at}3", algae: true,),
          RSAUReefButton(icon: CoralAlgaeIcons.coral3,location: "${at[1]}3",),
        ],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          RSAUReefButton(icon: CoralAlgaeIcons.coral2,location: "${at[0]}2",),
          RSAUReefButton(icon: CoralAlgaeIcons.algae2FRCLogo, location: "${at}2", algae: true,),
          RSAUReefButton(icon: CoralAlgaeIcons.coral2,location: "${at[1]}2",),
        ],),
        RSAUTrough()    
      ],)
    );
  }
}
class RSAUTrough extends StatefulWidget {
  const RSAUTrough({super.key});

  @override
  State<RSAUTrough> createState() => _RSAUTroughState();
}

class _RSAUTroughState extends State<RSAUTrough> {
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = 0;
  }

  void increment() {setState( () {
    if (counter < 99) {counter++;}
    DataEntry.exportData["coralScoredL1"] = counter.toString();});
  }

  void decrement() {setState(() {
    if (counter>0) {counter--;}
    DataEntry.exportData["coralScoredL1"] = counter.toString();});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: increment,
      child: Container(
        height: 96,
        width: 302,
        decoration: BoxDecoration(
          color: counter > 0 ? Constants.pastelRed : Colors.grey,
          border: Border.all(
            color: Colors.black,
            width: 1
          )
        ),
        child: Center(
          child: GestureDetector(
            onTap: increment,
            child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CoralAlgaeIcons.coral),
                  Text("Coral Scored L1 (Trough)", textAlign: TextAlign.center,style: comfortaaBold(15, color: Colors.black),),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                    SizedBox(
                      width: 250,
                      child: Text(counter.toString(),style: comfortaaBold(23, color: Colors.black),textAlign: TextAlign.center,)),
                    IconButton(onPressed: decrement, icon: Icon(Icons.keyboard_arrow_down),highlightColor: Colors.transparent,splashColor: Colors.transparent,)
                  ],),
                ),
              )
            ],),
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
  const RSAUReefButton({super.key, required this.icon, required this.location, this.algae = false});

  @override
  State<RSAUReefButton> createState() => _RSAUReefButtonState();
}

class _RSAUReefButtonState extends State<RSAUReefButton> {
  late bool active;

  @override
  void initState() {
    super.initState();
    active = false;
  }

  void setActive() {setState(() {
    if (!active) {
      if (widget.algae) {
        DataEntry.exportData["autoAlgaeRemoved"].add(widget.location);
      } else {
        DataEntry.exportData["autoCoralScored"].add(widget.location);
      }
    } else {
      if (widget.algae) {
        DataEntry.exportData["autoAlgaeRemoved"].remove(widget.location);
      } else {
        DataEntry.exportData["autoCoralScored"].remove(widget.location);
      }
    }
    active = !active;
    });
  }

  @override
  Widget build(BuildContext context) {
    active = DataEntry.exportData["autoCoralScored"].contains(widget.location) || DataEntry.exportData["autoAlgaeRemoved"].contains(widget.location);
    return Container(
      height: 60,
      width:  widget.algae ? 75 : 100,
      decoration: BoxDecoration(
        color: active ? Constants.pastelRed : Colors.grey,
        border: Border.all(
          color: Colors.black,
          width: 1
        )),
      child: IconButton(onPressed: setActive, icon: Icon(widget.icon),
      iconSize: 45,
      color: Colors.black,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,)
    );
  }
}
class RSAUHexagon extends StatelessWidget {
  final SharedState sharedState;
  const RSAUHexagon({super.key, required this.sharedState});

  @override
  Widget build(BuildContext context) {
    // TODO: Change these labels to more accurately match reef locations (top ones are flipped)
    final triangleLabels = ["IJ","GH","EF","CD","AB","KL",];
    return Container(
      color: Constants.pastelWhite,
      height: 275,
      width: 275,
      alignment: Alignment.center,
      child: AspectRatio(aspectRatio: 1,
      child: Stack(
        children: [
          CustomPaint(size: Size.infinite,
          painter: HexagonPainter()),
          for (int i = 0; i < 6; i++)
            TriangleTapRegion(
              index: i,
              label: triangleLabels[i],
              sharedState: sharedState
            ),
        ],
      ))

      );
  }

  
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double R = size.width / 2; // Radius of the hexagon
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Calculate the vertices of the hexagon
    final List<Offset> vertices = [];
    for (int k = 0; k < 6; k++) {
      double angle = k * (math.pi / 3);
      vertices.add(Offset(
        center.dx + R * math.cos(angle),
        center.dy + R * math.sin(angle),
      ));
    }

    // Draw the hexagon
    final Path hexagonPath = Path()..moveTo(vertices[0].dx, vertices[0].dy);
    for (int i = 1; i < vertices.length; i++) {
      hexagonPath.lineTo(vertices[i].dx, vertices[i].dy);
    }
    hexagonPath.close();
    canvas.drawPath(hexagonPath, paint);

    // Draw lines from the center to each vertex
    for (final vertex in vertices) {
      canvas.drawLine(center, vertex, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class TriangleTapRegion extends StatefulWidget {
  final int index;
  final String label;
  final SharedState sharedState;
  const TriangleTapRegion({super.key, required this.index, required this.label, required this.sharedState});

  @override
  State<TriangleTapRegion> createState() => _TriangleTapRegionState();
}

class _TriangleTapRegionState extends State<TriangleTapRegion> {
  @override
  void initState() {
    super.initState();
    widget.sharedState.addListener(() {setState(() {
    });});
  }

  @override
  void dispose() {
    super.dispose();
    widget.sharedState.addListener(() {setState(() {
    });});
  }
  @override
  Widget build(BuildContext context) {
    Widget returnIfHighlighted = widget.sharedState.activeTriangle == widget.label ? GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {widget.sharedState.setActiveTriangle(widget.label);},
      child: Container(
        color: Colors.grey,
         child: Text(widget.label, style: comfortaaBold(14,color:Colors.black),)
       ),
    ) : GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {widget.sharedState.setActiveTriangle(widget.label);},
      child: Text(widget.label,style:comfortaaBold(14,color:Colors.black)));
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
                onTap: () {widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Triangle label
            Positioned(
              left: labelPosition.dx - 10, // Adjust for text centering
              top: labelPosition.dy - 10,  // Adjust for text centering
              child: returnIfHighlighted
            ),
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


class RSAUCoralStation extends StatefulWidget {
  final String jsonKey;
  final String title;
  const RSAUCoralStation({
    super.key, required this.jsonKey, required this.title
  });

  @override
  State<RSAUCoralStation> createState() => _RSAUCoralStationState();
}

class _RSAUCoralStationState extends State<RSAUCoralStation> {
  String get title => widget.title;
  String get jsonKey => widget.jsonKey;
  late int counter;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: increment,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 51,
             decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(
                color: Constants.pastelWhite,
                width: 1
              )
            ),
            child: Column(
              children: [
                Text(title, style: comfortaaBold(16),textAlign: TextAlign.center,),
                Text(counter.toString(),style: comfortaaBold(18),)
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(
                color: Constants.pastelWhite,
                width: 1
              )
            ),
            child: IconButton(onPressed: decrement, icon: Icon(Icons.keyboard_arrow_down),highlightColor: Colors.transparent,splashColor: Colors.transparent,)
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    counter = 0;
  }
  void updateState() {
    DataEntry.exportData[jsonKey] = counter.toString();
  }
  void increment() {setState(() {
    if (counter<99) {
      counter++;
    } else {showDialog(context: context, builder: (builder) {return Dialog(child:Text("Counter $title is over limit!"));});}
    updateState();
  });
  }
  void decrement() {setState(() {
    if (counter>0) {
      counter--;
    }
    updateState();
  }); 
  }
}
class SharedState extends ChangeNotifier {
  String? activeTriangle;
  void setActiveTriangle(String triangle) {
    print(triangle);
    activeTriangle = triangle;
    notifyListeners();
  }
}