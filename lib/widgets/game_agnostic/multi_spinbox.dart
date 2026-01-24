import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/layouts.dart";
import "package:lighthouse/data_entry.dart";

/// A horizontal group of spinboxes, which are manual counters that count integers between 0-999 inclusive.
class NRGMultiSpinbox extends StatefulWidget {
  final String title; // Title of the spinbox group
  final List<String> jsonKey; // List of JSON keys associated with each spinbox
  final double height; // Height of the spinbox container
  final double width; // Width of the spinbox container
  final List<List<String>> boxNames; // Names of each spinbox
  final List<String>? updateOtherFields; // Optional fields to update other spinboxes
  final DESharedState? sharedState; // Shared state for updating UI

  const NRGMultiSpinbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      required this.boxNames,
      this.updateOtherFields,
      this.sharedState
      });

  @override
  State<NRGMultiSpinbox> createState() => _NRGMultiSpinboxState();
}

class _NRGMultiSpinboxState extends State<NRGMultiSpinbox>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep the state alive
  String get _title => widget.title; // Get the title from the widget
  double get _width => widget.width; // Get the width from the widget
  double get _height => widget.height; // Get the height from the widget
  List<String> get _keys => widget.jsonKey; // Get the JSON keys from the widget
  List<List<String>> get _boxNames => widget.boxNames; // Get the box names from the widget
  double get _scaleFactor => _width / 500; // Calculate the scale factor based on width

  @override
  void initState() {
    super.initState();
    for (String i in _keys) {
      DataEntry.exportData[i] = 0; // Initialize export data for each key
    }
    if (widget.sharedState != null) {
      widget.sharedState!.addListener(() => setState(() {
        build(context); // Rebuild the widget when shared state changes
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //debugPrint(_width.toString()); // Debug print the width
    //debugPrint(_scaleFactor.toString()); // Debug print the scale factor

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
              style: comfortaaBold(18 * _scaleFactor,color: Constants.pastelBrown),
              textAlign: TextAlign.center,
            ),
            buildSpinboxes(_scaleFactor) // Build the spinboxes
          ],
        ));
  }

  Widget buildSpinboxes(double scaleFactor) {
    final keyList = _keys; // List of JSON keys
    final nameList = _boxNames.expand((list) => list).toList(); // Flatten the box names list
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
            if (widget.updateOtherFields == null) {
            return NRGMultiSpinChild(
                title: title, jsonKey: keyList[nameList.indexOf(title)],scaleFactor: scaleFactor,);
            } else {
            return NRGMultiSpinChild(
                title: title, jsonKey: keyList[nameList.indexOf(title)],scaleFactor: scaleFactor,otherJsonKey: widget.updateOtherFields![nameList.indexOf(title)],sharedState: widget.sharedState,);

            }
          }).toList() as List<Widget>);
    }).toList();
    return Column(children: rowList); // Return a column of rows of spinboxes
  }
}

class NRGMultiSpinChild extends StatefulWidget {
  final String title; // Title of the spinbox
  final String jsonKey; // JSON key associated with the spinbox
  final double scaleFactor; // Scale factor for the spinbox
  final String? otherJsonKey; // Optional JSON key for updating other spinboxes
  final DESharedState? sharedState; // Shared state for updating UI
  const NRGMultiSpinChild(
      {super.key, required this.title, required this.jsonKey, required this.scaleFactor, this.otherJsonKey,this.sharedState});

  @override
  State<NRGMultiSpinChild> createState() => _NRGMultiSpinChildState();
}

class _NRGMultiSpinChildState extends State<NRGMultiSpinChild> {
  String get _title => widget.title; // Get the title from the widget
  String get _key => widget.jsonKey; // Get the JSON key from the widget
  double get _scaleFactor => widget.scaleFactor; // Get the scale factor from the widget
  late int _counter; // Counter for the spinbox

  @override
  Widget build(BuildContext context) {
    _counter = DataEntry.exportData[_key]; // Initialize the counter from export data
    return SizedBox(
      width: 225 * _scaleFactor,
      height: 95 * _scaleFactor,
      child: Column(
        children: [
          SizedBox(
            height: 95 * 0.3 * _scaleFactor,
            child: AutoSizeText(_title,maxLines: 1,style: comfortaaBold(40,color: Constants.pastelBrown),),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              height: 37.2,
              width: 37.2,
              child: GestureDetector(

                onTap: () {
                  decrement(); // Decrement the counter
                },
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

                onTap: () {
                  increment(); // Increment the counter
                },
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
    _counter = 0; // Initialize the counter to 0
  }

  /// Decrements [_counter], and bounds it at 0.
  void decrement() {
    setState(() {
      if (_counter > 0) {
        HapticFeedback.mediumImpact();
        _counter--;
        if (widget.otherJsonKey != null) {
          if (DataEntry.exportData[widget.otherJsonKey]! > 0) {
            DataEntry.exportData[widget.otherJsonKey!] = DataEntry.exportData[widget.otherJsonKey] - 1;
            widget.sharedState!.triggerUpdate(); // Trigger update for shared state
          }
        }
        updateState(); // Update the state
      }
    });
  }

  /// Increments [_counter], and bounds it at 999.
  void increment() {
    HapticFeedback.heavyImpact();
    setState(() {
      if (_counter < 999) {
        _counter++;
        if (widget.otherJsonKey != null) {
          if (DataEntry.exportData[widget.otherJsonKey]! < 999) {
            DataEntry.exportData[widget.otherJsonKey!] = DataEntry.exportData[widget.otherJsonKey] + 1;
            widget.sharedState!.triggerUpdate(); // Trigger update for shared state
          }
        }
        updateState(); // Update the state
      }
    });
  }

  /// Exports [_counter] to the json.
  void updateState() {
    DataEntry.exportData[_key] = _counter; // Update the export data with the counter value
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
  final Color color; // Color of the triangle
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
    canvas.drawPath(path, paint); // Draw the triangle path
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}