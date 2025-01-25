import 'package:flutter/material.dart';

class Constants {
  static Color pastelRed = Color.fromARGB(255, 227, 150, 136);
  static Color pastelYellow = Color.fromARGB(255, 237, 193, 142);
  static Color pastelWhite = Color.fromARGB(255, 250, 242, 240);
  static Color pastelBlue = Color.fromARGB(255, 0, 204, 255,);
  static Color pastelBlueAgain = Color.fromARGB(255, 111, 163, 195);
  static Color ufogreen = Color.fromARGB(255,60,208,125); 
  static Color magenta = Color.fromARGB(255,255,0,255);


  static Color pastelGray = Color.fromARGB(255, 199, 185, 186);
  static Color pastelReddishBrown = Color.fromARGB(255, 103, 50, 47);
  static Color pastelRedMuted = Color.fromARGB(255, 162, 90, 83);
  static TextStyle comfortaaBold30pt = TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, color: Colors.white,fontSize:30);
  static TextStyle comfortaaBold20pt = TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, color: Colors.white,fontSize:20);
  static TextStyle comfortaaBold10pt = TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, color: Colors.white,fontSize:10);

  static final double borderRadius = 8;
}

TextStyle comfortaaBold(double fontSize,
    {bool bold = true,
    Color color = Colors.white,
    FontWeight? customFontWeight,
    bool italic = false}) {
  return TextStyle(
      fontFamily: "Comfortaa",
      fontWeight:
          customFontWeight ?? (bold ? FontWeight.bold : FontWeight.normal),
      color: color,
      fontSize: fontSize,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal);
}
