import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

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
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _title,
              style: comfortaaBold(18),
              textAlign: TextAlign.center,
            ),
            buildSpinboxes()
          ],
        ));
  }

  Widget buildThreeStageCheckmarks() {
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
            // As much of this code is simply modified from MultiSpinbox, 
            //it has the same limitations--as in, do not give the same name
            //to multiple different ones. 
            return NRGMultiSpinChild(
                title: title, jsonKey: keyList[nameList.indexOf(title)]);
          }).toList() as List<Widget>);
    }).toList();
    return Column(children: rowList);
  }
}