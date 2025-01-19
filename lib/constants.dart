import 'package:flutter/material.dart';

class Constants {
  static Color pastelRed = Color.fromARGB(255, 227, 150, 136);
  static Color pastelYellow = Color.fromARGB(255, 237, 193, 142);
  static Color pastelWhite = Color.fromARGB(255, 250, 242, 240);

  static TextStyle comfortaaBold30pt = TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, color: Colors.white,fontSize:30);
  static TextStyle comfortaaBold20pt = TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, color: Colors.white,fontSize:20);
  static TextStyle comfortaaBold10pt = TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, color: Colors.white,fontSize:10);

  static final double borderRadius = 8;
}

TextStyle comfortaaBold(double fontSize,{bool bold=true, Color color = Colors.white}) {
  return TextStyle(fontFamily: "Comfortaa", fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color, fontSize:fontSize);
}