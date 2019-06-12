import 'package:flutter/material.dart';

enum SmokingBehavior { never, previous, current }
SmokingBehavior _smokingBehavior;

Widget getSmokingStatusRadioButtons(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Smoking Behavior"),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: SmokingBehavior.never,
                          groupValue: _smokingBehavior,
                          onChanged: (SmokingBehavior newValue) {
                            context.setState(() {
                              _smokingBehavior = newValue;
                            });
                          },
                        ),
                      ),
                      Text("never")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: SmokingBehavior.previous,
                          groupValue: _smokingBehavior,
                          onChanged: (SmokingBehavior newValue) {
                            context.setState(() {
                              _smokingBehavior = newValue;
                            });
                          },
                        ),
                      ),
                      Text("previously"),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: SmokingBehavior.current,
                          groupValue: _smokingBehavior,
                          onChanged: (SmokingBehavior newValue) {
                            context.setState(() {
                              _smokingBehavior = newValue;
                            });
                          },
                        ),
                      ),
                      Text("current")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}

enum Sex { female, male }
Sex _sex;

Widget getSexRadioButtons(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Sex"),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: Sex.female,
                          groupValue: _sex,
                          onChanged: (Sex newValue) {
                            context.setState(() {
                              _sex = newValue;
                            });
                          },
                        ),
                      ),
                      Text("female")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: Sex.male,
                          groupValue: _sex,
                          onChanged: (Sex newValue) {
                            context.setState(() {
                              _sex = newValue;
                            });
                          },
                        ),
                      ),
                      Text("male"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}

enum AlcoholFrequency { never, daily }
AlcoholFrequency _alcoholFrequency;

Widget getAlcoholFrequencyRadioButtons(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Alcohol Frequency"),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: AlcoholFrequency.never,
                          groupValue: _alcoholFrequency,
                          onChanged: (AlcoholFrequency newValue) {
                            context.setState(() {
                              _alcoholFrequency = newValue;
                            });
                          },
                        ),
                      ),
                      Text("never")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: AlcoholFrequency.daily,
                          groupValue: _alcoholFrequency,
                          onChanged: (AlcoholFrequency newValue) {
                            context.setState(() {
                              _alcoholFrequency = newValue;
                            });
                          },
                        ),
                      ),
                      Text("daily"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}
