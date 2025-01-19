import 'package:flutter/material.dart';

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