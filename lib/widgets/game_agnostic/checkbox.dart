import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

/// A custom togglable boolean widget.
class NRGCheckbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final String height;
  final String width;
  const NRGCheckbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width});

  @override
  State<NRGCheckbox> createState() => _NRGCheckboxState();
}

class _NRGCheckboxState extends State<NRGCheckbox> {
  String get _key => widget.jsonKey;
  bool isChecked = false;
  ValueNotifier<bool> checkboxNotifier = ValueNotifier<bool>(false);
  String get _title => widget.title;
  String get _height => widget.height;
  String get _width => widget.width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          checkboxNotifier.value = !checkboxNotifier.value;
          DataEntry.exportData[_key] =
              checkboxNotifier.value ? "true" : "false";
        },
        child: Container(
            height: double.parse(_height),
            width: double.parse(_width),
            decoration: BoxDecoration(
                color: Colors.blueGrey, borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Row(
              children: [
                ValueListenableBuilder(
                    valueListenable: checkboxNotifier,
                    builder: (context, isChecked, child) {
                      return Checkbox(
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            checkboxNotifier.value = newValue ?? false;
                          });
                    }),
                Text(_title, style: Constants.comfortaaBold20pt)
              ],
            )));
  }
}
