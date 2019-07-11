import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

Future<dynamic> asyncSexInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "sex", buildInputWidget);
}
Future<dynamic> asyncWheezeInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "wheezeInChestInLastYear", buildInputWidget);
}
Future<dynamic> asyncCOPDInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "COPD", buildInputWidget);
}
Future<dynamic> asyncNeverSmokedInputDialog(
    BuildContext context, MyHomePageState homePageState) async {
  return _asyncInputDialog(context, homePageState, "neverSmoked", buildInputWidget);
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
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 10.0),
        child: AlertDialog(
            content: MyDialogContent(homePageState, widgetFunction),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(
                      homePageState.input.getVariable(inputVariable).value);
                },
                child: new Text('Ok'),
              )
            ]),
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
