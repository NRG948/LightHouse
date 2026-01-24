
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';

// A custom checkbox widget that supports three states: unable, able, and preferred.
class NRGThreeStageCheckbox extends StatefulWidget {
  final String title; // The title of the checkbox.
  final String jsonKey; // The key used to store the checkbox state in exportData.
  final double height; // The height of the checkbox container.
  final double width; // The width of the checkbox container.

  const NRGThreeStageCheckbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width});

  @override
  State<NRGThreeStageCheckbox> createState() => _NRGThreeStageCheckboxState();
}

// The state class for NRGThreeStageCheckbox.
class _NRGThreeStageCheckboxState extends State<NRGThreeStageCheckbox> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Ensures the state is kept alive when the widget is not visible.

  String get _key => widget.jsonKey; // Retrieves the jsonKey from the widget.
  CheckboxStage stage = CheckboxStage.unable; // Initial stage of the checkbox.
  ValueNotifier<CheckboxStage> checkboxNotifier = ValueNotifier<CheckboxStage>(CheckboxStage.unable); // Notifier to manage checkbox state.
  String get _title => widget.title; // Retrieves the title from the widget.
  double get _height => widget.height; // Retrieves the height from the widget.
  double get _width => widget.width; // Retrieves the width from the widget.

  // Returns the appropriate icon based on the current checkbox state.
  IconData? getCheckIcon() {
    if (checkboxNotifier.value == CheckboxStage.unable) {
      return null; // No icon for the 'unable' state.
    } else if (checkboxNotifier.value == CheckboxStage.able) {
      return const IconData(0xe156, fontFamily: 'MaterialIcons'); // Icon for the 'able' state.
    } else {
      return const IconData(0xe25b, fontFamily: 'MaterialIcons'); // Icon for the 'preferred' state.
    }
  }

  @override
  void initState() {
    super.initState();
    DataEntry.exportData[_key] = "unable"; // Initialize the exportData with 'unable' state.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
        // Updates a [ValueNotifier] to alert the checkbox when clicked.
        onTap: () {
          HapticFeedback.mediumImpact();
          // Cycle through the checkbox states: unable -> able -> preferred -> unable.
          checkboxNotifier.value = CheckboxStage.values[checkboxNotifier.value.index < 2 ? checkboxNotifier.value.index + 1 : 0];
          DataEntry.exportData[_key] = checkboxNotifier.value.name; // Update the exportData with the current state.
        },
        child: Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
                color: Constants.pastelWhite,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Updates the checkbox when [isChecked] is updated.
                Stack(
                  children: [
                    Transform.scale(
                      scale: 1.4,
                      child: Icon(
                        const IconData(0xef45, fontFamily: 'MaterialIcons') // Base icon for the checkbox.
                      ),
                    ), 
                    ValueListenableBuilder(
                      valueListenable: checkboxNotifier,
                      builder: (context, isChecked, child) {
                        return Transform.scale(
                          scale: 0.9,
                          child: Icon(
                            getCheckIcon(), 
                            color: checkboxNotifier.value == CheckboxStage.preferred ? Colors.red : Colors.black, // Change color based on state.
                          ),
                        );
                      }
                    ),
                  ]
                ),
                SizedBox(width: 3), 
                Text(_title, style: comfortaaBold(20, color: Constants.pastelBrown)), // Display the title.
              ],
            )));
  }
}

// Enum to represent the three stages of the checkbox.
enum CheckboxStage {
    unable, 
    able, 
    preferred
}