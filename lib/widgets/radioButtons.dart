import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'dialogs.dart';




getScrollableRadioButtons(MyHomePageState context, String title,
    List<Pair> buttonValues, groupValue) {
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
            child: Container(
              height: 100,
              child: Scrollbar(
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: getScrollableActualButtons(
                        context, buttonValues, groupValue)),
              ),
            ),
          ),
        ],
      )));
}

getRadioButtons(MyHomePageState context, MyDialogContentState dialogState,
    String title, List<Pair> buttonValues, groupValue) {
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getActualButtons(
                    context, dialogState, buttonValues, groupValue)),
          ),
        ],
      )));
}

getActualButtons(
  MyHomePageState context,
  MyDialogContentState dialogState,
  List<Pair> buttonValues,
  dynamic groupValue,
) {
  List<Widget> result = new List();
  for (Pair buttonValue in buttonValues) {
    result.add(getRadioButton(context, dialogState, buttonValue.first,
        buttonValue.second, groupValue));
  }
  return result;
}

getScrollableActualButtons(
    MyHomePageState context, List<Pair> buttonValues, dynamic groupValue) {
  List<Widget> result = new List();
  for (Pair buttonValue in buttonValues) {
    result.add(getScrollableRadioButton(
        context, buttonValue.first, buttonValue.second, groupValue));
  }
  return result;
}

getRadioButton(
    context, MyDialogContentState dialogState, title, value, groupValue) {
  return Container(
    child: Column(
      children: [
        Container(
          child: Radio(
            value: value,
            groupValue: groupValue.value,
            onChanged: (dynamic newValue) {
              context.setState(() {
                groupValue.value = newValue;
              });
              if (dialogState != null) {
                dialogState.setState(() {
                  groupValue.value = newValue;
                });
              }
            },
          ),
        ),
        Text(title)
      ],
    ),
  );
}

getScrollableRadioButton(context, title, value, groupValue) {
  return Container(
    width: 100,
    child: Column(
      children: [
        Container(
          child: Radio(
            value: value,
            groupValue: groupValue.value,
            onChanged: (dynamic newValue) {
              context.setState(() {
                groupValue.value = newValue;
              });
            },
          ),
        ),
        Text(title, overflow: TextOverflow.clip, textAlign: TextAlign.center)
      ],
    ),
  );
}

Widget getSexRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  List<Pair> sexButtonValues = [
    Pair('female', Sex.female),
    Pair('male', Sex.male)
  ];

  return getRadioButtons(
      context, dialogState, 'Sex', sexButtonValues, context.input.sex);
}

Widget getAlcoholFrequencyRadioButtons(MyHomePageState context) {
  List<Pair> alcoholButtonValues = [
    Pair('never', AlcoholFrequency.never),
    Pair('special occasions', AlcoholFrequency.specialOccasions),
    Pair('one to three times a month', AlcoholFrequency.oneToThreeTimesAMonth),
    Pair('once or twice a week', AlcoholFrequency.OnceOrTwiceAWeek),
    Pair('three or four times a week', AlcoholFrequency.threeOrFourTimesAWeek),
    Pair('daily', AlcoholFrequency.daily),
  ];

  return getScrollableRadioButtons(context, 'Alcohol Frequency',
      alcoholButtonValues, context.input.alcoholFrequency);
}

Widget getDiabetesRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons(
      "Diabetes", context.input.diabetes, context, dialogState));
}

Widget getCurrentlySmokingRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons("Currently Smoking",
      context.input.currentlySmoking, context, dialogState));
}

Widget getNeverSmokedRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons(
      "Never Smoked", context.input.neverSmoked, context, dialogState));
}

Widget getCoughOnMostDaysRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons("Cough on Most Days",
      context.input.coughOnMostDays, context, dialogState));
}

Widget getAsthmaRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons(
      "Asthma", context.input.asthma, context, dialogState));
}

Widget getCOPDRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons(
      "COPD", context.input.copd, context, dialogState));
}

Widget getPreviouslySmokedRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons("Previously Smoked",
      context.input.previouslySmoked, context, dialogState));
}

Widget getSputumOnMostDaysRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons("Sputum on Most Days",
      context.input.sputumOnMostDays, context, dialogState));
}

Widget getTuberculosisRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons(
      "Tuberculosis", context.input.tuberculosis, context, dialogState));
}

Widget getWheezeInChestInLastYearRadioButtons(
    MyHomePageState context, MyDialogContentState dialogState) {
  return (new YesNoRadioButtons("Wheeze in Chest in Last Year",
      context.input.wheezeInChestInLastYear, context, dialogState));
}

class YesNoRadioButtons extends StatefulWidget {
  final String title;
  final YesNoWrapper variableWrapper;
  final MyHomePageState homePageState;
  final MyDialogContentState dialogState;

  YesNoRadioButtons(
      this.title, this.variableWrapper, this.homePageState, this.dialogState);

  @override
  State<StatefulWidget> createState() {
    return YesNoState(
        this.title, this.variableWrapper, this.homePageState, this.dialogState);
  }
}

class YesNoState extends State<YesNoRadioButtons> {
  YesNo variable;
  String title;
  YesNoWrapper variableWrapper;
  MyHomePageState homePageState;
  final MyDialogContentState dialogState;

  YesNoState(
      this.title, this.variableWrapper, this.homePageState, this.dialogState);

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: YesNo.yes,
                          groupValue: this.variableWrapper.value,
                          onChanged: (YesNo newValue) {
                            homePageState.setState(() {
                              this.variableWrapper.value = newValue;
                            });
                            if (dialogState != null) {
                              dialogState.setState(() {
                                this.variableWrapper.value = newValue;
                              });
                            }
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
                          groupValue: this.variableWrapper.value,
                          onChanged: (YesNo newValue) {
                            homePageState.setState(() {
                              this.variableWrapper.value = newValue;
                            });
                            if (dialogState != null) {
                              dialogState.setState(() {
                                this.variableWrapper.value = newValue;
                              });
                            }
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
