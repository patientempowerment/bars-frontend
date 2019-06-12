import 'package:flutter/material.dart';

double _age = 18.0;

Widget getAgeSlider(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(children: [
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
    ]),
  ));
}

double _diastolicBloodPressure = 30.0;

Widget getDiastolicBloodPressureSlider(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text("Diastolic Blood Pressure"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _diastolicBloodPressure,
            min: 30.0,
            max: 150.0,
            divisions: 120,
            label: '${_diastolicBloodPressure.round()}',
            onChanged: (double value) {
              context.setState(() {
                _diastolicBloodPressure = value;
              });
            },
          ),
        ),
      ])));
}

double _systolicBloodPressure = 70.0;

Widget getSystolicBloodPressureSlider(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text("Systolic Blood Pressure"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _systolicBloodPressure,
            min: 70.0,
            max: 250.0,
            divisions: 180,
            label: '${_systolicBloodPressure.round()}',
            onChanged: (double value) {
              context.setState(() {
                _systolicBloodPressure = value;
              });
            },
          ),
        ),
      ])));
}
