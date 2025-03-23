import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

// Stateful widget for NRG Rating
class NRGRating extends StatefulWidget {
  final String title; // Title of the rating widget
  final String jsonKey; // Key for storing the rating value in JSON
  final double height; // Height of the widget
  final double width; // Width of the widget
  final bool clearable;

  const NRGRating({
    super.key,
    required this.title,
    required this.jsonKey,
    required this.height,
    required this.width,
    required this.clearable,
  });

  @override
  State<NRGRating> createState() => _NRGRatingState();
}

// State class for NRGRating
class _NRGRatingState extends State<NRGRating>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Initialize the rating value in exportData
    DataEntry.exportData[widget.jsonKey] = widget.clearable ? null : 0;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        children: [
          SizedBox(
            height: 0.05 * widget.height,
          ),
          Container(
            width: 0.5 * widget.width,
            height: 0.3 * widget.height,
            decoration: BoxDecoration(
                color: Constants.pastelGray,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: AutoSizeText(
              widget.title,
              style: comfortaaBold(20),
              textAlign: TextAlign.center,
            ),
          ),
          // Star rating widget
          StarRating(
            onRatingChanged: (value) {
              // Update the rating value in exportData
              DataEntry.exportData[widget.jsonKey] = value;
            },
            starSize: 0.6 * widget.height,
            clearable: widget.clearable, 
          ),
        ],
      ),
    );
  }
}

// Stateful widget for star rating
class StarRating extends StatefulWidget {
  final double initialRating; // Initial rating value
  final ValueChanged<double?> onRatingChanged; // Callback for rating changes
  final Color activeColor; // Color for filled stars
  final Color inactiveColor; // Color for unfilled stars
  final double starSize; // Size of the star icons
  final bool clearable;

  const StarRating({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingChanged,
    this.activeColor = Colors.amber,
    this.inactiveColor = Constants.pastelGray,
    this.starSize = 30.0,
    this.clearable = false, 
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

// State class for StarRating
class _StarRatingState extends State<StarRating> {
  late double? _currentRating; // Current rating value

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating; // Initialize current rating
  }

  // Update the rating value and notify parent widget
  void _updateRating(double? newRating) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentRating = newRating;
    });
    widget.onRatingChanged(_currentRating); // Notify parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: widget.starSize / 8,
        children: [
          ...List.generate(5, (index) {
            double starValue = index + 1; // Full star value
            double halfStarValue = index + 0.5; // Half-star value

            IconData icon;
            if ((_currentRating ?? 0) >= starValue) {
              icon = Icons.star; // Fully filled star
            } else if ((_currentRating ?? 0) >= halfStarValue) {
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
          widget.clearable ? GestureDetector(
            onTap: () {
              _updateRating(null);
            },
            child: Container(
              width: 0.7 * widget.starSize,
              height: 0.7 * widget.starSize,
              decoration: BoxDecoration(
                  color: Constants.pastelRedSuperDark,
                  borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Center(
                  child: AutoSizeText(
                "C",
                style: comfortaaBold(20),
                textAlign: TextAlign.end,
              )),
            ),
          )  : SizedBox()
        ]);
  }
}
