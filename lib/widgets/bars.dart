import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'buttons.dart';
import 'package:bars_frontend/charts/barChart.dart';
import 'package:bars_frontend/predictions.dart';
import 'package:bars_frontend/charts/lineChart.dart';


/// Represents the first prototype, includes input fields left a button to trigger output and an output graph with bars.
class Bars extends StatefulWidget {
  final HomepageState homePageState;

  Bars(this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return BarsState(homePageState);
  }
}

/// [predictMode] determines whether output should be displayed.
class BarsState extends State<Bars> {
  HomepageState homePageState;
  bool predictMode = false;

  BarsState(this.homePageState);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> activeModels = new Map<String, dynamic>.from(homePageState.modelsConfig);
    activeModels.removeWhere((key, value) => value["active"] == false);
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
          child: Column(
            children: <Widget>[
              Flexible(
                child: SimpleBarChart(mapChartData(
                    getLabelProbabilities(homePageState.userInputs,
                        activeModels, predictMode),
                    activeModels)),
              ),
              Flexible(child: LineChart(this.homePageState))
            ],
          )
        ),
      ],
    );
  }
}
