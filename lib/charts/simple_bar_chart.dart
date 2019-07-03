import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';

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

List<charts.Series<IllnessProb, String>> mapChartData(
    List<IllnessProb> data) {
  final List<Color> colorGradient = [
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.red
  ];

  return [
    charts.Series<IllnessProb, String>(
      id: 'Sales',
      colorFn: (IllnessProb sales, __) => sales.probability < 0.5 ? charts.MaterialPalette.green.shadeDefault : charts.MaterialPalette.red.shadeDefault,//charts.MaterialPalette.indigo.shadeDefault,
      domainFn: (IllnessProb sales, _) => sales.illness,
      measureFn: (IllnessProb sales, _) => sales.probability,
      data: data,
    )
  ];
}