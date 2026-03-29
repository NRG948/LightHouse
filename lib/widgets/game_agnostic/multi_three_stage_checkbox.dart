import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/three_stage_checkbox.dart';

// This widget represents a multi three-stage checkbox with a title and a list of JSON keys.
class NRGMultiThreeStageCheckbox extends StatefulWidget {
  final String title;
  final List<String> jsonKey;
  final double height;
  final double width;
  final List<List<String>> boxNames;

  // Constructor for initializing the widget with required parameters.
  const NRGMultiThreeStageCheckbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      required this.boxNames});

  @override
  State<NRGMultiThreeStageCheckbox> createState() => _NRGMultiThreeStageCheckboxState();
}

// State class for NRGMultiThreeStageCheckbox widget.
class _NRGMultiThreeStageCheckboxState extends State<NRGMultiThreeStageCheckbox>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Getters for accessing widget properties.
  String get _title => widget.title;
  double get _width => widget.width;
  double get _height => widget.height;
  List<String> get _keys => widget.jsonKey;
  List<List<String>> get _boxNames => widget.boxNames;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Container for the multi three-stage checkbox with a title and checkboxes.
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: context.colors.container,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title of the checkbox group.
            Text(
              _title,
              style: comfortaaBold(18,color: context.colors.containerText),
              textAlign: TextAlign.center,
            ),
            // Build the three-stage checkboxes.
            buildThreeStageCheckmarks()
          ],
        ));
  }

  // Method to build the three-stage checkboxes.
  Widget buildThreeStageCheckmarks() {
    final keyList = _keys;
    final nameList = _boxNames.expand((list) => list).toList();

    // Check if the number of keys matches the number of checkbox names.
    if (!(keyList.length == nameList.length)) {
      return Text(
          "${nameList.length}-count three-stage-checkbox has ${keyList.length} JSON keys associated with it");
    }

    // Create wrapping checkboxes.
    final List<Widget> checkboxList = _boxNames.expand((row) {
      return row.map((title) {
            // As much of this code is simply modified from MultiSpinbox, 
            // it has the same limitations--as in, do not give the same name
            // to multiple different ones. 

            //-------for finding the width of title
            final textPainter = TextPainter(
              text: TextSpan(text: title), 
              textDirection: TextDirection.ltr, 
            );

            textPainter.layout();

            final textwidth = textPainter.size.width;
            //-------end of that section

            // Create an individual three-stage checkbox.
            return NRGThreeStageCheckbox(
                title: title, jsonKey: keyList[nameList.indexOf(title)], height: 50, width: textwidth * 3.5,);
          }).toList() as List<Widget>;
    }).toList();

    // Return the wrapping checkbox column.
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: checkboxList,
    );
  }
}