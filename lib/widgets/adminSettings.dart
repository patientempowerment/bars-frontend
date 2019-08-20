import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/widgets/configPage.dart';
import 'package:bars_frontend/widgets/syncPage.dart';

class AdminSettings extends StatefulWidget {
  final MyHomePageState homePageState;

  AdminSettings(this.homePageState, {Key key}) : super(key: key);

  @override //TODO: always have features represent actual features - > just invis until requested
  State<StatefulWidget> createState() {
    return AdminSettingsState(homePageState, homePageState.appConfig);
  }
}

class AdminSettingsState extends State<AdminSettings>
    with SingleTickerProviderStateMixin {
  MyHomePageState homePageState;
  AdminSettingsState(this.homePageState, this.appConfig);


  //config
  Map<String, dynamic> appConfig;

  //controller
  TabController tabController;

  //pages
  ConfigPage configPage;
  SyncPage syncPage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    configPage = ConfigPage(this);
    syncPage = SyncPage(this);
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        SafeArea(child: getTabBar()),
        Flexible(child: getTabBarPages())
      ],
    ));
  }

  Widget getTabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(
          child: Text("Data Sync", style: TextStyle(color: Colors.blue)),
          icon: Icon(Icons.autorenew, color: Colors.blue)),
      Tab(
          child: Text("Config", style: TextStyle(color: Colors.blue)),
          icon: Icon(Icons.settings, color: Colors.blue))
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(
        controller: tabController,
        children: <Widget>[syncPage, configPage]);
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
