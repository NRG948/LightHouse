import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";


class NRGSpinbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  const NRGSpinbox({super.key, this.title = "Spinbox", this.jsonKey = "unnamed"});

  @override
  State<NRGSpinbox> createState() => _NRGSpinboxState();
}

class _NRGSpinboxState extends State<NRGSpinbox> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  late int _counter;
  String _value = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 400,
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(_title, style: comfortaaBold30pt),
          Center(
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                IconButton(onPressed:() {decrement();}, icon: Icon(Icons.keyboard_arrow_down,)),
                Text("$_counter", style: comfortaaBold30pt,),
                IconButton(onPressed:() {increment();}, icon: Icon(Icons.keyboard_arrow_up,)),
              ],
            ),
          )
        ],
      )
      
      );
  }

  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  void decrement() {
    setState(
      () { if (_counter > 0) {_counter--; updateState();} }
    );
  }

  void increment() {
    setState(
      () {
        _counter++;
        updateState();
      }
    );
  }

  void updateState() {
    _value = _counter.toString();
    DataEntry.exportData[_key] = _value;
  }
}