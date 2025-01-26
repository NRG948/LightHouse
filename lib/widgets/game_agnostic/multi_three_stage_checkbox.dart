import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/widgets/game_agnostic/three_stage_checkbox.dart';

class NRGMultiThreeStageCheckbox extends StatefulWidget {
  final String title;
  final List<String> jsonKey;
  final double height;
  final double width;
  final List<List<String>> boxNames;
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
 class _NRGMultiThreeStageCheckboxState extends State<NRGMultiThreeStageCheckbox>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String get _title => widget.title;
  double get _width => widget.width;
  double get _height => widget.height;
  List<String> get _keys => widget.jsonKey;
  List<List<String>> get _boxNames => widget.boxNames;

  @override
  Widget build(BuildContext context) {
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
              style: comfortaaBold(18,color: Constants.pastelReddishBrown),
              textAlign: TextAlign.center,
            ),
            buildThreeStageCheckmarks()
          ],
        ));
  }

  Widget buildThreeStageCheckmarks() {
    final keyList = _keys;
    final nameList = _boxNames.expand((list) => list).toList();
    if (!(keyList.length == nameList.length)) {
      return Text(
          "${nameList.length}-count three-stage-checkbox has ${keyList.length} JSON keys associated with it");
    }
    final List<Widget> rowList = _boxNames.map((row) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((title) {
            // As much of this code is simply modified from MultiSpinbox, 
            //it has the same limitations--as in, do not give the same name
            //to multiple different ones. 

            //-------for finding the width of title
            final textPainter = TextPainter(
              text: TextSpan(text: title), 
              textDirection: TextDirection.ltr, 
            );

            textPainter.layout();

            final textwidth = textPainter.size.width;
            //-------end of that section

            return NRGThreeStageCheckbox(
                title: title, jsonKey: keyList[nameList.indexOf(title)], height: 50, width: textwidth * 3.5,);
          }).toList() as List<Widget>);
    }).toList();
    return Column(children: rowList);
  }
}