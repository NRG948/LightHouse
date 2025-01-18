import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class NRGBarChart extends StatefulWidget {
  final String title;
  final String height;
  final String width;
  final SplayTreeMap<int, double> data;

  const NRGBarChart(
      {super.key,
      required this.title,
      required this.height,
      required this.width,
      required this.data});

  @override
  State<StatefulWidget> createState() => _NRGBarChartState();
}

class _NRGBarChartState extends State<NRGBarChart> {
  String get _title => widget.title;
  String get _height => widget.height;
  String get _width => widget.width;
  SplayTreeMap<int, double> get _data => widget.data;
  double _average = 0;

  List<BarChartGroupData> getBarGroups(SplayTreeMap<int, double> data) =>
      data.keys
          .map((int key) => BarChartGroupData(
              x: key, barRods: [BarChartRodData(toY: data[key]!)]))
          .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.parse(_width),
      height: double.parse(_height),
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(
        children: [
          Text(_title,
              style: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50)),
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(BarChartData(barGroups: getBarGroups(_data))),
          ),
          Text("AVERAGE: $_average", // TODO Calculate average value
              style: TextStyle(
                  fontFamily: "Comfortaa", color: Colors.black, fontSize: 20))
        ],
      ),
    );
  }
}
