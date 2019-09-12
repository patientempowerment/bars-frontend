import 'package:charts_flutter/flutter.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'buttons.dart';
import 'package:bars_frontend/charts/barChart.dart';
import 'package:bars_frontend/predictions.dart';
import 'package:bars_frontend/charts/lineChart.dart';


/// Represents the first prototype, includes input fields left a button to trigger output and an output graph with bars.
class UserInputPage extends StatelessWidget {
  final HomepageState homepageState;

  UserInputPage(this.homepageState);

  selectModelForLinePrediction(prefix0.SelectionModel<String> model){
    int modelBarIndex = model.selectedDatum.first.index;
    Map<String, dynamic> activeModels = Map.from(homepageState.modelsConfig);
    activeModels.removeWhere((k,v) => (v["active"]==false));

    int i = 0;
    activeModels.forEach((k,v) {
      if(i == modelBarIndex){
        homepageState.lineModel = k;
      }
      i++;
    });
    homepageState.originalInputsPlot = generateDataPoints(homepageState);
    homepageState.changedInputsPlot = [];
    homepageState.setState((){});
  }

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
                homepageState.buildInputWidget(homepageState, feature),
            ],
          ),
        ),
        PredictModeButton(homepageState),
        Flexible(
            child: Column(
              children: <Widget>[
                if(homepageState.demoStateTracker.bars) Flexible(
                  child: SimpleBarChart(mapChartData(
                      getLabelProbabilities(homepageState.userInputs,
                          activeModels, homepageState.predictMode),
                      activeModels)),
                ),
                if(homepageState.demoStateTracker.graph) Flexible(
                    child: LineChart(homepageState))
              ],
            )
        ),
      ],
    );
  }
}
