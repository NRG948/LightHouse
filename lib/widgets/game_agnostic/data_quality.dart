import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';
import 'package:lighthouse/widgets/game_agnostic/placeholder.dart';

class NRGDataQuality extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double width;
  const NRGDataQuality(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width,
      });

  @override
  State<NRGDataQuality> createState() => _NRGDataQualityState(); 
}

class _NRGDataQualityState extends State<NRGDataQuality> {

  @override void initState() {
    super.initState();
    DataEntry.exportData[widget.jsonKey] = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(color: Constants.pastelWhite,borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        children: [
          SizedBox(height: 0.05 * widget.height,),
          Container(
            width: 0.5 * widget.width,
            height: 0.3 * widget.height,
            decoration: BoxDecoration(color: Constants.pastelGray,borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: AutoSizeText("DATA QUALITY",style: comfortaaBold(20),textAlign: TextAlign.center,),
          ),
          StarRating(onRatingChanged: (value) {
            DataEntry.exportData["dataQuality"] = value;
          },starSize: 0.15 * widget.width,)
        ],
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  final double initialRating; // Initial rating value
  final ValueChanged<double> onRatingChanged; // Callback for rating changes
  final Color activeColor; // Color for filled stars
  final Color inactiveColor; // Color for unfilled stars
  final double starSize; // Size of the star icons

  const StarRating({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingChanged,
    this.activeColor = Colors.amber,
    this.inactiveColor = Constants.pastelGray,
    this.starSize = 30.0,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _updateRating(double newRating) {
    setState(() {
      _currentRating = newRating;
    });
    widget.onRatingChanged(_currentRating); // Notify parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double starValue = index + 1; // Full star value
        double halfStarValue = index + 0.5; // Half-star value

        IconData icon;
        if (_currentRating >= starValue) {
          icon = Icons.star; // Fully filled star
        } else if (_currentRating >= halfStarValue) {
          icon = Icons.star_half; // Half-filled star
        } else {
          icon = Icons.star_border; // Empty star
        }

        return GestureDetector(
          onTapDown: (details) {
            // Detect tap position to determine half or full star
            double tapPosition = details.localPosition.dx;
            double newRating = tapPosition <= widget.starSize / 2
                ? halfStarValue
                : starValue; // Half or full star
            _updateRating(newRating);
          },
          child: Icon(
            icon,
            color: icon == Icons.star_border
                ? widget.inactiveColor
                : widget.activeColor,
            size: widget.starSize,
          ),
        );
      }),
    );
  }
}