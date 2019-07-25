import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

Future<dynamic> asyncInputDialog(BuildContext context,
    MyHomePageState homePageState, MapEntry<String, dynamic> feature) async {
  return showDialog<dynamic>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Container(
        child: SimpleDialog(
          titlePadding: EdgeInsets.only(top: DIALOG_PADDING),
          title: Text(
            "Please enter your information",
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: DIALOG_PADDING,
                  right: DIALOG_PADDING,
                  bottom: DIALOG_PADDING / 2),
              child: Column(children: <Widget>[
                MyDialogContent(homePageState, feature),
                Container(
                  height: 40,
                  width: 100,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(STANDARD_PADDING),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(homePageState.userInputs[feature.key]);
                    },
                    child: Text("OK"),
                  ),
                ),
              ]),
            )
          ],
        ),
      );
    },
  );
}

class MyDialogContent extends StatefulWidget {
  final MyHomePageState homePageState;
  final MapEntry<String, dynamic> feature;

  MyDialogContent(this.homePageState, this.feature);

  @override
  State<StatefulWidget> createState() {
    return new MyDialogContentState(homePageState, feature);
  }
}

class MyDialogContentState extends State<MyDialogContent> {
  final MyHomePageState homePageState;
  final MapEntry<String, dynamic> feature;

  MyDialogContentState(this.homePageState, this.feature);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: STANDARD_DIALOG_HEIGHT,
        width: STANDARD_DIALOG_WIDTH,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildInputWidget(
              homePageState, this, feature, homePageState.userInputs)
        ]));
  }
}
