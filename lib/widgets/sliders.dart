import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

Widget getAgeSlider(MyHomePageState context) {
  return getSlider(context, "Age", context.input.age, 18.0, 99.0, 81);
}
Widget getHeightSlider(MyHomePageState context) {
  return getSlider(context, "Height", context.input.height, 120.0, 220.0, 100);
}
Widget getWeightSlider(MyHomePageState context) {
  return getSlider(context, "Weight", context.input.weight, 30.0, 200.0, 170);
}
Widget getDiastolicBloodPressureSlider(MyHomePageState context) {
  return getSlider(context, "Diastolic Blood Pressure", context.input.diastolicBloodPressure, 30.0, 150.0, 120);
}
Widget getSystolicBloodPressureSlider(MyHomePageState context) {
  return getSlider(context, "Systolic Blood Pressure", context.input.systolicBloodPressure, 70.0, 250.0, 180);
}
Widget getNoOfCigarettesPerDaySlider(MyHomePageState context) {
  return getSlider(context, "Number of Cigarettes per Day", context.input.noOfCigarettesPerDay, 0.0, 70.0, 70);
}
Widget getNoOfCigarettesPreviouslyPerDaySlider(MyHomePageState context) {
  return getSlider(context, "Number of Cigarettes Previously per Day", context.input.noOfCigarettesPreviouslyPerDay, 0.0, 140.0, 140);
}
Widget getSlider(context, String title, variable, double min, double max, int divisions) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(children: [
      Expanded(
        flex: 1,
        child: Text(title),
      ),
      Expanded(
        flex: 2,
        child: Slider(
          value: variable.get,
          min: min,
          max: max,
          divisions: divisions,
          label: '${variable.get.round()}',
          onChanged: (double value) {
            context.setState(() {
              variable.get = value;
            });
          },
        ),
      ),
    ]),
  ));
}
