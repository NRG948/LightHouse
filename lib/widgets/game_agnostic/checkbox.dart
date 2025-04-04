import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

// A custom checkbox widget that can be used in different parts of the app.
class NRGCheckbox extends StatefulWidget {
  final String title; // The title of the checkbox.
  final String
      jsonKey; // The key used to store the checkbox state in exportData.
  final dynamic jsonKeyPath; // alternate path to provide more control
  final double height; // The height of the checkbox widget.
  final double width; // The width of the checkbox widget.
  final bool
      vertical; // Determines if the checkbox and title are arranged vertically or horizontally.
  const NRGCheckbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      this.jsonKeyPath,
      required this.height,
      required this.width,
      this.vertical = false});

  @override
  State<NRGCheckbox> createState() => _NRGCheckboxState();
}

class _NRGCheckboxState extends State<NRGCheckbox> {
  String get _key => widget.jsonKey; // Getter for the jsonKey.
  dynamic get _keyPath => widget.jsonKeyPath;
  bool isChecked = false; // Initial state of the checkbox.

  // Notifier to update the checkbox state.
  ValueNotifier<bool> checkboxNotifier = ValueNotifier<bool>(false);
  String get _title => widget.title; // Getter for the title.
  double get _height => widget.height; // Getter for the height.
  double get _width => widget.width; // Getter for the width.

  @override
  void initState() {
    super.initState();
    // Initialize the exportData with the checkbox state.
    if (_keyPath == null) {
      DataEntry.exportData[widget.jsonKey] = false;
    } else {
      _keyPath![widget.jsonKey] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the layout based on the vertical property.
    Widget rowOrColumn = widget.vertical
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Updates the checkbox when [isChecked] is updated.
              ValueListenableBuilder(
                  valueListenable: checkboxNotifier,
                  builder: (context, isChecked, child) {
                    return SizedBox(
                      width: 0.35 * _width,
                      height: 0.35 * _height,
                      child: Checkbox(
                          value: isChecked,
                          visualDensity: VisualDensity.compact,
                          onChanged: (bool? newValue) {
                            setState(() {
                              // Toggle the checkbox state.
                              checkboxNotifier.value = !checkboxNotifier.value;
                              HapticFeedback.mediumImpact();
                              // Update the exportData with the new state.
                              if (_keyPath == null) {
                                DataEntry.exportData[_key] =
                                    checkboxNotifier.value;
                              } else {
                                _keyPath![widget.jsonKey] =
                                    checkboxNotifier.value;
                              }
                            });
                          }),
                    );
                  }),
              SizedBox(
                  width: _width * 0.65,
                  height: 0.35 * _height,
                  child: AutoSizeText(
                    _title,
                    style: comfortaaBold(20, color: Colors.black),
                    maxLines: 2,
                    minFontSize: 9,
                    textAlign: TextAlign.center,
                  ))
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Updates the checkbox when [isChecked] is updated.
              ValueListenableBuilder(
                  valueListenable: checkboxNotifier,
                  builder: (context, isChecked, child) {
                    return Checkbox(
                        value: _keyPath == null
                            ? DataEntry.exportData[_key]
                            : _keyPath![widget.jsonKey],
                        onChanged: (bool? newValue) {
                          setState(() {
                            // Toggle the checkbox state.
                            checkboxNotifier.value = !checkboxNotifier.value;
                            HapticFeedback.mediumImpact();
                            // Update the exportData with the new state.
                            if (_keyPath == null) {
                              DataEntry.exportData[_key] =
                                  checkboxNotifier.value;
                            } else {
                              _keyPath![widget.jsonKey] =
                                  checkboxNotifier.value;
                            }
                          });
                        });
                  }),
              SizedBox(
                  width: _width * 0.65,
                  child: AutoSizeText(
                    _title,
                    style: comfortaaBold(20, color: Colors.black),
                    maxLines: 1,
                    minFontSize: 9,
                  ))
            ],
          );

    return GestureDetector(
        // Updates a [ValueNotifier] to alert the checkbox when clicked.
        onTap: () {
          setState(() {
            // Toggle the checkbox state.
            checkboxNotifier.value = !checkboxNotifier.value;
            HapticFeedback.mediumImpact();
            // Update the exportData with the new state.
            if (_keyPath == null) {
              DataEntry.exportData[_key] = checkboxNotifier.value;
            } else {
              _keyPath![widget.jsonKey] = checkboxNotifier.value;
            }
          });
        },
        child: Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
                color: Constants.pastelWhite,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: rowOrColumn));
  }
}
