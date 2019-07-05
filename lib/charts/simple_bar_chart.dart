import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';
/*
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate = true});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

List<charts.Series<IllnessProb, String>> mapChartData(List<IllnessProb> data) {
  return [
    charts.Series<IllnessProb, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
      domainFn: (IllnessProb sales, _) => sales.illness,
      measureFn: (IllnessProb sales, _) => sales.probability,
      data: data,
    )
  ];
}*/

class SimpleBarChart extends StatelessWidget {
  final Map<String, dynamic> labelValues;
  final bool animate;

  SimpleBarChart(this.labelValues, {this.animate = true});

  @override Widget build(BuildContext context) {
    return charts.BarChart(
      labelValues,
      animate: animate,
    );
  }
}

mapChartData(List<m> labelValues){
  return [ //TODO: make a utils func that creates chars.series from maps
    charts.Series<IllnessProb, String>(
      id: 'barChart',
      colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
      domainFn: labelValues.
      measureFn: (IllnessProb sales, _) => sales.probability,
      data: data,
    )
  ];
}