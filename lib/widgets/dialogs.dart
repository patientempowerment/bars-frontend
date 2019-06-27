import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'radioButtons.dart';

class MyDialogContent extends StatefulWidget {
  final MyHomePageState homePageState;

  MyDialogContent(this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return new MyDialogContentState(homePageState);
  }
}

class MyDialogContentState extends State<MyDialogContent> {
  MyHomePageState homePageState;

  MyDialogContentState(this.homePageState);

  @override
  Widget build(BuildContext context) {
    return getSexRadioButtons(homePageState, this);
  }
}
