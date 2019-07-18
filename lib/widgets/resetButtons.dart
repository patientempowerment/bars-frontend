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
