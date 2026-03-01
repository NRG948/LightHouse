// ignore_for_file: type=lint

import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/amongview.dart';
import 'package:lighthouse/pages/amongview_individual.dart';
import 'package:lighthouse/pages/data_entry.dart';

class BarChartKey {
  String category;
  int value;
  /// Whether there is a space between the category when converted to a string.
  bool hasSpacing;

  BarChartKey({int? value, String? category, bool? hasSpacing}) {


    this.value = value ?? 0;
    this.category = category ?? "";
    this.hasSpacing = hasSpacing ?? false;
  }
}

enum SortType { increase, decrease, insert, custom }

class NRGBarChart extends StatefulWidget {
  String? title;
  double height;
  double width;
  int valueLength;
  Map<int, List<double>> data;
  List<int> removedKeys;
  List<Color> colors;
  List<String> labels;
  /// Whether the bar chart is in AmongView.
  bool isSus;
  dynamic sharedState;

  NRGBarChart(
      {super.key,
      required this.height,
      required this.width,
      String? title,
      int? valueLength,
      Map<int, List<double>>? data,
      List<int>? removedKeys,
      List<Color>? colors,
      List<String>? labels,
      bool? isSus,
      this.sharedState})
      : valueLength = valueLength ?? 1,
        removedKeys = removedKeys ?? [],
        colors = colors ?? [Constants.pastelRed],
        data = data ?? HashMap(),
        labels = labels ?? [""],
        isSus = isSus ?? false;

  @override
  State<StatefulWidget> createState() => _NRGBarChartState();
}

class _NRGBarChartState extends State<NRGBarChart> {
  String? get _title => widget.title;
  double get _height => widget.height;
  double get _width => widget.width;
  int get _valueLength => widget.valueLength;
  Map<int, List<double>> get _data => widget.data;
  List<Color> get _colors => widget.colors;
  List<int> get _removedKeys => widget.removedKeys;
  List<String> get _labels => widget.labels;
  bool get _isSus => widget.isSus;
  dynamic get _sharedState => widget.sharedState;
  bool isStacked = true;

  @override
  void initState() {
    super.initState();

    // Checks that the valueLength matches data, color, and labels
    for (List<double> value in _data.values) {
      if (value.length != _valueLength) {
        throw Exception(
            "Bar chart value length in data does not match the given value length.");
      }
    }
    if (_labels.length != _valueLength) {
      throw Exception(
          "Bar chart labels length does not match the given value length.");
    }
    if (_colors.length != _valueLength) {
      throw Exception(
          "Bar chart colors length does not match the given value length.");
    }

    // isStacked is set initially as true if data is empty to avoid issues if data gets added, and ends up having multiple rods.
    isStacked = _data.isEmpty ? true : _data.values.toList().first.length == 1;
  }

  /// Returns the [BarChartGroupData] object from the data.
  List<BarChartGroupData> getBarChartGroups() {
    List<BarChartGroupData> barChartGroups = List.empty();

    for (int key in _data.keys) {
      List<BarChartRodData> rods = List.empty();
      double sum = 0;
      double width = (_width - 20) / _data.length * 0.6;

      // Gets the last nonzero index to make the topmost bar rod rounded.
      int lastNonzeroIndex = -1;
      for (int i = _data[key]!.length - 1; i >= 0; i--) {
        if (_data[key]![i] != 0) {
          lastNonzeroIndex = i;
          break;
        }
      }

      for (int i = 0; i < _data[key]!.length; i++) {
        double newSum = sum + _data[key]![i];
        Color color = _removedKeys.contains(key)
            ? _colors[i]
            : (i % 2 == 0 ? Colors.grey : Colors.blueGrey);
        BorderRadius border = i == lastNonzeroIndex
            ? BorderRadius.only(
                topLeft: Radius.circular(7), topRight: Radius.circular(7))
            : BorderRadius.zero;

        rods.add(BarChartRodData(
          fromY: sum,
          toY: newSum,
          color: color,
          borderRadius: border,
          width: width,
        ));

        sum = newSum;
      }

      barChartGroups.add(BarChartGroupData(
        x: key,
        groupVertically: true,
        barRods: rods,
      ));
    }

    return barChartGroups;
  }

