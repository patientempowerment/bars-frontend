import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

Future<dynamic> extraAsyncInputDialog(BuildContext context,
    MyHomePageState homePageState,
MapEntry<String, dynamic> feature) async {
  return asyncInputDialog(context, homePageState, feature);
}
Future<dynamic> asyncInputDialog(
    BuildContext context,
    MyHomePageState homePageState,
    MapEntry<String, dynamic> feature) async {
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
                  MyDialogContent(homePageState, feature),
                  Container(height: 50),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(homePageState.userInputs[feature.key]);
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildInputWidget(homePageState, this, feature, homePageState.userInputs)]);
  }
}
