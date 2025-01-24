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
            buildSpinboxes()
          ],
        ));
  }

  Widget buildSpinboxes() {
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
                title: title, jsonKey: keyList[nameList.indexOf(title)]);
          }).toList() as List<Widget>);
    }).toList();
    return Column(children: rowList);
  }
}

class NRGMultiSpinChild extends StatefulWidget {
  final String title;
  final String jsonKey;
  const NRGMultiSpinChild(
      {super.key, required this.title, required this.jsonKey});

  @override
  State<NRGMultiSpinChild> createState() => _NRGMultiSpinChildState();
}

class _NRGMultiSpinChildState extends State<NRGMultiSpinChild> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  late int _counter;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      width: 95,
      child: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            // The title.
            Opacity(
                opacity: 0.7,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_title, style: comfortaaBold(25,color: Constants.pastelReddishBrown)))),
            // The increment button.
            SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  onPressed: () {
                    increment();
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                ))
          ]),
          // The current number count.
          Text(
            _counter.toString(),
            style: comfortaaBold(30,color: Constants.pastelReddishBrown),
          ),
          // The decrement number.
          SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                  onPressed: () {
                    decrement();
                  },
                  icon: Icon(
                    Icons.remove,
                  ))),
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
