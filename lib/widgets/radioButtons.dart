import 'package:flutter/material.dart';

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

Widget getDiabetesRadioButtons() {
  return(new YesNoRadioButtons("Diabetes"));
}
Widget getCurrentlySmokingRadioButtons() {
  return(new YesNoRadioButtons("CurrentlySmoking"));
}
Widget getNeverSmokedRadioButtons() {
  return(new YesNoRadioButtons("Never Smoked"));
}
Widget getCoughOnMostDaysRadioButtons() {
  return(new YesNoRadioButtons("Cough on most days"));
}
Widget getAsthmaRadioButtons() {
  return(new YesNoRadioButtons("Asthma"));
}
Widget getCOPDRadioButtons() {
  return(new YesNoRadioButtons("COPD"));
}
Widget getPreviouslySmokedRadioButtons() {
  return (new YesNoRadioButtons("Previously Smoked"));
}
Widget getSputumOnMostDaysRadioButtons() {
  return (new YesNoRadioButtons("Sputum on most days"));
}
Widget getTuberculosisRadioButtons() {
  return (new YesNoRadioButtons("Tuberculosis"));
}
Widget getWheezeInChestInLastYearRadioButtons() {
  return (new YesNoRadioButtons("Wheeze in chest in last year"));
}

enum YesNo { yes, no }

class YesNoRadioButtons extends StatefulWidget {
  String title;

  YesNoRadioButtons(String title) {
    this.title = title;
  }

  @override
  State<StatefulWidget> createState() {
    return YesNoState(this.title);
  }
}

class YesNoState extends State<YesNoRadioButtons> {
  YesNo variable;
  String title;

  YesNoState(String newTitle) {
    this.title = newTitle;
  }

  @override
  Widget build(BuildContext context) {
    return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(title),
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
                          value: YesNo.yes,
                          groupValue: this.variable,
                          onChanged: (YesNo newValue) {
                            setState(() {
                              this.variable = newValue;
                            });
                          },
                        ),
                      ),
                      Text("yes")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: YesNo.no,
                          groupValue: this.variable,
                          onChanged: (YesNo newValue) {
                            setState(() {
                              this.variable = newValue;
                            });
                          },
                        ),
                      ),
                      Text("no"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
