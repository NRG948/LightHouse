import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

class NRGDropdown extends StatefulWidget {
  final List<String> options;
  final String title;
  final String jsonKey;
  final double height;
  final double width;
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
  double get _height => widget.height;
  double get _width => widget.width;

  @override
  void initState() {
    super.initState();
    selectedValue ??= _options[0];
    DataEntry.exportData[_key] = selectedValue;

  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Constants.pastelWhite,
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Container(
            height: _height / 2,
            width: _width / 2,
            decoration: BoxDecoration(
              color: Constants.pastelGray,
              borderRadius: BorderRadius.circular(Constants.borderRadius)
            ),
            child: Center(child: AutoSizeText(_title, style: comfortaaBold(20,color: Constants.pastelWhite),maxLines: 1,))),
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
