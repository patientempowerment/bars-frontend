import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';
import 'barsPrototype.dart';

/// A [FloatingActionButton] that resets the userInputs of [MyHomePageState] to their default values.
class ResetButton extends StatelessWidget {
  final MyHomePageState homePageState;

  ResetButton(this.homePageState);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.replay),
      onPressed: () {
        homePageState.userInputs =
            generateDefaultInputValues(homePageState.featuresConfig);
        homePageState.activeInputFields =
            deactivateInputFields(homePageState.featuresConfig);
        homePageState.setState(() {});
      },
    );
  }
}

/// A button that starts or ends [predictMode] in [barsPrototypeState].
class PredictModeButton extends StatelessWidget {
  final BarsPrototypeState barsPrototypeState;

  PredictModeButton(this.barsPrototypeState);

  @override
  Widget build(BuildContext context) {
    if (barsPrototypeState.predictMode) {
      return FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          barsPrototypeState.setState(() {
            barsPrototypeState.predictMode = false;
          });
        },
      );
    }
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward_ios),
      onPressed: () {
        barsPrototypeState.setState(() {
          barsPrototypeState.predictMode = true;
        });
      },
    );
  }
}
