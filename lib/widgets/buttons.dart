import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';
import 'bars.dart';
import 'package:bars_frontend/predictions.dart';

/// A [FloatingActionButton] that resets the userInputs of [HomepageState] to their default values.
class ResetButton extends StatelessWidget {
  final HomepageState homepageState;

  ResetButton(this.homepageState);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.replay),
      onPressed: () {
        homepageState.setState(() {
          homepageState.userInputs =
              generateDefaultInputValues(homepageState.featuresConfig);
          homepageState.activeInputFields =
              deactivateInputFields(homepageState.featuresConfig);
          homepageState.originalInputsPlot = [];
          homepageState.changedInputsPlot = [];
        });
      },
    );
  }
}

/// A button that starts or ends [predictMode] in [homepageState].
class PredictModeButton extends StatelessWidget {
  final HomepageState homepageState;

  PredictModeButton(this.homepageState);

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      child: (homepageState.predictMode) ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_forward_ios),
      onPressed: () {
        homepageState.setState(() {
          if (!homepageState.predictMode) {
            homepageState.originalInputsPlot = generateDataPoints(homepageState);
          }
          else {
            homepageState.changedInputsPlot = [];
            homepageState.originalInputsPlot = [];
          }
          homepageState.predictMode = !homepageState.predictMode;
        });
      },
    );
  }
}
