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

double _height = 120.0;

Widget getHeightSlider(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(children: [
      Expanded(
        flex: 1,
        child: Text("Height"),
      ),
      Expanded(
        flex: 2,
        child: Slider(
          value: _height,
          min: 120.0,
          max: 220.0,
          divisions: 100,
          label: '${_height.round()}',
          onChanged: (double value) {
            context.setState(() {
              _height = value;
            });
          },
        ),
      ),
    ]),
  ));
}

double _weight = 30;

Widget getWeightSlider(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(children: [
      Expanded(
        flex: 1,
        child: Text("Weight"),
      ),
      Expanded(
        flex: 2,
        child: Slider(
          value: _weight,
          min: 30.0,
          max: 200.0,
          divisions: 170,
          label: '${_weight.round()}',
          onChanged: (double value) {
            context.setState(() {
              _weight = value;
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

double _noOfCigarettesPerDay = 0.0;

Widget getNoOfCigarettesPerDaySlider(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text("Number of Cigarettes per Day"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _noOfCigarettesPerDay,
            min: 0.0,
            max: 70.0,
            divisions: 70,
            label: '${_noOfCigarettesPerDay.round()}',
            onChanged: (double value) {
              context.setState(() {
                _noOfCigarettesPerDay = value;
              });
            },
          ),
        ),
      ])));
}

double _noOfCigarettesPreviouslyPerDay = 0.0;

Widget getNoOfCigarettesPreviouslyPerDaySlider(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text("Number of Cigarettes Previously per Day"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: _noOfCigarettesPreviouslyPerDay,
            min: 0.0,
            max: 140.0,
            divisions: 140,
            label: '${_noOfCigarettesPreviouslyPerDay.round()}',
            onChanged: (double value) {
              context.setState(() {
                _noOfCigarettesPreviouslyPerDay = value;
              });
            },
          ),
        ),
      ])));
}