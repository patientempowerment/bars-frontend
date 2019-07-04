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

List<charts.Series<IllnessProb, String>> mapChartData(List<IllnessProb> data) {
  final List<dynamic> colorGradient = [
    charts.Color.fromHex(code: "#8BC24A"),
    charts.Color.fromHex(code: "#FEC007"),
    charts.Color.fromHex(code: "#FE9800"),
    charts.Color.fromHex(code: "#FE5722"),
    charts.Color.fromHex(code: "#F34336"),
  ];

  return [
    charts.Series<IllnessProb, String>(
      id: 'Sales',
      colorFn: (IllnessProb sales, __) => colorGradient[
          ((colorGradient.length - 1) * sales.probability).round().toInt()],
      domainFn: (IllnessProb sales, _) => sales.illness,
      measureFn: (IllnessProb sales, _) => sales.probability,
      data: data,
    )
  ];
}
