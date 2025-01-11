import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";


class NRGCheckbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  const NRGCheckbox({super.key, this.title="Checkbox", this.jsonKey="unnamed"});

  @override
  State<NRGCheckbox> createState() => _NRGCheckboxState();
}

class _NRGCheckboxState extends State<NRGCheckbox> {
  String get _key => widget.jsonKey;
  bool isChecked = false;
  ValueNotifier<bool> checkboxNotifier = ValueNotifier<bool>(false);
  String get _title => widget.title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        checkboxNotifier.value = !checkboxNotifier.value; 
        DataEntry.exportData[_key] = checkboxNotifier.value ? "true" : "false";
      },
      child: Container(
        height: 100,
        width: 400,
        decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            ValueListenableBuilder(
              valueListenable: checkboxNotifier,
              builder: (context, isChecked, child) {
                return Checkbox(
                  value: isChecked,
                  onChanged: (bool? newValue) {
                    checkboxNotifier.value = newValue ?? false;
                  }
                );
              }
            ),
            Text(_title, style: Constants.comfortaaBold20pt,)
          ],
        )
      )
    );
  }
}