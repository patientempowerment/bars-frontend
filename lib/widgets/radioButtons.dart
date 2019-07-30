import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import '../utils.dart';

/// [context] is the widget that the input widget is on(i.e., the widget that has to rebuild on state change).
getRadioButtonInputRow(MyHomePageState homePageState, State context,
    MapEntry<String, dynamic> feature) {
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
                        getRadioButton(homePageState, context, choice.key,
                            choice.value, feature.key)
                    ]),
              ),
            ),
          )
        ],
      )));
}

/// Returns one radio button and its [title] with current [value] and corresponding [featureKey].
Widget getRadioButton(homePageState, context, title, value, featureKey) {
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
              context.setState(() {
                homePageState.activeInputFields[featureKey] = true;
                homePageState.userInputs[featureKey] = newValue;
              });
            },
          ),
        ),
        Text(title, overflow: TextOverflow.clip, textAlign: TextAlign.center)
      ],
    ),
  );
}
