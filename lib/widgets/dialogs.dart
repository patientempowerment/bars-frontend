import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'radioButtons.dart';

Future<dynamic> asyncSexInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "sex", getSexRadioButtons);
}

Future<dynamic> asyncWheezeInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "wheezeInChestInLastYear",
      getWheezeInChestInLastYearRadioButtons);
}

Future<dynamic> asyncCOPDInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "COPD", getCOPDRadioButtons);
}

Future<dynamic> asyncNeverSmokedInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(
      context, homePageState, "neverSmoked", getNeverSmokedRadioButtons);
}

Future<dynamic> _asyncInputDialog(
    BuildContext context,
    MyHomePageState homePageState,
    String inputVariable,
    Function widgetFunction) async {
  return showDialog<dynamic>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Container(
        child: SimpleDialog(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: <Widget>[
                  MyDialogContent(homePageState, widgetFunction),
                  Container(height: 50),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(homePageState.input.getVariable(inputVariable));
                    },
                    child: new Text('Ok'),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

class MyDialogContent extends StatefulWidget {
  final MyHomePageState homePageState;
  final Function widgetFunction;

  MyDialogContent(this.homePageState, this.widgetFunction);

  @override
  State<StatefulWidget> createState() {
    return new MyDialogContentState(homePageState, widgetFunction);
  }
}

class MyDialogContentState extends State<MyDialogContent> {
  final MyHomePageState homePageState;
  final Function widgetFunction;

  MyDialogContentState(this.homePageState, this.widgetFunction);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [widgetFunction(homePageState, this)]);
  }
}
