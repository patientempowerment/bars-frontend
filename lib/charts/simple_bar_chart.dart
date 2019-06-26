import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

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

class IllnessProb {
  final String illness;
  final double probability;

  IllnessProb(this.illness, this.probability);
}

List<charts.Series<IllnessProb, String>> mapChartData(
    List<IllnessProb> data) {
  return [
    charts.Series<IllnessProb, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
      domainFn: (IllnessProb sales, _) => sales.illness,
      measureFn: (IllnessProb sales, _) => sales.probability,
      data: data,
    )
  ];
}