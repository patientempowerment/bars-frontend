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
          titlePadding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          title: Text(
            "Please enter your information",
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: Column(children: <Widget>[
                MyDialogContent(homePageState, feature),
                Container(
                  height: 40,
                  width: 100,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
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
        height: 150,
        width: 600,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildInputWidget(
              homePageState, this, feature, homePageState.userInputs)
        ]));
  }
}
