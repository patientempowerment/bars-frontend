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

  final serverConfig;
  Map<String, dynamic> features;
  static Key formKey = new UniqueKey();

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
                      getFeatureConfig(
                              homePageState.serverConfig['address'],
                              jsonEncode(
                                  homePageState.serverConfig['database']),
                              homePageState.serverConfig['fallbacks']
                                  ['feature-config'])
                          .then((result) {
                        setState(() {
                          features = result;
                          for (var feature in features.entries) {
                            feature.value["selected"] = false;
                          }
                        });
                      });
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
          adminSettingsState.setState(() {
            var x = 1;
          });
        });
  }
}
