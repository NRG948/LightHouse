import "dart:math" as math;

import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class RSAutoUntimed extends StatefulWidget {
  const RSAutoUntimed({super.key});

  @override
  State<RSAutoUntimed> createState() => _RSAutoUntimedState();
}

class _RSAutoUntimedState extends State<RSAutoUntimed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:725,
      width:400,
      color: Colors.blueGrey,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RSAUCoralStation(title: "Processor CS", jsonKey: "processorCS"),
          RSAUCoralStation(title: "Barge CS", jsonKey: "bargeCS"),
        ],),
        SizedBox(height: 10),
        RSAUHexagon()
      ],),
    );
  }
}

class RSAUHexagon extends StatefulWidget {
  const RSAUHexagon({super.key});

  
  @override
  State<RSAUHexagon> createState() => _RSAUHexagonState();
}

class _RSAUHexagonState extends State<RSAUHexagon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 360,
      width: 360,
      alignment: Alignment.center,
      child: AspectRatio(aspectRatio: 1,
      child: Stack(
        children: [
          CustomPaint(size: Size.infinite,
          painter: HexagonPainter()),
          for (int i = 0; i < 6; i++)
            TriangleTapRegion(
              index: i,
              onTap: () => onTriangleTap(_triangleLabels[i]),
            ),
        ],
      ))

      );
  }
  final _triangleLabels = ["KL","AB","CD","EF","GH","IJ",];
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

class TriangleTapRegion extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const TriangleTapRegion({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
        final Offset vertex1 = vertices[index];
        final Offset vertex2 = vertices[(index + 1) % 6];

        // Calculate the bounding box of the triangle
        final double left = math.min(math.min(center.dx, vertex1.dx), vertex2.dx);
        final double top = math.min(math.min(center.dy, vertex1.dy), vertex2.dy);
        final double right = math.max(math.max(center.dx, vertex1.dx), vertex2.dx);
        final double bottom = math.max(math.max(center.dy, vertex1.dy), vertex2.dy);

        return Positioned(
          left: left,
          top: top,
          width: right - left,
          height: bottom - top,
          child: GestureDetector(
            onTap: onTap,
            child: ClipPath(
              clipper: TriangleClipper(center, vertex1, vertex2),
              child: Container(
                color: Colors.transparent, // Transparent for taps
              ),
            ),
          ),
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
void onTriangleTap(String triangleLabel) {
  print(triangleLabel);
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
      child: Container(
        width: 100,
        height: 50,
        color: Constants.pastelRed,
        child: Text(title, style: comfortaaBold(18),),
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
  void increment() {
    if (counter<99) {
      counter++;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("+1 $title: $counter"),
        action: SnackBarAction(label: "Undo", onPressed: () {
          decrement();
        }),
      ));
    }
    else {showDialog(context: context, builder: (builder) {return Dialog(child:Text("Counter $title is over limit!"));});}
    updateState();
  }
  void decrement() {
    if (counter>0) {
      counter--;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("-1 $title: $counter")));
    }
    updateState();
  }
}