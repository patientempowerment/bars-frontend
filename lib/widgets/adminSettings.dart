import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

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
    return Drawer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: DIALOG_PADDING),
            child: TextField(
              key: formKey,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter collection to use'),
              onSubmitted: (String newCollection) {
                serverConfig['database']['collection'] = newCollection;
              },
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                for (var feature in features.entries)
                  ListTile(
                      key: Key(feature.key),
                      title: Text('${feature.key}'),
                      onTap: () => setState(
                            () {
                              _setFeatureTile(feature.key);
                            },
                          ),
                      selected: feature.value["selected"] ?? false)
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: STANDARD_PADDING),
                  child: RaisedButton(
                    child: Text(
                      "Request possible Labels",
                      textAlign: TextAlign.center,
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      getFeatureConfig(serverConfig).then(
                        (result) {
                          setState(
                            () {
                              features = result;
                              for (var feature in features.entries) {
                                feature.value["selected"] = false;
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: STANDARD_PADDING),
                  child: RaisedButton(
                      child: Text(
                        "Predict for selected Labels",
                        textAlign: TextAlign.center,
                      ),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        List<String> labels = [];
                        features.forEach((k, v) {
                          if (v['selected']) {
                            labels.add(k);
                          }
                        });
                        getModels(labels, serverConfig).then((result) {
                          homePageState.setState(() {
                            homePageState.modelConfig = result;
                            Map<String, dynamic> label_titles = {};
                            for (var label in labels) {
                              label_titles[label] = label;
                            }
                            homePageState.labelConfig = label_titles;
                          });
                        });
                      }),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
