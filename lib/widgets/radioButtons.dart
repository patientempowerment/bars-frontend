import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';

/// [parentState] is the state of the widget that the input widget is on, (i.e., the widget that has to rebuild on state change).
getRadioButtonInputRow(HomepageState homePageState, State parentState,
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
                        getRadioButton(homePageState, parentState, choice.key,
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
    homePageState, parentState, title, value, featureKey, onChanged) {
  return Container(
    width: 100,
    child: Column(
      children: [
        Container(
            child: Radio(
                activeColor: getActivityColor(homePageState, featureKey),
                value: value,
                groupValue: homePageState.activeInputFields[featureKey]
                    ? homePageState.userInputs[featureKey]
                    : null,
                onChanged: (dynamic newValue) {
                  homePageState.activeInputFields[featureKey] = true;
                  onChanged(newValue);
                })),
        Text(title, overflow: TextOverflow.clip, textAlign: TextAlign.center)
      ],
    ),
  );
}
