import 'package:bars_frontend/widgets/demoConfigPage.dart';
import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/widgets/configPage.dart';
import 'package:bars_frontend/widgets/syncPage.dart';
import 'package:bars_frontend/utils.dart';

class AdminSettings extends StatefulWidget {
  final HomepageState homepageState;

  AdminSettings(this.homepageState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdminSettingsState(homepageState, homepageState.appConfig);
  }
}

class AdminSettingsState extends State<AdminSettings>
    with TickerProviderStateMixin {
  HomepageState homepageState;
  AdminSettingsState(this.homepageState, this.appConfig);


  //config
  Map<String, dynamic> appConfig;

  //controller
  TabController tabController;

  //pages
  ConfigPage configPage;
  SyncPage syncPage;
  DemoConfigPage demoConfigPage;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: homepageState.demoStateTracker.demo? 3:2, vsync: this);
    configPage = ConfigPage(this);
    syncPage = SyncPage(this);
    demoConfigPage = DemoConfigPage(this);
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        SafeArea(child: getTabBar()),
        Flexible(child: getTabBarPages()),
        Switch(
          value: homepageState.demoStateTracker.demo,
          onChanged: ((value) async {
            homepageState.setState(() {homepageState.demoStateTracker.demo = value;
            homepageState.appConfig["demo_mode"] = value;
            setState(() {
              tabController = TabController(length: homepageState.demoStateTracker.demo? 3:2, vsync: this);
            });});
            await writeJSON('/', 'app_config', homepageState.appConfig);
          }),
        )
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
          icon: Icon(Icons.settings, color: Colors.blue)),
      if (homepageState.demoStateTracker.demo) Tab(
        child: Text("f.toggle", style: TextStyle(color: Colors.blue)),
        icon: Icon(Icons.developer_mode, color: Colors.blue)
      )
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(
        controller: tabController,
        children: <Widget>[
          syncPage,
          configPage,
          if (homepageState.demoStateTracker.demo) demoConfigPage]);
  }
}
