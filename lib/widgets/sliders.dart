import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';

/// [parentState] is the state of the widget that the input widget is on, (i.e., the widget that has to rebuild on state change).
Widget getSliderInputRow(MyHomePageState homePageState, State parentState,
    MapEntry<String, dynamic> feature) {
  return SliderInputRow(homePageState, parentState, feature);
}

/// Defines a slider that changes its color when dragged and is correlated to [feature].
class SliderInputRow extends StatelessWidget {
  final MyHomePageState homePageState;
  final State parentState;
  final MapEntry<String, dynamic> feature;
  SliderInputRow(this.homePageState, this.parentState, this.feature);

  @override
  Widget build(BuildContext context) {
    return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text(feature.value["title"]),
        ),
        Expanded(
          flex: 2,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: getActivityColor(homePageState, feature.key),
              inactiveTrackColor: Colors.grey,
              thumbColor: getActivityColor(homePageState, feature.key),
            ),
            child: Slider(
              value: homePageState.activeInputFields[feature.key]
                  ? homePageState.userInputs[feature.key]
                  : feature.value["slider_min"].toDouble(),
              min: feature.value["slider_min"].toDouble(),
              max: feature.value["slider_max"].toDouble(),
              divisions:
                  feature.value["slider_max"] - feature.value["slider_min"],
              label: '${homePageState.userInputs[feature.key].round()}',
              onChangeStart: (double newValue) {
                if (!homePageState.activeInputFields[feature.key]) {
                  parentState.setState(() {
                    homePageState.activeInputFields[feature.key] = true;
                  });
                }
              },
              onChanged: (double newValue) {
                parentState.setState(() {
                  homePageState.userInputs[feature.key] = newValue;
                });
              },
            ),
          ),
        ),
      ]),
    ));
  }
}
