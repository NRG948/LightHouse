import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final double starRating;
  final double iconSize;
  final Color iconColor;
  const StarDisplay({super.key, required this.starRating, this.iconSize = 20, this.iconColor=Colors.amber});

  @override
  Widget build(BuildContext context) {
    if (starRating < 0.0 || starRating > 5.0 || starRating % 0.5 != 0) {
      return Text("ERROR: Invalid rating");
    }
     List<Widget> stars = [];
    
    for (int i = 1; i <= 5; i++) {
      if (starRating >= i) {
        stars.add(Icon(Icons.star, color: iconColor,size: iconSize));
      } else if (starRating >= i - 0.5) {
        stars.add(Icon(Icons.star_half, color: iconColor,size:iconSize));
      } else {
        stars.add(Icon(Icons.star_border, color: iconColor,size: iconSize,));
      }
    }

    return Row(children: stars);
  }
}