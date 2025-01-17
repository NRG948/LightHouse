import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class RSAutoUntimed extends StatefulWidget {
  const RSAutoUntimed({super.key});

  @override
  State<RSAutoUntimed> createState() => _RSAutoUntimedState();
}

class _RSAutoUntimedState extends State<RSAutoUntimed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:725,
      width:400,
      color: Colors.blueGrey,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RSAUCoralStation(title: "Processor CS", jsonKey: "processorCS"),
          RSAUCoralStation(title: "Barge CS", jsonKey: "bargeCS"),
        ],),
        SizedBox(height: 10),
        RSAUReef()
      ],),
    );
  }
}

class RSAUReef extends StatefulWidget {
  const RSAUReef({super.key});

  
  @override
  State<RSAUReef> createState() => _RSAUReefState();
}

class _RSAUReefState extends State<RSAUReef> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 575,
      width: 360,
      alignment: Alignment.center,
      child: Text("this should be fun :/"),

      );
  }
}

class RSAUCoralStation extends StatefulWidget {
  final String jsonKey;
  final String title;
  const RSAUCoralStation({
    super.key, required this.jsonKey, required this.title
  });

  @override
  State<RSAUCoralStation> createState() => _RSAUCoralStationState();
}

class _RSAUCoralStationState extends State<RSAUCoralStation> {
  String get title => widget.title;
  String get jsonKey => widget.jsonKey;
  late int counter;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: increment,
      child: Container(
        width: 100,
        height: 50,
        color: Constants.pastelRed,
        child: Text(title, style: comfortaaBold(18),),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    counter = 0;
  }
  void updateState() {
    DataEntry.exportData[jsonKey] = counter.toString();
  }
  void increment() {
    if (counter<99) {
      counter++;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("+1 $title: $counter"),
        action: SnackBarAction(label: "Undo", onPressed: () {
          decrement();
        }),
      ));
    }
    else {showDialog(context: context, builder: (builder) {return Dialog(child:Text("Counter $title is over limit!"));});}
    updateState();
  }
  void decrement() {
    if (counter>0) {
      counter--;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("-1 $title: $counter")));
    }
    updateState();
  }
}