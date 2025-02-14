import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/amongview.dart';
import 'package:lighthouse/pages/amongview_individual.dart';
import 'package:lighthouse/pages/data_entry.dart';

/// A horizontal bar chart widget that displays numbers, automatically sorting by key.
class NRGBarChart extends StatefulWidget {
  // Widget properties
  String title;
  double height;
  double width;
  SplayTreeMap<int, double> data;
  SplayTreeMap<int, List<double>> multiData;
  List<int> removedData;
  Color color;
  List<Color> multiColor;
  String dataLabel;
  List<String> dataLabels;
  List<int> amongviewTeams;
  List<int> amongviewMatches;
  LinkedHashMap hashMap;
  dynamic sharedState;
  bool? chartOnly;

  // Constructor with named parameters and default values
  NRGBarChart(
      {super.key,
      required this.title,
      required this.height,
      required this.width,
      Color? color,
      SplayTreeMap<int, double>? data,
      List<int>? removedData,
      SplayTreeMap<int, List<double>>? multiData,
      List<Color>? multiColor,
      String? dataLabel,
      List<String>? dataLabels,
      LinkedHashMap? hashMap,
      List<int>? amongviewTeams,
      List<int>? amongviewMatches,
      bool? chartOnly,
      this.sharedState})
      : removedData = removedData ?? [],
        color = color ?? Colors.transparent,
        data = data ?? SplayTreeMap(),
        multiData = multiData ?? SplayTreeMap(),
        multiColor = multiColor ?? [],
        dataLabel = dataLabel ?? "AVG",
        dataLabels = dataLabels ?? ["AVG"],
        amongviewTeams = amongviewTeams ?? [],
        amongviewMatches = amongviewMatches ?? [],
        hashMap = hashMap ?? LinkedHashMap(),
        chartOnly = chartOnly ?? false;

  @override
  State<StatefulWidget> createState() => _NRGBarChartState();
}

class _NRGBarChartState extends State<NRGBarChart> {
  // Getters for widget properties
  String get _title => widget.title;
  double get _height => widget.height;
  double get _width => widget.width;
  SplayTreeMap<int, double>? get _data => widget.data;
  SplayTreeMap<int, List<double>>? get _multiData => widget.multiData;
  Color? get _color => widget.color;
  List<Color>? get _multiColor => widget.multiColor;
  List<int> get _removedData => widget.removedData;
  String get _dataLabel => widget.dataLabel;
  List<String> get _dataLabels => widget.dataLabels;

  /// Converts the [SplayTreeMap] dataset [_data] into a [BarChartGroupData] list to display.
  List<BarChartGroupData> getBarGroups(bool useHashMap) {
    // If useHashMap is true, use hashMap keys to create BarChartGroupData
    return useHashMap
        ? widget.hashMap.keys.map<BarChartGroupData>((key) => BarChartGroupData(x: key, barRods: [
            BarChartRodData(
                toY: widget.hashMap[key]!,
                color: !_removedData.contains(key) ? _color : Colors.grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                width: (_width - 20) / widget.hashMap.length * 0.6),
          ]))
            .toList()
        // Otherwise, use _data keys to create BarChartGroupData

        : _data!.keys
            .map((int key) => BarChartGroupData(x: key, barRods: [
                  BarChartRodData(
                      toY: _data![key]!,
                      color: !_removedData.contains(key) ? _color : Colors.grey,
                      borderRadius: BorderRadius.only(

                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7)),
                      width: (_width - 20) / _data!.length * 0.6),
                ]))
            .toList();
  }


  /// Converts the [SplayTreeMap] dataset [_multiData] into a [BarChartGroupData] list to display.
  List<BarChartGroupData> getMultiBarGroups() => _multiData!.keys
      .map((int key) => BarChartGroupData(
          x: key,
          groupVertically: true,
          barRods: () {
            List<BarChartRodData> rods = [];
            double sum = 0;
            for (int i = 0; i < _multiData![key]!.length; i++) {
              rods.add(BarChartRodData(
                  fromY: sum,
                  toY: sum + _multiData![key]![i],
                  color: !_removedData.contains(key)
                      ? _multiColor![i]
                      : (i % 2 == 0 ? Colors.grey : Colors.blueGrey),
                  borderRadius: i == _multiData![key]!.length - 1
                      ? BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7))
                      : BorderRadius.zero,
                  width: (_width - 20) / _multiData!.length * 0.6));
              sum += _multiData![key]![i];
            }
            return rods;
          }()))
      .toList();

  /// Returns the average of [_data] excluding specified data from [_removedData].
  double getAverageData() =>
      (sum(_data!.values) - sum(_removedData.map((x) => _data![x]))) /
      (_data!.length - _removedData.length);

  /// Returns the averages of [_multiData].
  List<double> getMultiAverageData() {
    int dataAmount = _multiData!.values.toList().first.length;
    List<int> keys = _multiData!.keys.toList();
    List<double> sums = List.filled(dataAmount, 0);
    for (int i = 0; i < dataAmount; i++) {
      for (int key in keys) {
        if (_removedData.contains(key)) continue; // To skip removed data.
        sums[i] += _multiData![key]![i];
      }
    }
    return sums.map((x) => x / (keys.length - _removedData.length)).toList();
  }

  /// Gets a column of texts or a single text depending on the type of graph.
  Widget getAverageText() {
    if (_multiData!.isEmpty) {

      // Return empty container. Single average moved to title.
      return Container();
    } else {
      // Column of texts for multi data
      List<Widget> texts = [];
      List<double> averages = getMultiAverageData();

      for (int i = 0; i < averages.length; i++) {
        texts.add(_getSingleText(
            averages[i],
            _multiColor != null
                ? _multiColor![i % _multiColor!.length]
                : Constants.pastelReddishBrown,
            _dataLabels.isNotEmpty ? _dataLabels[i % _dataLabels.length] : ""));
      }

      return Row(spacing: 5, mainAxisAlignment: MainAxisAlignment.center, children: texts.reversed.toList());
    }
  }

  /// Helper method to create a single text widget.
  Widget _getSingleText(double average, Color color, String label) =>
      Text("$label: ${roundAtPlace(average, 2)}",
          style: comfortaaBold(_width / 17,
              color: color, customFontWeight: FontWeight.w900));

  /// Returns the sum of an [Iterable].
  double sum(Iterable l) => l.fold(0.0, (x, y) => x + y!);

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
        children: [
          // Title Text.
          if (widget.chartOnly != true)
            Text("$_title (${roundAtPlace(_multiData != null && _multiData!.isNotEmpty ? getMultiAverageData().sum : getAverageData(), 2)})",
                style: comfortaaBold(_height / 10, color: Constants.pastelReddishBrown)),
          // AspectRatio necessary to prevent BarChart from throwing a formatting error.
          Container(
            width: _width,
            height: _height *
                (_multiData == null || _multiData!.values.isEmpty
                    ? 0.8
                    : 0.7),
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
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (widget.amongviewTeams.isNotEmpty) {
                        if (value ==
                            _data!.values.reduce((a, b) => a > b ? a : b)) {
                          return Container();
                        }
                      }
                      return SideTitleWidget(
                          meta: meta,
                          space: 4,
                          child: Text(value.toStringAsFixed(1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Constants.pastelReddishBrown,
                                  fontSize: 12)));
                    },
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
                                          ? Constants.pastelReddishBrown
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
                                        ? Constants.pastelReddishBrown
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
          if (widget.chartOnly != true) getAverageText()
        ],
      ),
    );
  }
}
