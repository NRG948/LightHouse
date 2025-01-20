import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class NRGThreeStageCheckbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  const NRGThreeStageCheckbox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width});

  @override
  State<NRGThreeStageCheckbox> createState() => _NRGThreeStageCheckboxState();
}

class _NRGThreeStageCheckboxState extends State<NRGThreeStageCheckbox> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  String get _key => widget.jsonKey;
  CheckboxStage stage = CheckboxStage.unable;
  ValueNotifier<CheckboxStage> checkboxNotifier = ValueNotifier<CheckboxStage>(CheckboxStage.unable);
  String get _title => widget.title;
  double get _height => widget.height;
  double get _width => widget.width;

  IconData? getCheckIcon() {
    if (checkboxNotifier.value == CheckboxStage.unable) {
      return null;
    } else if (checkboxNotifier.value == CheckboxStage.able) {
      return IconData(0xe156, fontFamily: 'MaterialIcons');
    } else {
      return IconData(0xe25b, fontFamily: 'MaterialIcons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // Updates a [ValueNotifier] to alert the checkbox when clicked.
        onTap: () {
          checkboxNotifier.value = CheckboxStage.values[checkboxNotifier.value.index < 2 ? checkboxNotifier.value.index + 1 : 0];
          DataEntry.exportData[_key] =
              checkboxNotifier.value.name;
        },
        child: Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Row(
              children: [
                // Updates the checkbox when [isChecked] is updated.
                Stack(
                  children: [
                    Transform.scale(
                      scale: 1.4,
                      child: Icon(
                        IconData(0xef45, fontFamily: 'MaterialIcons')
                      ),
                    ), 
                    ValueListenableBuilder(
                      valueListenable: checkboxNotifier,
                      builder: (context, isChecked, child) {
                        return Transform.scale(
                          scale: 0.9,
                          child: Icon(
                            getCheckIcon(), 
                            color: checkboxNotifier.value == CheckboxStage.preferred ? Colors.red : Colors.black,
                          ),
                        );
                      }
                    ),
                  ]
                ),
                Text(_title, style: Constants.comfortaaBold20pt), 
              ],
            )));
  }
}

enum CheckboxStage {
    unable, 
    able, 
    preferred
}