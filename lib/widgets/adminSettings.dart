import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'package:animator/animator.dart';
import 'dart:math';

class AdminDrawer extends StatefulWidget {
  final MyHomePageState homePageState;

  AdminDrawer(this.homePageState, {Key key}) : super(key: key);

  @override //TODO: always have features represent actual features - > just invis until requested
  State<StatefulWidget> createState() {
    return AdminDrawerState(homePageState, homePageState.appConfig);
  }
}

class AdminDrawerState extends State<AdminDrawer>
    with SingleTickerProviderStateMixin {
  MyHomePageState homePageState;

  AdminDrawerState(this.homePageState, this.appConfig);

  TabController tabController;
  SubsetFetchState syncState = SubsetFetchState.Fetching;
  Map<String, dynamic> appConfig;
  Map<String, dynamic> subsets;
  Map<String, dynamic> features = {
    " ": {"title": " "}
  }; //TODO: this breaks as it has no active
  Map<String, dynamic> fetchButton = {"enabled": true, "hasBeenPressed": false};
  Map<String, dynamic> trainButton = {
    "enabled": false,
    "hasBeenPressed": false
  };
  Map<String, dynamic> subsetConfigs = {};
  List<String> subsetConfigNames = [];
  String errorMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    subsets = _fetchSubsets();
    tabController = TabController(length: 2, vsync: this);
    _getConfigNames().then((result) {
      subsetConfigNames = result;
    });
  }

  _getConfigNames() async {
    return directoryContents('subsets/');
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
      getDatabase(appConfig).then((result) {
        setState(() {
          subsets = result ?? {};
          for (var subset in subsets.entries) {
            subset.value["syncButtonState"] = SyncButtonState.Ready;
          }
          syncState = SubsetFetchState.Fetched;
        });
      }).catchError((e) {
        setState(() {
          errorMessage = e.toString();
          syncState = SubsetFetchState.Error;
        });
      });
  }

  _trainModels(String name, Map<String, dynamic> subset) {
    appConfig['database']['collection'] = name;

    setState(() {
      subsets[name]["syncButtonState"] = SyncButtonState.Syncing;
    });
    trainModels(appConfig).then((result) async {
      await writeJSON('subsets/', name, result);
      setState(() {
        subsets[name]["syncButtonState"] = SyncButtonState.Synced;
      });
    }).catchError((e) =>
    {
      setState(() {
        subsets[name]["syncButtonState"] = SyncButtonState.Error;
      }),
      print(e)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            SafeArea(child: getTabBar()),
            Flexible(child: getTabBarPages())
          ],
        )
    );
  }

  Widget loadingButton(String subsetName) {
    SyncButtonState buttonState = subsets[subsetName]["syncButtonState"];

    Widget child;
    Color buttonColor = Colors.blue;
    Color borderColor = Colors.blue;
    double elevation = 0;

    if (buttonState == SyncButtonState.Ready) {
      child = Icon(Icons.autorenew, color: Colors.blue);
      buttonColor = Colors.white;
    } else if (buttonState == SyncButtonState.Syncing) {
      buttonColor = Colors.white;
      borderColor = Colors.white;
      child = makeAnimator(1, 0, Icon(Icons.autorenew, color: Colors.blue));
    } else if (buttonState == SyncButtonState.Synced) {
      buttonColor = Colors.white;
      borderColor = Colors.white;
      child = Icon(Icons.check, color: Colors.green);
    } else if (buttonState == SyncButtonState.Error) {
      buttonColor = Colors.white;
      borderColor = Colors.white;
      child = Icon(Icons.error, color: Colors.red);
    }

    return RaisedButton(
      onPressed: (buttonState == SyncButtonState.Ready)
          ? () => _trainModels(subsetName, subsets[subsetName])
          : null,
      child: child,
      color: buttonColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: new BorderRadius.circular(5.0)),
      disabledColor: buttonColor,
      disabledElevation: elevation,
      elevation: elevation,
    );
  }

  Widget syncPage() {
    Widget content;
    if (syncState == SubsetFetchState.Fetching) {
      content = makeAnimator(1, 0, Icon(
          Icons.autorenew,
          color: Colors.blue,
          size: MediaQuery
              .of(context)
              .size
              .width / 8)
      );
    }
    else if (syncState == SubsetFetchState.Fetched) {
      content = ListView.builder(
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
                            onTap: () =>
                                setState(() {
                                  _setSubsetTile(name);
                                }))),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: loadingButton(name),
                    )
                  ],
                ));
          });
    }
    else if (syncState == SubsetFetchState.Error){
      content = Column(
        children: <Widget>[
          Icon(Icons.error, color: Colors.red),
          Text(errorMessage)
        ],
      );
    }
    return Column(
      children: <Widget>[
        Flexible(child: Center(child: content)),
      ],
    );
  }

  Widget configPage() {
    return Column(
      children: <Widget>[
        Flexible(
          child: Center(
            child: ListView.builder(
                itemCount: (subsetConfigNames ??= []).length,
                itemBuilder: (context, position) {
                  String name = subsetConfigNames[position];
                  return Card(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: ListTile(
                                  key: Key(name),
                                  title: Text(name),
                                  onTap: () => selectConfig(name)
                              )
                          ),
                          FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.settings, color: Colors.pink),
                                label: Text(""),
                                padding: EdgeInsets.all(0.0)
                          ),
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
  }

  selectConfig(String configName) async {
    Map<String, dynamic> fullConfig = await readJSON("subsets", configName);
    homePageState.setConfig(fullConfig, configName);
  }

  Widget makeAnimator(int seconds, int repeats, Widget icon) {
    return Animator(
        tween: Tween<double>(begin: 0, end: 2 * pi),
        duration: Duration(seconds: seconds),
        repeats: repeats,
        builder: (anim) => Transform.rotate(angle: anim.value, child: icon));
  }

  Widget getTabBar() {
    return TabBar(
        controller: tabController,
        tabs: [
          Tab(child: Text("Data Sync", style: TextStyle(color: Colors.blue)),
              icon: Icon(Icons.autorenew, color: Colors.blue)),
          Tab(child: Text("Config", style: TextStyle(color: Colors.blue)),
              icon: Icon(Icons.settings, color: Colors.blue))
        ]);
  }

  Widget getTabBarPages() {
    return TabBarView(
        controller: tabController,
        children: <Widget>[
          syncPage(),
          configPage()
        ]);
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
                appConfig['database']['collection'] = newCollection;
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
