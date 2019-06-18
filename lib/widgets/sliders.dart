import 'package:flutter/material.dart';

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
          value: context.input.age,
          min: 18.0,
          max: 99.0,
          divisions: 81,
          label: '${context.input.age.round()}',
          onChanged: (double value) {
            context.setState(() {
              context.input.age = value;
            });
          },
        ),
      ),
    ]),
  ));
}

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
          value: context.input.height,
          min: 120.0,
          max: 220.0,
          divisions: 100,
          label: '${context.input.height.round()}',
          onChanged: (double value) {
            context.setState(() {
              context.input.height = value;
            });
          },
        ),
      ),
    ]),
  ));
}

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
          value: context.input.weight,
          min: 30.0,
          max: 200.0,
          divisions: 170,
          label: '${context.input.weight.round()}',
          onChanged: (double value) {
            context.setState(() {
              context.input.weight = value;
            });
          },
        ),
      ),
    ]),
  ));
}

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
            value: context.input.diastolicBloodPressure,
            min: 30.0,
            max: 150.0,
            divisions: 120,
            label: '${context.input.diastolicBloodPressure.round()}',
            onChanged: (double value) {
              context.setState(() {
                context.input.diastolicBloodPressure = value;
              });
            },
          ),
        ),
      ])));
}

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
            value: context.input.systolicBloodPressure,
            min: 70.0,
            max: 250.0,
            divisions: 180,
            label: '${context.input.systolicBloodPressure.round()}',
            onChanged: (double value) {
              context.setState(() {
                context.input.systolicBloodPressure = value;
              });
            },
          ),
        ),
      ])));
}

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
            value: context.input.noOfCigarettesPerDay,
            min: 0.0,
            max: 70.0,
            divisions: 70,
            label: '${context.input.noOfCigarettesPerDay.round()}',
            onChanged: (double value) {
              context.setState(() {
                context.input.noOfCigarettesPerDay = value;
              });
            },
          ),
        ),
      ])));
}

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
            value: context.input.noOfCigarettesPreviouslyPerDay,
            min: 0.0,
            max: 140.0,
            divisions: 140,
            label: '${context.input.noOfCigarettesPreviouslyPerDay.round()}',
            onChanged: (double value) {
              context.setState(() {
                context.input.noOfCigarettesPreviouslyPerDay = value;
              });
            },
          ),
        ),
      ])));
}