import 'package:flutter/material.dart';
import 'package:lighthouse/filemgr.dart';

class NRGPlaceholder extends StatefulWidget {
  final String title;
  final String jsonKey;
  final String height;
  final String width;
  const NRGPlaceholder({super.key,required this.title,required this.jsonKey, required this.height,required this.width});

  @override
  State<NRGPlaceholder> createState() => _NRGPlaceholderState();
}

class _NRGPlaceholderState extends State<NRGPlaceholder> {
  String get _height => widget.height;
  
  String get _width => widget.width;
  
  String get title => widget.title;
  
  get _key => widget.jsonKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.parse(_height),
      width: double.parse(_width),
      decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(8)),
      child: 
          Text("Placeholder $title")
      );
  }

  @override
  void initState() {
    super.initState();
    configData[_key] = "placeholder";
  }
}