import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class HintText extends StatelessWidget {
  final String text;
  const HintText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,style:comfortaaBold(18));
  }
}