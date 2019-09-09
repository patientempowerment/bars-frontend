import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bars_frontend/predictions.dart';


class LineChart extends StatelessWidget {
  HomepageState homepageState;
  bool animate;
  LineChart(this.homepageState, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(_createSeries([homepageState.originalInputsPlot, homepageState.changedInputsPlot]), animate: animate);
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<DataPoint, int>> _createSeries(List<List<DataPoint>> lines) {
    List<charts.Series<DataPoint, int>> series = [];
    for (MapEntry<int, dynamic>line in lines.asMap().entries) {
      series.add(new charts.Series<DataPoint, int>(
        id: line.key.toString(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint point, _) => point.x,
        measureFn: (DataPoint point, _) => point.y,
        data: line.value,
      ));
    }
    return series;
  }
}
