import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";

class NRGCheckbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  final bool vertical;
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
  String get _key => widget.jsonKey;
  bool isChecked = false;

  ValueNotifier<bool> checkboxNotifier = ValueNotifier<bool>(false);
  String get _title => widget.title;
  double get _height => widget.height;
  double get _width => widget.width;

  @override
  Widget build(BuildContext context) {
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
            children: [
              // Updates the checkbox when [isChecked] is updated.
              ValueListenableBuilder(
                  valueListenable: checkboxNotifier,
                  builder: (context, isChecked, child) {
                    return Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
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
          checkboxNotifier.value = !checkboxNotifier.value;
          DataEntry.exportData[_key] =
              checkboxNotifier.value ? "true" : "false";
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
