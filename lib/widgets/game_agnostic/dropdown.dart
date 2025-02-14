import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

// Define a custom dropdown widget that is stateful
class NRGDropdown extends StatefulWidget {
  // Declare properties for the widget
  final List<String> options; // List of dropdown options
  final String title; // Title of the dropdown
  final String jsonKey; // Key for storing selected value in exportData
  final double height; // Height of the dropdown container
  final double width; // Width of the dropdown container

  // Constructor for initializing the widget properties
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

// State class for NRGDropdown
class _NRGDropdownState extends State<NRGDropdown> {
  // Getter methods to access widget properties
  String get _title => widget.title;
  get _options => widget.options;
  String? selectedValue; // Variable to store the selected dropdown value
  get _key => widget.jsonKey;
  double get _height => widget.height;
  double get _width => widget.width;

  @override
  void initState() {
    super.initState();
    // Initialize selectedValue with the first option if not already set
    selectedValue ??= _options[0];
    // Store the initial selected value in DataEntry.exportData
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
            // Container for the title
            Container(
                height: _height / 2,
                width: _width / 2,
                decoration: BoxDecoration(
                    color: Constants.pastelGray,
                    borderRadius: BorderRadius.circular(Constants.borderRadius)),
                child: Center(
                    child: AutoSizeText(
                  _title,
                  style: comfortaaBold(20, color: Constants.pastelWhite),
                  maxLines: 1,
                ))),
            // Dropdown button
            DropdownButton<String>(
              items: _options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: selectedValue,
              onChanged: (String? newValue) {
                HapticFeedback.mediumImpact();
                setState(() {
                  selectedValue = newValue;
                  // Update the selected value in DataEntry.exportData
                  if (newValue != null) {
                    DataEntry.exportData[_key] = newValue;
                  }
                });
              },
            )
          ]        ));
  }
}
