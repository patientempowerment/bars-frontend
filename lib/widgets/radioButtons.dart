import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';

enum Sex { female, male }

Widget getSexRadioButtons(MyHomePageState context) {
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
                          groupValue: context.input.sex,
                          onChanged: (Sex newValue) {
                            context.setState(() {
                              context.input.sex = newValue;
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
                          groupValue: context.input.sex,
                          onChanged: (Sex newValue) {
                            context.setState(() {
                              context.input.sex = newValue;
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

Widget getAlcoholFrequencyRadioButtons(MyHomePageState context) {
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
                          groupValue: context.input.alcoholFrequency,
                          onChanged: (AlcoholFrequency newValue) {
                            context.setState(() {
                              context.input.alcoholFrequency = newValue;
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
                          groupValue: context.input.alcoholFrequency,
                          onChanged: (AlcoholFrequency newValue) {
                            context.setState(() {
                              context.input.alcoholFrequency = newValue;
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

Widget getDiabetesRadioButtons(MyHomePageState context) {
  return(new YesNoRadioButtons("Diabetes", context.input.diabetes, context));
}
Widget getCurrentlySmokingRadioButtons(MyHomePageState context) {
  return(new YesNoRadioButtons("Currently Smoking", context.input.currentlySmoking, context));
}
Widget getNeverSmokedRadioButtons(MyHomePageState context) {
  return(new YesNoRadioButtons("Never Smoked", context.input.neverSmoked, context));
}
Widget getCoughOnMostDaysRadioButtons(MyHomePageState context) {
  return(new YesNoRadioButtons("Cough on Most Days", context.input.coughOnMostDays, context));
}
Widget getAsthmaRadioButtons(MyHomePageState context) {
  return(new YesNoRadioButtons("Asthma", context.input.asthma, context));
}
Widget getCOPDRadioButtons(MyHomePageState context) {
  return(new YesNoRadioButtons("COPD", context.input.copd, context));
}
Widget getPreviouslySmokedRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Previously Smoked", context.input.previouslySmoked, context));
}
Widget getSputumOnMostDaysRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Sputum on Most Days", context.input.sputumOnMostDays, context));
}
Widget getTuberculosisRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Tuberculosis", context.input.tuberculosis, context));
}
Widget getWheezeInChestInLastYearRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Wheeze in Chest in Last Year", context.input.wheezeInChestInLastYear, context));
}

enum YesNo { yes, no }
class YesNoWrapper {
  YesNo yesNo;
  YesNoWrapper(yesNo) {
    this.yesNo = yesNo;
  }
}

class YesNoRadioButtons extends StatefulWidget {
  final String title;
  final YesNoWrapper variableWrapper;
  final MyHomePageState homePageState;

  YesNoRadioButtons(this.title, this.variableWrapper, this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return YesNoState(this.title, this.variableWrapper, this.homePageState);
  }
}

class YesNoState extends State<YesNoRadioButtons> {
  YesNo variable;
  String title;
  YesNoWrapper variableWrapper;
  MyHomePageState homePageState;

  YesNoState(String newTitle, YesNoWrapper variableWrapper, MyHomePageState homePageState) {
    this.title = newTitle;
    this.variableWrapper = variableWrapper;
    this.homePageState = homePageState;
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
                          groupValue: this.variableWrapper.yesNo,
                          onChanged: (YesNo newValue) {
                            homePageState.setState(() {
                              this.variableWrapper.yesNo = newValue;
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
                          groupValue: this.variableWrapper.yesNo,
                          onChanged: (YesNo newValue) {
                            homePageState.setState(() {
                              this.variableWrapper.yesNo = newValue;
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
