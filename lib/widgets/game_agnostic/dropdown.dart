import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

// TODO: Implement Dropdown
class NRGDropdown extends StatefulWidget {
  final List<String> options;
  final String title;
  final String jsonKey;
  final String height;
  final String width;
  const NRGDropdown(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.options,
      required this.height,
      required this.width});

  @override
  State<NRGDropdown> createState() => _NRGDropdownState();
}

class _NRGDropdownState extends State<NRGDropdown> {
  String get _title => widget.title;
  get _options => widget.options;
  String? selectedValue;
  get _key => widget.jsonKey;
  String get _height => widget.height;
  String get _width => widget.width;

  @override
  Widget build(BuildContext context) {
    selectedValue ??= _options[0];
    return Container(
        height: double.parse(_height),
        width: double.parse(_width),
        decoration: BoxDecoration(
            color: Colors.blueGrey, borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Column(children: [
          Text(_title, style: Constants.comfortaaBold20pt),
          DropdownButton<String>(
            items: _options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
                if (newValue != null) {
                  DataEntry.exportData[_key] = newValue;
                }
              });
            },
          )
        ]));
  }
}