  /// Returns the average of each category in [_data] excluding specified data from [_removedKeys]. Returns 0 if there are no unremoved keys.
  List<double> getAverageData() {
    int rodCount = _data.values.toList().first.length;
    List<int> keys = _data.keys.toList();
    List<double> averages = List.empty();

    // If there are no unremoved data.
    if (_data.length - _removedKeys.length == 0) {
      return List.filled(rodCount, 0);
    }

    for (int i = 0; i < rodCount; i++) {
      double sum = 0;
      for (int key in keys) {
        if (_removedKeys.contains(key)) continue;
        sum += _data[key]![i];
      }

      averages.add(sum / (keys.length - _removedKeys.length));
    }

    return averages;
  }

  /// Gets a row of texts or a single text depending on the type of graph.
  Widget getAverageText() {
    if (_data.isEmpty) {
      // Return empty container. Single average moved to title.
      return Container();
    } else {
      // Column of texts for multi data
      List<Widget> texts = [];
      List<double> averages = getAverageData();

      for (int i = 0; i < averages.length; i++) {
        texts.add(_getSingleText(averages[i], _colors[i], _labels[i]));
      }

      return Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: texts.reversed.toList());
    }
  }

  /// Helper method to create a single text widget.
  Widget _getSingleText(double average, Color color, String label) =>
      Text("$label: ${roundAtPlace(average, 2)}",
          style: comfortaaBold(_width / 17,
              color: color, customFontWeight: FontWeight.w900));

  /// Returns the sum of an [Iterable].
  double sum(Iterable l) => l.fold(0.0, (x, y) => x + y);

  /// Rounds a number to a specified number of decimal places.
  num roundAtPlace(double number, int place) =>
      num.parse(number.toStringAsFixed(place));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Title Text.
          if (_title != null)
            Text("$_title (${roundAtPlace(getAverageData().sum, 2)})",
                style:
                    comfortaaBold(_height / 10, color: Constants.pastelBrown)),
          // AspectRatio necessary to prevent BarChart from throwing a formatting error.
          Container(
            width: _width,
            height: _height * (_data.values.isEmpty ? 0.7 : 0.6),
            margin: EdgeInsets.only(right: 20),
            child: BarChart(BarChartData(
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    reservedSize: 30,
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) =>
                        SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(value.toStringAsFixed(1),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Constants.pastelBrown,
                                    fontSize: 12))),
                  )),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return widget.amongviewMatches.isEmpty
                          ? SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: Text('${value.toInt()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: !_removedData.contains(value)
                                          ? Constants.pastelBrown
                                          : Colors.grey,
                                      fontSize: 12)))
                          : SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: Text(
                                getParsedMatchInfo(value.toInt(),
                                    truncated: true)[0],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: !_removedData.contains(value)
                                        ? Constants.pastelBrown
                                        : Colors.grey,
                                    fontSize: 12),
                              ),
                            );
                    },
                  )),
                ),
                barTouchData: (widget.amongviewTeams.isNotEmpty ||
                        widget.amongviewMatches.isNotEmpty)
                    ? BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) =>
                              Color.fromARGB(200, 255, 255, 255),
                        ),
                        touchCallback:
                            (FlTouchEvent event, BarTouchResponse? response) {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.spot == null) {
                            return;
                          }
                          if (widget.sharedState != null) {
                            if (widget.amongviewTeams.isNotEmpty) {
                              widget.sharedState!.setClickedTeam(
                                  widget.amongviewTeams[
                                      response.spot!.touchedBarGroupIndex]);
                            }
                            if (widget.amongviewMatches.isNotEmpty) {
                              widget.sharedState!.setClickedMatch(
                                  widget.amongviewMatches[
                                      response.spot!.touchedBarGroupIndex]);
                            }
                          }
                        },
                      )
                    : BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) =>
                              Color.fromARGB(200, 255, 255, 255),
                        )),
                barGroups: _multiData!.isEmpty
                    ? getBarGroups(widget.hashMap.isNotEmpty)
                    : getMultiBarGroups(),
                gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (x) =>
                        const FlLine(color: Colors.grey, strokeWidth: 1)))),
          ),
          // Average value text.
          if (widget.chartOnly != true) getAverageText(),
          if (widget.chartOnly == true)
            SizedBox(
              height: 30,
            )
        ],
      ),
    );
  }
}
