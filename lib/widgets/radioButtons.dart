import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';

/// [parentState] is the state of the widget that the input widget is on, (i.e., the widget that has to rebuild on state change).
getRadioButtonInputRow(HomepageState homepageState, State parentState,
    MapEntry<String, dynamic> feature, Function onChanged) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(feature.value["title"]),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 100,
              child: Scrollbar(
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var choice in feature.value["choices"].entries)
                        getRadioButton(homepageState, parentState, choice.key,
                            choice.value, feature.key, onChanged)
                    ]),
              ),
            ),
          )
        ],
      )));
}

/// Returns one radio button and its [title] with current [value] and corresponding [featureKey].
Widget getRadioButton(
    homepageState, parentState, title, value, featureKey, onChanged) {
  return Container(
    width: 100,
    child: Column(
      children: [
        Container(
            child: Radio(
                activeColor: getActivityColor(homepageState, featureKey),
                value: value,
                groupValue: homepageState.activeInputFields[featureKey]
                    ? homepageState.userInputs[featureKey]
                    : null,
                onChanged: (dynamic newValue) {
                  homepageState.activeInputFields[featureKey] = true;
                  onChanged(newValue);
                })),
        Text(title, overflow: TextOverflow.clip, textAlign: TextAlign.center)
      ],
    ),
  );
}
