import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';


/// [context] is the widget that the input widget is on, (i.e., the widget that has to rebuild on state change).
Widget getSliderInputRow(MyHomePageState homePageState, State context, MapEntry<String, dynamic> feature) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(children: [
      Expanded(
        flex: 1,
        child: Text(feature.value["title"]),
      ),
      Expanded(
        flex: 2,
        child: Slider(
          value: homePageState.userInputs[feature.key],
          min: feature.value["slider_min"].toDouble(),
          max: feature.value["slider_max"].toDouble(),
          divisions: feature.value["slider_max"] - feature.value["slider_min"],
          label: '${homePageState.userInputs[feature.key].round()}',
          onChanged: (double newValue) {
            context.setState(() {
              homePageState.userInputs[feature.key] = newValue;
            });
          },
        ),
      ),
    ]),
  ));
}
