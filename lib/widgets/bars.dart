import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'buttons.dart';
import 'package:bars_frontend/charts/barChart.dart';
import 'package:bars_frontend/predictions.dart';
import 'package:bars_frontend/charts/lineChart.dart';


/// Represents the first prototype, includes input fields left a button to trigger output and an output graph with bars.
class UserInputPage extends StatelessWidget {
  final HomepageState homepageState;

  UserInputPage(this.homepageState);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> activeModels = new Map<String, dynamic>.from(homepageState.modelsConfig);
    activeModels.removeWhere((key, value) => value["active"] == false);
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: [
              for (var feature in homepageState.featuresConfig.entries)
                buildInputWidget(homepageState, homepageState, feature),
            ],
          ),
        ),
        PredictModeButton(homepageState),
        Flexible(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: SimpleBarChart(mapChartData(
                      getLabelProbabilities(homepageState.userInputs,
                          activeModels, homepageState.predictMode),
                      activeModels)),
                ),
                Flexible(child: LineChart(homepageState))
              ],
            )
        ),
      ],
    );
  }
}
