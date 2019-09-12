import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/colorUtils.dart';

/// Returns a [SimpleDialog] with the corresponding input option of [feature].
/// [context] is the BuildContext of the calling widget to which the result of the input is passed.
Future<dynamic> asyncInputDialog(BuildContext context,
    HomepageState homepageState, MapEntry<String, dynamic> feature) async {
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
                MyDialogContent(homepageState, feature),
                Container(
                  height: 40,
                  width: 100,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(STANDARD_PADDING),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(homepageState.userInputs[feature.key]);
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

/// Represents the content of the dialog, including an input option for [feature].
class MyDialogContent extends StatefulWidget {
  final HomepageState homepageState;
  final MapEntry<String, dynamic> feature;

  MyDialogContent(this.homepageState, this.feature);

  @override
  State<StatefulWidget> createState() {
    return new MyDialogContentState(homepageState, feature);
  }
}

class MyDialogContentState extends State<MyDialogContent> {
  final HomepageState homepageState;
  final MapEntry<String, dynamic> feature;

  MyDialogContentState(this.homepageState, this.feature);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: STANDARD_DIALOG_HEIGHT,
        width: STANDARD_DIALOG_WIDTH,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [homepageState.buildInputWidget(this, feature)]));
  }
}