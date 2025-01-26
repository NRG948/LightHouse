import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

/// A horizontal bar chart widget that dislays numbers, automatically sorting by key.
class NRGBarChart extends StatefulWidget {
  String title;
  double height;
  double width;
  SplayTreeMap<int, double> data;
  SplayTreeMap<int, List<double>> multiData;
  List<int> removedData;
  Color color;
  List<Color> multiColor;

  NRGBarChart(
      {super.key,
      required this.title,
      required this.height,
      required this.width,
      Color? color,
      SplayTreeMap<int, double>? data,
      List<int>? removedData,
      SplayTreeMap<int, List<double>>? multiData,
      List<Color>? multiColor})
      : removedData = removedData ?? [],
        color = color ?? Colors.transparent,
        data = data ?? SplayTreeMap(),
        multiData = multiData ?? SplayTreeMap(),
        multiColor = multiColor ?? [];

  @override
  State<StatefulWidget> createState() => _NRGBarChartState();
}

class _NRGBarChartState extends State<NRGBarChart> {
  String get _title => widget.title;
  double get _height => widget.height;
  double get _width => widget.width;
  SplayTreeMap<int, double>? get _data => widget.data;
  SplayTreeMap<int, List<double>>? get _multiData => widget.multiData;
  Color? get _color => widget.color;
  List<Color>? get _multiColor => widget.multiColor;
  List<int> get _removedData => widget.removedData;

  /// Converts the [SplayTreeMap] dataset [_data] into a [BarChartGroupData] list to display.
  List<BarChartGroupData> getBarGroups() => _data!.keys
      .map((int key) => BarChartGroupData(x: key, barRods: [
            BarChartRodData(
                toY: _data![key]!,
                color: !_removedData.contains(key) ? _color : Colors.grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                width: (_width - 20) / _data!.length * 0.6),
          ]))
      .toList();

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
  Widget getAverageText() => _multiData!.isEmpty
      ? _getSingleText(getAverageData(), _color ?? Colors.black)
      : Column(
          children: _multiColor != null
              ? IterableZip<dynamic>([getMultiAverageData(), _multiColor!])
                  .toList()
                  .map((x) => _getSingleText(x[0], x[1]))
                  .toList()
                  .reversed
                  .toList()
              : getMultiAverageData()
                  .map((x) => _getSingleText(x, Colors.black))
                  .toList());

  Widget _getSingleText(double average, Color color) =>
      Text("AVERAGE: ${roundAtPlace(average, 2)}",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: color,
              fontSize: _width / 20));

  /// Returns the sum of an [Iterable].
  double sum(Iterable l) => l.fold(0.0, (x, y) => x + y!);

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
          Text(_title,
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: _width / 10)),
          // AspectRatio necessary to prevent BarChart from throwing a formatting error.
          AspectRatio(
              aspectRatio: 2,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: BarChart(BarChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: Text('${value.toInt()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: _width / 25)));
                        },
                      )),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: Text('${value.toInt()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: !_removedData.contains(value)
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: _width / 25)));
                        },
                      )),
                    ),
                    barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) =>
                              Color.fromARGB(200, 255, 255, 255),
                        )),
                    barGroups: _multiData!.isEmpty
                        ? getBarGroups()
                        : getMultiBarGroups(),
                    gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (x) =>
                            const FlLine(color: Colors.grey, strokeWidth: 1)))),
              )),
          // Average value text.
          getAverageText()
        ],
      ),
    );
  }
}
