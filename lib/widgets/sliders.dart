import 'package:flutter/material.dart';

double _age = 18.0;

Widget getAgeSlider(context) {
  return (Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Age"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _age,
            min: 18.0,
            max: 99.0,
            divisions: 81,
            label: '${_age.round()}',
            onChanged: (double value) {
              context.setState(() {
                _age = value;
              });
            },
          ),
        ),
      ]
  )
  );
}

double _dystolicBloodPressure = 80.0;

Widget getDystolicBloodPressureSlider(context) {
  return (Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Dystolic Blood Pressure"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _dystolicBloodPressure,
            min: 60.0,
            max: 150.0,
            divisions: 90,
            label: '${_dystolicBloodPressure.round()}',
            onChanged: (double value) {
              context.setState(() {
                _dystolicBloodPressure = value;
              });
            },
          ),
        ),
      ]
  )
  );
}

double _systolicBloodPressure = 80.0;

Widget getSystolicBloodPressureSlider(context) {
  return (Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Systolic Blood Pressure"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _systolicBloodPressure,
            min: 100.0,
            max: 200.0,
            divisions: 100,
            label: '${_systolicBloodPressure.round()}',
            onChanged: (double value) {
              context.setState(() {
                _systolicBloodPressure = value;
              });
            },
          ),
        ),
      ]
  )
  );
}