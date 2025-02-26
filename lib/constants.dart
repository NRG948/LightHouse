import 'package:flutter/material.dart';

class Constants {
  static const Color pastelRed = Color.fromARGB(255, 227, 150, 136);
  static const Color pastelYellow = Color.fromARGB(255, 237, 193, 142);
  static const Color pastelWhite = Color.fromARGB(255, 250, 242, 240);
  static const Color pastelBlue = Color.fromARGB(255, 0, 204, 255,);
  static const Color pastelBlueMuted = Color.fromARGB(255, 0, 164, 215,);
  static const Color pastelBlueAgain = Color.fromARGB(255, 111, 163, 195);
  static const Color pastelGreen = Color.fromARGB(255, 189, 230, 127);
  static const Color markerLightGray = Color.fromARGB(255, 120, 120, 120);
  static const Color markerDarkGray = Color.fromARGB(255, 92, 92, 92);
  static const Color ufogreen = Color.fromARGB(255,60,208,125); 
  static const Color magenta = Color.fromARGB(255,255,0,255);

  static const Color pastelGray = Color.fromARGB(255, 199, 185, 186);
  static const Color pastelReddishBrown = Color.fromARGB(255, 103, 50, 47);
  static const Color pastelRedMuted = Color.fromARGB(255, 162, 90, 83);

  static const List<Color> reefColors = [
      Color.fromARGB(255, 195, 103, 191), // L1
      Color.fromARGB(255, 77, 110, 211), // L2
      Color.fromARGB(255, 82, 197, 69), // L3
      Color.fromARGB(255, 236, 87, 87), // L4
      Color.fromARGB(255, 90, 216, 179) // Algae
  ];
  
  static final double borderRadius = 8;
  /// There is always a delay between the end of, for example, 
  /// auto and the start of teleop. Thus, this is simply for
  /// adding a bit of delay before the next section. :)
  static final double startDelay = 3;
  
  static const String versionName = "Feb 16 Update";

}

TextStyle comfortaaBold(double fontSize,
    {bool bold = true,
    Color color = Colors.white,
    FontWeight? customFontWeight,
    bool italic = false,
    double? spacing}) {
  return TextStyle(
      fontFamily: "Comfortaa",
      fontWeight:
          customFontWeight ?? (bold ? FontWeight.bold : FontWeight.normal),
      color: color,
      fontSize: fontSize,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      letterSpacing: spacing
      );
}


final Map<int,String> responseCodes = {
  200:"OK",
  301:"Permanantly Moved",
  400: "Bad Request",
  404:"File Not Found",
};

extension StringExtensions on String {
  String get toSentenceCase => replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (Match m) => '${m[1]} ${m[2]}',
  ).replaceFirstMapped(
    RegExp(r'^[a-z]'),
    (Match m) => m[0]!.toUpperCase(),
  );
}
extension DoubleExtensions on double {
  double get fourDigits => double.parse(toStringAsFixed(4));
}