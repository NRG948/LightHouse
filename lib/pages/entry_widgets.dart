import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/data_entry.dart";

// Redudant - has been moved to lighthosue/widgets


class NRGSpinbox extends StatefulWidget {
  final String title;
  final String jsonKey;
  const NRGSpinbox({super.key, this.title = "Spinbox", this.jsonKey = "unnamed"});

  @override
  State<NRGSpinbox> createState() => _NRGSpinboxState();
}

class _NRGSpinboxState extends State<NRGSpinbox> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  late int _counter;
  String _value = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 400,
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(_title, style: Constants.comfortaaBold30pt),
          Center(
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                IconButton(onPressed:() {decrement();}, icon: Icon(Icons.keyboard_arrow_down,)),
                Text("$_counter", style: Constants.comfortaaBold30pt,),
                IconButton(onPressed:() {increment();}, icon: Icon(Icons.keyboard_arrow_up,)),
              ],
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  void decrement() {
    setState(
      () { if (_counter > 0) {_counter--; updateState();} }
    );
  }

  void increment() {
    setState(
      () {
        _counter++;
        updateState();
      }
    );
  }

  void updateState() {
    _value = _counter.toString();
    DataEntry.exportData[_key] = _value;
  }
}

class NRGTextBox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final String height;
  final bool numeric;
  const NRGTextBox({super.key, this.title="Text Box", this.jsonKey = "unnamed", this.height = "100", this.numeric = false});

  @override
  State<NRGTextBox> createState() => _NRGTextBoxState();
}

class _NRGTextBoxState extends State<NRGTextBox> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  String get _height => widget.height;
  bool get _numeric => widget.numeric;
  final TextEditingController _controller = TextEditingController();


  // Apparently all this TextEditingController BS can just be done by passing a lambda to the onChanged
  // parameter of a TextField, but this method lets us set an initial value sooooooo
  // idk
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {setState(() {
       DataEntry.exportData[_key] = _controller.text;

    });});
  }

  // idk what this one does but gpt demands it
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.parse(_height),
      width: 400,
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(_title, style: Constants.comfortaaBold20pt),
          TextField(
            keyboardType: _numeric ? TextInputType.text : TextInputType.number,
            inputFormatters: _numeric ? [FilteringTextInputFormatter.digitsOnly] : [],
            controller: _controller,
            decoration: InputDecoration(labelText: "Enter Text", labelStyle: Constants.comfortaaBold20pt, border: OutlineInputBorder()),
            maxLines: double.parse(_height).toInt() > 100 ? 5 : 1 // Probably shouldn't be hard-coded but fine for now
          )
        ],
      )
      
      );
  }
}

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
      child:Column(children: [
        Text(_title, style: Constants.comfortaaBold20pt),
        DropdownButton<String>(
          items: _options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value,child: Text(value),);
          }).toList(),
          value: selectedValue,
          onChanged: (String? newValue) {setState(() {
            selectedValue = newValue;
            if (newValue != null) {DataEntry.exportData[_key] = newValue;}
          });},


        )
      ])
      );
  }
}


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
      child: Row(children: [
        ValueListenableBuilder(valueListenable: checkboxNotifier, builder: (context, isChecked, child) {
          return Checkbox(
            value: isChecked,
            onChanged: (bool? newValue) {
              checkboxNotifier.value = newValue ?? false;
            }
          );
        }),
        Text(_title, style: Constants.comfortaaBold20pt,)
      ],)
    ));
  }
}


class BoxForSettings extends StatefulWidget {
  final String title;
  final String jsonKey;
  const BoxForSettings({super.key, this.title="Text Box", this.jsonKey = "unnamed"});

  @override
  State<BoxForSettings> createState() => _BoxForSettingsState();
}

class _BoxForSettingsState extends State<BoxForSettings> {
  String get _title => widget.title;
  String get _key => widget.jsonKey;
  final TextEditingController _controller = TextEditingController();


  // Apparently all this TextEditingController BS can just be done by passing a lambda to the onChanged
  // parameter of a TextField, but this method lets us set an initial value sooooooo
  // idk
  @override
  void initState() {
    super.initState();
    _controller.text = configData[_key]!;
    _controller.addListener(() {setState(() {
      configData[_key] = _controller.text;
    });});
  }

  // idk what this one does but gpt demands it
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 400,
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(_title, style: Constants.comfortaaBold20pt),
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Enter Text", labelStyle: Constants.comfortaaBold20pt, border: OutlineInputBorder()),
          )
             
             
        ],
      )
      
      );
  }
}