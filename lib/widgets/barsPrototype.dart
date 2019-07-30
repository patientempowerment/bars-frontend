import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'buttons.dart';
import 'package:bars_frontend/charts/simple_bar_chart.dart';
import 'package:bars_frontend/predictions.dart';

/// Represents the first prototype, includes input fields left a button to trigger output and an output graph with bars.
class BarsPrototype extends StatefulWidget {
  final MyHomePageState homePageState;

  BarsPrototype(this.homePageState);
  @override
  State<StatefulWidget> createState() {
    return BarsPrototypeState(homePageState);
  }
}

/// [predictMode] determines whether output should be displayed.
class BarsPrototypeState extends State<BarsPrototype> {
  MyHomePageState homePageState;
  bool predictMode = false;

  BarsPrototypeState(this.homePageState);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: [
              for (var feature in homePageState.featureConfig.entries)
                buildInputWidget(homePageState, this, feature),
            ],
          ),
        ),
        PredictModeButton(this),
        Expanded(
          child: SimpleBarChart(mapChartData(
              getLabelProbabilities(homePageState.userInputs,
                  homePageState.modelConfig, predictMode),
              homePageState.labelConfig)),
        ),
      ],
    );
  }
}
