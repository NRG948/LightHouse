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
            Builder(builder: (context) {
            final int currentIndex = i;
            return Positioned.fill(child: GestureDetector(
              onTap: () => onTriangleTap(_triangleLabels[currentIndex]),
            ));})
        ],
      ))

      );
  }
  final _triangleLabels = ["AB","CD","EF","GH","IJ","KL"];
}
class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double R = size.width / 2; // Assume a square widget for simplicity
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Calculate vertices of the hexagon
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

  TriangleTapRegion({required this.index, required this.onTap});

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

        // Define the triangle path for the current index
        final Path trianglePath = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(vertices[index].dx, vertices[index].dy)
          ..lineTo(vertices[(index + 1) % 6].dx, vertices[(index + 1) % 6].dy)
          ..close();

        // Use a Stack for tap detection
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onTap,
                child: ClipPath(
                  clipper: TriangleClipper(path: trianglePath),
                  child: Container(
                    color: Colors.transparent, // Invisible for tap area
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  final Path path;

  TriangleClipper({required this.path});

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) {
    return false;
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