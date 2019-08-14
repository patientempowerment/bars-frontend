import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';

class AdminDrawer extends StatefulWidget {
  final MyHomePageState homePageState;

  AdminDrawer(this.homePageState);

  @override //TODO: always have features represent actual features - > just invis until requested
  State<StatefulWidget> createState() {
    return AdminDrawerState(homePageState, homePageState.serverConfig);
  }
}

class AdminDrawerState extends State<AdminDrawer> {
  MyHomePageState homePageState;

  AdminDrawerState(this.homePageState, this.serverConfig);

  SubsetFetchState syncState = SubsetFetchState.Fetching;
  Map<String, dynamic> serverConfig;
  Map<String, dynamic> subsets;
  Map<String, dynamic> features = {
    " ": {"title": " "}
  }; //TODO: this breaks as it has no active
  Map<String, dynamic> fetchButton = {"enabled": true, "hasBeenPressed": false};
  Map<String, dynamic> trainButton = {
    "enabled": false,
    "hasBeenPressed": false
  };

  static Key formKey = new UniqueKey();

  @override
  void initState() {
    super.initState();
    subsets = _fetchSubsets();
  }

  _setSubsetTile(title) {
    for (var s in subsets.entries) {
      if (s.key == title) {
        (s.value["selected"] ??= false)
            ? s.value["selected"] = false
            : s.value["selected"] = true;
      }
    }
  }

  _fetchSubsets() {
    getDatabase(serverConfig).then((result) {
      setState(() {
        subsets = result;
        for (var subset in subsets.entries) {
          subset.value["syncButtonState"] = SyncButtonState.Ready;
        }
        syncState = SubsetFetchState.Fetched;
      });
    });
  }

  _fetchColumns() {
    getSubset(serverConfig).then(
      (result) {
        setState(
          () {
            features = result["columns"];
          },
        );
      },
    );
    fetchButton["enabled"] = false;
    trainButton["enabled"] = true;
  }

  _trainModels(String name, Map<String, dynamic> subset) {
    serverConfig['database']['collection'] = name;

    setState(() {
      subsets[name]["syncButtonState"] = SyncButtonState.Syncing;
    });
    trainModels(serverConfig).then((result) async {
      await writeJSON('subsets/', name, result);
      subsets[name]["syncButtonState"] = SyncButtonState.Synced;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: (subsets ??= {}).length,
                itemBuilder: (context, position) {
                  String name = subsets.keys.toList()[position];
                  return Card(
                      child: Row(
                    children: <Widget>[
                      Flexible(
                          child: ListTile(
                              key: Key(name),
                              title: Text(name),
                              onTap: () => setState(() {
                                    _setSubsetTile(name);
                                  }))),
                      loadingButton(name)
                    ],
                  ));
                }),
          ),
        ],
      ),
    );
  }

  Widget loadingButton(String subsetName) {
    SyncButtonState buttonState = subsets[subsetName]["syncButtonState"];

    Widget child;
    Color buttonColor = Colors.blue;

    if (buttonState == SyncButtonState.Ready) {
      child = Icon(Icons.autorenew, color: Colors.white);
    } else if (buttonState == SyncButtonState.Syncing) {
    } else if (buttonState == SyncButtonState.Synced) {
    } else if (buttonState == SyncButtonState.Error) {
      buttonColor = Colors.red;
    }

    return RaisedButton(
        onPressed: (buttonState == SyncButtonState.Ready)
            ? () => _trainModels(subsetName, subsets[subsetName])
            : null,
        child: child,
    color: buttonColor,
    disabledColor: buttonColor,);
  }
/*
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
                      fetchButton["enabled"] ? () => _fetchColumns() : null),
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
  }*/
}

enum SubsetFetchState { Fetching, Fetched, Error }

enum SyncButtonState { Ready, Syncing, Synced, Error }
