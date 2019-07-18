import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';

class ResetButton extends StatelessWidget {
  final MyHomePageState homePageState;

  ResetButton(this.homePageState);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.replay),
      onPressed: () {
        homePageState.userInputs =
            generateDefaultInputValues(homePageState.featureConfig);
        homePageState.setState(() {});
      },
    );
  }
}

class PredictModeButton extends StatelessWidget {
  final MyHomePageState homePageState;

  PredictModeButton(this.homePageState);

  @override
  Widget build(BuildContext context) {
    if (homePageState.predictMode) {
      return FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          homePageState.setState(() {
            homePageState.predictMode = false;
          });
        },
      );
    }
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward_ios),
      onPressed: () {
        homePageState.setState(() {
          homePageState.predictMode = true;
        });
      },
    );
  }
}
