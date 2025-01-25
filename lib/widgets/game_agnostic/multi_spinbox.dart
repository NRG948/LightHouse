import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

/// A horizontal group of spinboxes, which are manual counters that count integers between 0-999 inclusive.
class NRGMultiSpinbox extends StatefulWidget {
  final String title;
  final List<String> jsonKey;
  final double height;
  final double width;
  final List<List<String>> boxNames;
  
  const NRGMultiSpinbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      required this.boxNames});

  @override
  State<NRGMultiSpinbox> createState() => _NRGMultiSpinboxState();
}

class _NRGMultiSpinboxState extends State<NRGMultiSpinbox>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String get _title => widget.title;
  double get _width => widget.width;
  double get _height => widget.height;
  List<String> get _keys => widget.jsonKey;
  List<List<String>> get _boxNames => widget.boxNames;
  double get _scaleFactor => _width / 400;

  @override
  Widget build(BuildContext context) {
    debugPrint(_width.toString());
    debugPrint(_scaleFactor.toString());

    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _title,
              style: comfortaaBold(18 * _scaleFactor,color: Constants.pastelReddishBrown),
              textAlign: TextAlign.center,
            ),
            buildSpinboxes(_scaleFactor)
          ],
        ));
  }

  Widget buildSpinboxes(double scaleFactor) {
    final keyList = _keys;
    final nameList = _boxNames.expand((list) => list).toList();
    if (!(keyList.length == nameList.length)) {
      return Text(
          "${nameList.length}-count spinbox has ${keyList.length} JSON keys associated with it");
    }

    final List<Widget> rowList = _boxNames.map((row) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((title) {
            // This breaks if you name more than one spinbox the same thing
            // sooooooo
            // don't do that
            return NRGMultiSpinChild(
                title: title, jsonKey: keyList[nameList.indexOf(title)],scaleFactor: scaleFactor,);
          }).toList() as List<Widget>);
    }).toList();
    return Column(children: rowList);
  }
}

class NRGMultiSpinChild extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double scaleFactor;
  const NRGMultiSpinChild(
      {super.key, required this.title, required this.jsonKey, required this.scaleFactor});

  @override
  State<NRGMultiSpinChild> createState() => _NRGMultiSpinChildState();
}

class _NRGMultiSpinChildState extends State<NRGMultiSpinChild> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  double get _scaleFactor => widget.scaleFactor;
  late int _counter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225 * _scaleFactor,
      height: 95 * _scaleFactor,
      child: Column(
        children: [
          SizedBox(
            height: 95 * 0.3 * _scaleFactor,
            child: AutoSizeText(_title,maxLines: 1,style: comfortaaBold(40,color: Constants.pastelReddishBrown),),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              height: 37.2,
              width: 37.2,
              child: GestureDetector(
                onTap: decrement,
                child: Transform.flip(
                  flipY:true,
                  child: CustomPaint(
                    painter: RoundedTrianglePainter(color: Constants.pastelRed),
                    
                  ),
                ),
              ),
            ),
            Container(
              height: 60 * _scaleFactor,
              width: 80 * _scaleFactor,
              decoration: BoxDecoration(color: Constants.pastelRed,borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Center(child: AutoSizeText(_counter.toString(),maxLines: 1,textAlign: TextAlign.center,style: comfortaaBold(60 * _scaleFactor),)),
            ),
            SizedBox(
              height: 37.2,
              width: 37.2,
              child: GestureDetector(
                onTap: increment,
                child: CustomPaint(
                  painter: RoundedTrianglePainter(color: Constants.pastelRed),
                  
                ),
              ),
            ),
            
          ],)
        ],
      ),
    );
  }
  
  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  /// Decrements [_counter], and bounds it at 0.
  void decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        updateState();
      }
    });
  }

  /// Increments [_counter], and bounds it at 999.
  void increment() {
    setState(() {
      if (_counter < 999) {
        _counter++;
        updateState();
      }
    });
  }

  /// Exports [_counter] to the json.
  void updateState() {
    DataEntry.exportData[_key] = _counter.toString();
  }
}

class Triangle extends StatelessWidget {
  const Triangle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class RoundedTrianglePainter extends CustomPainter {
  final Color color;
  const RoundedTrianglePainter({this.color = Colors.black});
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final double scaleX = width / 200;
    final double scaleY = height / 200;
    final double offset = width * 0.185;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(((200 / 2) - 16) * scaleX, 80 * scaleY - offset)
      ..arcToPoint(
        Offset(((200 / 2) + 16) * scaleX, 80 * scaleY - offset),
        radius: Radius.circular(22 * scaleX),
        clockwise: true,
      )
      ..lineTo(200 * scaleX, 200 * scaleY - offset)
      ..lineTo(0, 200 * scaleY - offset)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}