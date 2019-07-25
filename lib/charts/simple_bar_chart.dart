import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

/// Bar Chart that generates a bar for each <[label] - [labelValues]> pair.
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<Tuple2<String, dynamic>, String>> labelValues;
  final bool animate;

  SimpleBarChart(this.labelValues, {this.animate = true});

  @override Widget build(BuildContext context) {
    return charts.BarChart(
      labelValues,
      animate: animate,
    );
  }
}

/// Maps keys and values of a Map to key-value tuples.
List<Tuple2<String, dynamic>> mapToTupleList(Map<String, dynamic> map){
  List<Tuple2<String, dynamic>> list = [];
  map.forEach((k,v) => list.add(Tuple2<String, dynamic>(k, v)));
  return list;
}

/// Takes the [labelValues] and [labelTitles] and creates a list of [charts.Series] from it.
/// [labelTitles] contain names of each bar, [labelValues] contain their sizes.
mapChartData(Map<String, dynamic> labelValues, Map<String, dynamic> labelTitles){
  var data = mapToTupleList(labelValues);

  // replace labels with labelTitles
  data.asMap().forEach((i, tuple) {
    data[i] = tuple.withItem1(labelTitles[tuple.item1]);
  });

  return [ //TODO: make a utils func that creates charts.series from maps
    charts.Series<Tuple2<String, dynamic>, String>(
      id: 'barChart',
      colorFn: (Tuple2<String, dynamic> tuple, __) => getChartColorByFactor(tuple.item2.toDouble()),
      domainFn: (Tuple2<String, dynamic> tuple, _) => tuple.item1,
      measureFn: (Tuple2<String, dynamic> tuple, _) => tuple.item2,
      data: data,
    )
  ];
}

/// Returns a color matching a [factor] between 0 and 1. 0 being green and 1 red.
getChartColorByFactor(double factor){
  final List<dynamic> colorGradient = [
    charts.Color.fromHex(code: "#8BC24A"),
    charts.Color.fromHex(code: "#FEC007"),
    charts.Color.fromHex(code: "#FE9800"),
    charts.Color.fromHex(code: "#FE5722"),
    charts.Color.fromHex(code: "#F34336"),
  ];

  return colorGradient[((colorGradient.length - 1) * factor).round().toInt()];
}
