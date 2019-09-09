import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';
import 'bars.dart';
import 'package:bars_frontend/predictions.dart';

/// A [FloatingActionButton] that resets the userInputs of [HomepageState] to their default values.
class ResetButton extends StatelessWidget {
  final HomepageState homePageState;

  ResetButton(this.homePageState);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.replay),
      onPressed: () {
        homePageState.setState(() {
          homePageState.userInputs =
              generateDefaultInputValues(homePageState.featuresConfig);
          homePageState.activeInputFields =
              deactivateInputFields(homePageState.featuresConfig);
          homePageState.originalInputsPlot = [];
          homePageState.changedInputsPlot = [];
        });
      },
    );
  }
}

/// A button that starts or ends [predictMode] in [barsPrototypeState].
class PredictModeButton extends StatelessWidget {
  final BarsState barsPrototypeState;

  PredictModeButton(this.barsPrototypeState);

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      child: (barsPrototypeState.predictMode) ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_forward_ios),
      onPressed: () {
        barsPrototypeState.setState(() {
          HomepageState state = barsPrototypeState.homePageState;
          if (!barsPrototypeState.predictMode) {
            state.originalInputsPlot = generateDataPoints(barsPrototypeState.homePageState);
          }
          barsPrototypeState.predictMode = !barsPrototypeState.predictMode;
        });
      },
    );
  }
}
