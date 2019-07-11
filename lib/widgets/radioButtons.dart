import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'dialogs.dart';


getRadioButtonInputRow(MyHomePageState context, feature, userInputs) {
  return (
    Padding(
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
                      getRadioButton(context, choice.key, choice.value, feature.key)
                  ]
                ),
              ),
            ),
          )
        ],
      )
    )
  );
}

getRadioButton(context, title, value, featureKey) {
  return Container(
    width: 100,
    child: Column(
      children: [
        Container(
          child: Radio(
            value: value,
            groupValue: context.userInputs[featureKey],
            onChanged: (dynamic newValue) {
              context.setState(() {
                context.userInputs[featureKey] = newValue;
              });
            },
          ),
        ),
        Text(title, overflow: TextOverflow.clip, textAlign: TextAlign.center)
      ],
    ),
  );
}