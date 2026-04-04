import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';

class MatchPrediction extends StatefulWidget {
  final double margin;
  final String? jsonKey;

  const MatchPrediction({super.key, required this.margin, this.jsonKey});

  @override
  State<MatchPrediction> createState() => _MatchPredictionState();
}

class _MatchPredictionState extends State<MatchPrediction> {
  double get _margin => widget.margin;
  String? get _jsonKey => widget.jsonKey;

  String _prediction = "";
  /// The amount of time in seconds since epoch the prediction was made
  int _timePredicted = 0;

  @override
  void initState() {
    super.initState();
    _serializeData();
  }

  void _serializeData() {
    if (_jsonKey == null) return;

    DataEntry.exportData[_jsonKey!] = <String, dynamic>{
      "prediction": _prediction,
      "time": _timePredicted,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.5,
      child: DefaultContainer(
        margin: _margin,
        child: Column(
          spacing: _margin / 2,
          children: [
            AutoSizeText(
              "Match Prediction",
              style: comfortaaBold(17, color: context.colors.containerText),
            ),
            Expanded(
              child: Row(
                spacing: _margin,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapUp: (details) {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _prediction = _prediction == "red" ? "" : "red";
                          _timePredicted =
                              (DateTime.now().millisecondsSinceEpoch / 1000)
                                  .floor();
                          _serializeData();
                        });
                      },
                      child: DefaultContainer(
                        color: _prediction == "red"
                            ? context.colors.red
                            : Colors.transparent,
                        borderColor: _prediction == "blue"
                            ? context.colors.muted
                            : context.colors.red,
                        borderWidth: _margin / 3,
                        child: AutoSizeText(
                          "Red Alliance",
                          textAlign: TextAlign.center,
                          style: comfortaaBold(
                            17,
                            color: _prediction == "red"
                                ? context.colors.container
                                : (_prediction == "blue"
                                    ? context.colors.muted
                                    : context.colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTapUp: (details) {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _prediction = _prediction == "blue" ? "" : "blue";
                          _timePredicted =
                              (DateTime.now().millisecondsSinceEpoch / 1000)
                                  .floor();
                          _serializeData();
                        });
                      },
                      child: DefaultContainer(
                        color: _prediction == "blue"
                            ? context.colors.blue
                            : Colors.transparent,
                        borderColor: _prediction == "red"
                            ? context.colors.muted
                            : context.colors.blue,
                        borderWidth: _margin / 3,
                        child: AutoSizeText(
                          "Blue Alliance",
                          textAlign: TextAlign.center,
                          style: comfortaaBold(
                            17,
                            color: _prediction == "blue"
                                ? context.colors.container
                                : (_prediction == "red"
                                    ? context.colors.muted
                                    : context.colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
