import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'buttons.dart';
import 'package:bars_frontend/charts/simple_bar_chart.dart';
import 'package:bars_frontend/predictions.dart';
import 'dart:convert';

class AdminSettings extends StatefulWidget {
  final MyHomePageState homePageState;

  AdminSettings(this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return AdminSettingsState(
        homePageState, homePageState.serverConfig, homePageState.featureConfig);
  }
}

class AdminSettingsState extends State<AdminSettings> {
  MyHomePageState homePageState;

  AdminSettingsState(this.homePageState, this.serverConfig, this.features);

  Map<String, dynamic> serverConfig;
  Map<String, dynamic> features;
  static Key formKey = new UniqueKey();
  var currentState = settingsState.chooseCollection;

  //List<FeatureTileContent> featureTiles;

  _setFeatureTile(title) {
    for (var f in features.entries) {
      if (f.key == title) {
        (f.value["selected"] ??= false)
            ? f.value["selected"] = false
            : f.value["selected"] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: homePageState.globalWidth,
        child: Drawer(
            child: Column(children: <Widget>[
          Row(children: <Widget>[
            Flexible(
                child: TextField(
                    key: formKey,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter collection to use'),
                    onSubmitted: (String newCollection) {
                      serverConfig['database']['collection'] = newCollection;
                    }))
          ]),
          Flexible(
            child: ListView(shrinkWrap: true, children: <Widget>[
              for (var feature in features.entries)
                ListTile(
                    key: Key(feature.key),
                    title: Text('${feature.key}'),
                    onTap: () => setState(() {
                          _setFeatureTile(feature.key);
                        }),
                    selected: feature.value["selected"] ?? false)
            ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[NextStepButton(this)],
          )
        ]))
        /*child: ReorderableListView(
              padding: EdgeInsets.zero,
              header: Row(
                key: UniqueKey(),
                children: <Widget>[
                  DrawerHeader(
                    key: UniqueKey(),
                    child: Text('Admin View'),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                TextField(
                  key: UniqueKey(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter collection to use'
                  ),
                ),
                //for (var feature in homePageState.featureConfig.entries) ListTile(key: Key(feature.key), title: Text('${feature.key}: ${feature.value}'))
              ],
              onReorder: (oldIndex, newIndex) {})),*/
        );
  }
}

class NextStepButton extends StatelessWidget {
  final AdminSettingsState adminSettingsState;

  NextStepButton(this.adminSettingsState);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          switch (adminSettingsState.currentState) {
            case settingsState.chooseCollection:
              getFeatureConfig(adminSettingsState.serverConfig).then((result) {
                adminSettingsState.setState(() {
                  adminSettingsState.features = result;
                  for (var feature in adminSettingsState.features.entries) {
                    feature.value["selected"] = false;
                  }
                  adminSettingsState.currentState = settingsState.chooseLabels;
                });
              });
              break;
            case settingsState.chooseLabels:
              List<String> labels = [];
              adminSettingsState.features.forEach((k, v) {
                if (v['selected']) {
                  labels.add(k);
                }
              });
              getModels(labels, adminSettingsState.serverConfig).then((result) {
                adminSettingsState.homePageState.setState(() {
                  adminSettingsState.homePageState.modelConfig = result;
                  Map<String, dynamic> label_titles = {};
                  for (var label in labels) {
                    label_titles[label] = label;
                  }
                  adminSettingsState.homePageState.labelConfig = label_titles;
                  var x=1;
                });
              });
              break;
            case settingsState.configureFeatures:
              // switch back to real view; "submit" button
              break;
          }

          var x = 1;
        });
  }
}

enum settingsState { chooseCollection, chooseLabels, configureFeatures }
