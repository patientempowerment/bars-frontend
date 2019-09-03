import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bars_frontend/utils.dart';
import 'dart:math';
import 'package:bars_frontend/widgets/adminSettings.dart';
import 'package:bars_frontend/predictions.dart';


class Story extends StatefulWidget {
  final HomepageState homepageState;
  final String model;

  Story(this.homepageState, this.model);

  @override
  _StoryState createState() => _StoryState(homepageState, model);
}

class _StoryState extends State<Story> {
  HomepageState homepageState;
  String model;
  Map<String, dynamic> originalInputs = {};
  List<DataPoint> originalInputsPlot;
  List<DataPoint> changedInputsPlot;

  _StoryState(this.homepageState, this.model);

  @override
  void initState() {
    originalInputs = Map.from(homepageState.userInputs);
    originalInputsPlot = _generateDataPoints(originalInputs, "age", 0, 100); //Todo: figure out min, max from data?
    super.initState();
  }

  List<DataPoint> _generateDataPoints(Map<String, dynamic> inputs, String domain, int start, int end) {
    List<DataPoint> points = [];
    for(var i = start; i<=end; i++){
      inputs[domain] = i;
      Map<String, double> probability = getLabelProbabilities(inputs, {model: homepageState.modelsConfig[model]}, true);
      points.add(DataPoint(i, probability[model]));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(originalInputsPlot, changedInputsPlot: changedInputsPlot)
    );
  }
}

class LineChart extends StatelessWidget {
  final List<DataPoint> originalInputsPlot;
  final List<DataPoint> changedInputsPlot;

  LineChart(this.originalInputsPlot, {this.changedInputsPlot: const []});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(_createSeries([originalInputsPlot]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<DataPoint, int>> _createSeries(List<List<DataPoint>> lines) {

    List<charts.Series<DataPoint, int>> series = [];
    for (List<DataPoint>line in lines) {
      series.add(new charts.Series<DataPoint, int>(
        id: 'lineChart',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint point, _) => point.x,
        measureFn: (DataPoint point, _) => point.y,
        data: line,
      ));
    }
    return series;
  }
}


class DataPoint {
  final int x;
  final double y;

  DataPoint(this.x, this.y);
}
