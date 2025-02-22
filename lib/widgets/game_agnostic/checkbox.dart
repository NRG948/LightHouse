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
  final double height; // The height of the checkbox widget.
  final double width; // The width of the checkbox widget.
  final bool
      vertical; // Determines if the checkbox and title are arranged vertically or horizontally.
  const NRGCheckbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      this.vertical = false});

  @override
  State<NRGCheckbox> createState() => _NRGCheckboxState();
}

class _NRGCheckboxState extends State<NRGCheckbox> {
  String get _key => widget.jsonKey; // Getter for the jsonKey.
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
    DataEntry.exportData[widget.jsonKey] = false;
  }

  @override
  Widget build(BuildContext context) {
    // Determine the layout based on the vertical property.
    Widget rowOrColumn = widget.vertical
        ? Column(
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
                            // Update the checkbox state.
                            checkboxNotifier.value = newValue ?? false;
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
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          HapticFeedback.mediumImpact();
                          // Update the checkbox state.
                          checkboxNotifier.value = newValue ?? false;
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
          // Toggle the checkbox state.
          checkboxNotifier.value = !checkboxNotifier.value;
          // Update the exportData with the new state.
          DataEntry.exportData[_key] = checkboxNotifier.value;
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
