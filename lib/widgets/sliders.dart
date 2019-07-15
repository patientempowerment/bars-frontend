import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';

Widget getSliderInputRow(MyHomePageState homepageState, State context, MapEntry<String, dynamic> feature, double inputValue) {
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
          value: inputValue,
          min: feature.value["slider_min"].toDouble(),
          max: feature.value["slider_max"].toDouble(),
          divisions: feature.value["slider_max"] - feature.value["slider_min"],
          label: '${inputValue.round()}',
          onChanged: (double newValue) {
            context.setState(() {
              homepageState.userInputs[feature.key] = newValue;
            });
          },
        ),
      ),
    ]),
  ));
}
