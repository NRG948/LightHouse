import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/data_entry.dart";


// TODO: Implement Dropdown
class NRGDropdown extends StatefulWidget {
  final List<String> options;
  final String title;
  final String jsonKey;
  const NRGDropdown({super.key, this.title="Dropdown", this.jsonKey="unnamed", this.options=const ["unnamed","unnamed 2"]});
  
  @override
  State<NRGDropdown> createState() => _NRGDropdownState();
}

class _NRGDropdownState extends State<NRGDropdown> {

  String get _title => widget.title;
  
  get _options => widget.options;
  String? selectedValue;
  get _key => widget.jsonKey;

  @override
  Widget build(BuildContext context) {
    selectedValue ??= _options[0];
    return Container(
      height: 100,
      width: 400,
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(_title, style: Constants.comfortaaBold20pt),
          DropdownButton<String>(
            items: _options.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(value: value,child: Text(value),);
              }
            ).toList(),
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
                if (newValue != null) {DataEntry.exportData[_key] = newValue;}
              });
            },
          )
        ]
      )
    );
  }
}