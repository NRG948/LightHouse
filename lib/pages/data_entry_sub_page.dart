import 'package:flutter/material.dart';

class DataEntrySubPage extends StatefulWidget {
  const DataEntrySubPage(
      {super.key, required this.content, required this.icon});
  // TODO: Decide if this should be Container or Widget
  final Container content;
  final IconData icon;

  @override
  State<DataEntrySubPage> createState() => DataEntrySubPageState();
}

class DataEntrySubPageState extends State<DataEntrySubPage> {
  Container get _content => widget.content;
  @override
  Widget build(Object context) {
    return _content;
  }
}
