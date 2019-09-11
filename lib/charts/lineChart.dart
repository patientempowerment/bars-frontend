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
    return new charts.LineChart(_createSeries(
        [homepageState.originalInputsPlot, homepageState.changedInputsPlot]),
        animate: animate,
        behaviors: [
          new charts.LinePointHighlighter(
            selectionModelType: charts.SelectionModelType.info,
            defaultRadiusPx: 0,
            radiusPaddingPx: 0,
            showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.none,
            dashPattern: [],
            drawFollowLinesAcrossChart: false
          ),
           new charts.RangeAnnotation([
             if (homepageState.predictMode) new charts.LineAnnotationSegment(
              homepageState.userInputs["age"],
              charts.RangeAnnotationAxisType.domain,
              labelDirection: charts.AnnotationLabelDirection.horizontal,
              strokeWidthPx: 10
            )
          ])
    ]);
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<DataPoint, int>> _createSeries(List<List<DataPoint>> lines) {
    List<charts.Series<DataPoint, int>> series = [];
    for (MapEntry<int, dynamic>line in lines.asMap().entries) {
      series.add(new charts.Series<DataPoint, int>(
        id: line.key.toString(),
        colorFn: (_, __) => ((line.key == 0) ? charts.MaterialPalette.black : charts.Color.fromHex(code: '#00ff1a')),
        domainFn: (DataPoint point, _) => point.x,
        measureFn: (DataPoint point, _) => point.y,
        data: line.value,
      ));
    }
    return series;
  }
}
