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
    Map<String, dynamic> activeLabels = new Map<String, dynamic>.from(homePageState.labelsConfig);
    activeLabels.removeWhere((key, value) => value["active"] == false);

    Map<String, dynamic> activeModels = new Map<String, dynamic>.from(homePageState.modelsConfig);
    activeModels.removeWhere((key, value) => !activeLabels.containsKey(key));
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: [
              for (var feature in homePageState.featuresConfig.entries)
                buildInputWidget(homePageState, this, feature),
            ],
          ),
        ),
        PredictModeButton(this),
        Flexible(
          child: SimpleBarChart(mapChartData(
              getLabelProbabilities(homePageState.userInputs,
                  activeModels, predictMode),
              activeLabels))
        ),
      ],
    );
  }
}
