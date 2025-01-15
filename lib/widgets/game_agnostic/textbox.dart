import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

class NRGTextbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final String height;
  final String width;
  final bool numeric;
  const NRGTextbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      this.numeric = false});

  @override
  State<NRGTextbox> createState() => _NRGTextboxState();
}

class _NRGTextboxState extends State<NRGTextbox> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  String get _height => widget.height;
  String get _width => widget.width;
  bool get _numeric => widget.numeric;
  final TextEditingController _controller = TextEditingController();

  // Apparently all this TextEditingController BS can just be done by passing a lambda to the onChanged
  // parameter of a TextField, but this method lets us set an initial value sooooooo
  // idk
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        DataEntry.exportData[_key] = _controller.text;
      });
    });
  }

  // idk what this one does but gpt demands it
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.parse(_height),
        width: double.parse(_width),
        decoration: BoxDecoration(
            color: Colors.blueGrey, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(_title, style: Constants.comfortaaBold20pt),
            TextField(
                keyboardType:
                    _numeric ? TextInputType.text : TextInputType.number,
                inputFormatters:
                    _numeric ? [FilteringTextInputFormatter.digitsOnly] : [],
                controller: _controller,
                decoration: InputDecoration(
                    labelText: "Enter Text",
                    labelStyle: Constants.comfortaaBold20pt,
                    border: OutlineInputBorder()),
                maxLines: double.parse(_height).toInt() > 100
                    ? 5
                    : 1 // Probably shouldn't be hard-coded but fine for now
                )
          ],
        ));
  }
}
