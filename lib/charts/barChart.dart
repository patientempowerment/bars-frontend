import 'package:bars_frontend/widgets/userInputPage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:bars_frontend/colorUtils.dart';

/// Bar Chart that generates a bar for each <[label] - [labelValues]> pair.
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<Tuple2<String, dynamic>, String>> labelValues;
  final bool animate;

  SimpleBarChart(this.labelValues, {this.animate = false});

  @override Widget build(BuildContext context) {
    UserInputPage parent = context.ancestorWidgetOfExactType(UserInputPage);
    return charts.BarChart(
      labelValues,
      animate: animate,
      selectionModels: [new charts.SelectionModelConfig(
        type: charts.SelectionModelType.info,
        changedListener: parent.selectModelForLinePrediction,
      )
      ],
      behaviors: [
        new charts.InitialSelection(selectedDataConfig: [
          new charts.SeriesDatumConfig('barChart', parent.homepageState.lineModel)
        ],
        )
      ],
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
  if(labelTitles.isNotEmpty) {
    data.asMap().forEach((i, tuple) {
      data[i] = tuple.withItem1(labelTitles[tuple.item1]["title"]);
    });
  }

  return [ //TODO: make a utils func that creates charts.series from maps
    charts.Series<Tuple2<String, dynamic>, String>(
      id: 'barChart',
      //colorFn: (Tuple2<String, dynamic> tuple, __) => getChartColorByFactor(tuple.item2.toDouble()),
      colorFn: (Tuple2<String, dynamic> tuple, __) => charts.ColorUtil.fromDartColor(computeColorByFactor(tuple.item2.toDouble())),
      domainFn: (Tuple2<String, dynamic> tuple, _) => tuple.item1,
      measureFn: (Tuple2<String, dynamic> tuple, _) => tuple.item2,
      data: data,
    )
  ];
}