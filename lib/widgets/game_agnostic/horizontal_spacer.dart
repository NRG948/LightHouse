import 'package:flutter/material.dart';

// A widget that provides a horizontal space of a specified width.
class NRGHorizontalSpacer extends StatelessWidget {
  final double width;
  const NRGHorizontalSpacer(
    {
      super.key, 
      required this.width, 
    }
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    ); 
  }
}