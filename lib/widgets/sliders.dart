import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';

/// [parentState] is the state of the widget that the input widget is on, (i.e., the widget that has to rebuild on state change).
Widget getSliderInputRow(HomepageState homepageState, State parentState,
    MapEntry<String, dynamic> feature, Function onChanged) {
  return SliderInputRow(homepageState, parentState, feature, onChanged);
}

/// Defines a slider that changes its color when dragged and is correlated to [feature].
class SliderInputRow extends StatelessWidget {
  final HomepageState homepageState;
  final State parentState;
  final MapEntry<String, dynamic> feature;
  final Function onChanged;
  SliderInputRow(this.homepageState, this.parentState, this.feature, this.onChanged);

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
              activeTrackColor: getActivityColor(homepageState, feature.key),
              inactiveTrackColor: Colors.grey,
              thumbColor: getActivityColor(homepageState, feature.key),
              showValueIndicator: ShowValueIndicator.always,

            ),
            child: Slider(
              value: homepageState.activeInputFields[feature.key]
                  ? homepageState.userInputs[feature.key]
                  : feature.value["slider_min"].toDouble(),
              min: feature.value["slider_min"].toDouble(),
              max: feature.value["slider_max"].toDouble(),
              divisions:
                  feature.value["slider_max"] - feature.value["slider_min"],
              label: '${homepageState.userInputs[feature.key].round()}',
              onChangeStart: (double newValue) {
                if (!homepageState.activeInputFields[feature.key]) {
                  parentState.setState(() {
                    homepageState.activeInputFields[feature.key] = true;
                  });
                }
              },
              onChanged: (double newValue) => onChanged(newValue)
            ),
          ),
        ),
        Container(
            width: 32, //One digit is 8 pixels wide
            child:(homepageState.activeInputFields[feature.key]) ? Text(homepageState.userInputs[feature.key].toInt().toString()):null)
      ]),
    ));
  }
}
