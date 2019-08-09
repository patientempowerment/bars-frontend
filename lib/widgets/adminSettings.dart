import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

class AdminSettings extends StatefulWidget {
  final MyHomePageState homePageState;

  AdminSettings(this.homePageState);

  @override //TODO: always have features represent actual features - > just invis until requested
  State<StatefulWidget> createState() {
    return AdminSettingsState(homePageState, homePageState.serverConfig);
  }
}


class AdminSettingsState extends State<AdminSettings> {
  MyHomePageState homePageState;

  AdminSettingsState(this.homePageState, this.serverConfig);

  Map<String, dynamic> serverConfig;
  Map<String, dynamic> features = {
    " ": {"title": " "}
  };
  Map<String, dynamic> fetchButton = {"enabled": true, "hasBeenPressed": false};
  Map<String, dynamic> trainButton = {
    "enabled": false,
    "hasBeenPressed": false
  };

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

  _fetchLabels() {
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
      fetchButton["enabled"] = false;
      trainButton["enabled"] = true;
  }

  _trainModels() {
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
    trainButton["enabled"] = false;
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
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: STANDARD_PADDING),
              child: RaisedButton(
                  child: Text(
                    "Fetch Label Candidates",
                    textAlign: TextAlign.center,
                  ),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed:
                      fetchButton["enabled"] ? () => _fetchLabels() : null),
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
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: STANDARD_PADDING),
              child: RaisedButton(
                  child: Text(
                    "Train Models",
                    textAlign: TextAlign.center,
                  ),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed:
                      trainButton["enabled"] ? () => _trainModels() : null),
            ),
          ),
        ],
      ),
    );
  }
}
