import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

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
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children:
                      getScrollableActualButtons(context, buttonValues, groupValue)),
            ),
          ),
        ],
      )));
}

getRadioButtons(MyHomePageState context, String title, List<Pair> buttonValues,
    groupValue) {
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
                children: getActualButtons(context, buttonValues, groupValue)),
          ),
        ],
      )));
}

getActualButtons(
    MyHomePageState context, List<Pair> buttonValues, dynamic groupValue) {
  List<Widget> result = new List();
  for (Pair buttonValue in buttonValues) {
    result.add(getRadioButton(
        context, buttonValue.first, buttonValue.second, groupValue));
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

getRadioButton(context, title, value, groupValue) {
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

Widget getSexRadioButtons(MyHomePageState context) {
  List<Pair> sexButtonValues = [
    Pair('female', Sex.female),
    Pair('male', Sex.male)
  ];

  return getRadioButtons(context, 'Sex', sexButtonValues, context.input.sex);
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

Widget getDiabetesRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Diabetes", context.input.diabetes, context));
}

Widget getCurrentlySmokingRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons(
      "Currently Smoking", context.input.currentlySmoking, context));
}

Widget getNeverSmokedRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons(
      "Never Smoked", context.input.neverSmoked, context));
}

Widget getCoughOnMostDaysRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons(
      "Cough on Most Days", context.input.coughOnMostDays, context));
}

Widget getAsthmaRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Asthma", context.input.asthma, context));
}

Widget getCOPDRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("COPD", context.input.copd, context));
}

Widget getPreviouslySmokedRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons(
      "Previously Smoked", context.input.previouslySmoked, context));
}

Widget getSputumOnMostDaysRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons(
      "Sputum on Most Days", context.input.sputumOnMostDays, context));
}

Widget getTuberculosisRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons(
      "Tuberculosis", context.input.tuberculosis, context));
}

Widget getWheezeInChestInLastYearRadioButtons(MyHomePageState context) {
  return (new YesNoRadioButtons("Wheeze in Chest in Last Year",
      context.input.wheezeInChestInLastYear, context));
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

  YesNoState(String newTitle, YesNoWrapper variableWrapper,
      MyHomePageState homePageState) {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
