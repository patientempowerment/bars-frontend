import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';
import 'dart:convert';
import 'package:bars_frontend/widgets/adminSettings.dart';

class DemoConfigPage extends StatefulWidget {
  final AdminSettingsState adminSettingsState;

  DemoConfigPage(this.adminSettingsState);

  @override
  _DemoConfigPageState createState() => _DemoConfigPageState(adminSettingsState);
}

class _DemoConfigPageState extends State<DemoConfigPage> {
  AdminSettingsState adminSettingsState;
  HomepageState homepageState;
  DemoStateTracker demoStateTracker;


  _DemoConfigPageState(this.adminSettingsState);

  @override
  void initState() {
    homepageState = adminSettingsState.homePageState;
    demoStateTracker = homepageState.demoStateTracker;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("Bars"),
            Switch(
              value: demoStateTracker.bars,
              onChanged: ((value) {
                homepageState.setState(() => demoStateTracker.bars = value);
                setState(() {
                });
              }),
            ),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("Graph"),
            Switch(
              value: demoStateTracker.graph,
              onChanged: ((value) {
                homepageState.setState(() => demoStateTracker.graph = value);
                setState(() {
                });
              }),
            ),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("Bubbles"),
            Switch(
              value: demoStateTracker.bubbles,
              onChanged: ((value) {
                homepageState.setState(() => demoStateTracker.bubbles = value);
                setState(() {
                });
              }),
            ),

          ],
        )
      ],
    );
  }
}
