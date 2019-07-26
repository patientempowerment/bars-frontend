import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'buttons.dart';
import 'package:bars_frontend/charts/simple_bar_chart.dart';
import 'package:bars_frontend/predictions.dart';


class AdminSettings extends StatefulWidget {
  final MyHomePageState homePageState;

  AdminSettings(this.homePageState);
  @override
  State<StatefulWidget> createState() {
    return AdminSettingsState(homePageState);
  }
}

class AdminSettingsState extends State<AdminSettings> {
  MyHomePageState homePageState;
  AdminSettingsState(this.homePageState);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: homePageState.globalWidth,
      child: Drawer(
          child: ReorderableListView(
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
                for (var feature in homePageState.featureConfig.entries) ListTile(key: Key(feature.key), title: Text('${feature.key}: ${feature.value}'))
              ],
              onReorder: (oldIndex, newIndex) {})),
    );
  }
}

class Entry extends StatelessWidget {
  final MyTile myTile;
  Entry(this.myTile);


  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => print("tap"),
          subtitle: new Text("Subtitle"),
          leading: new Text("Leading"),
          selected: true,
          trailing: new Text("trailing"),
          title: new Text(t.title));

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList(),
    );
  }
}

class MyTile {
  String title;
  List<MyTile> children;
  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listOfTiles = <MyTile>[
  new MyTile(
    'Animals',
    <MyTile>[
      new MyTile(
        'Dogs',
        <MyTile>[
          new MyTile('Coton de Tulear'),
          new MyTile('German Shepherd'),
          new MyTile('Poodle'),
        ],
      ),
      new MyTile('Cats'),
      new MyTile('Birds'),
    ],
  ),
  new MyTile(
    'Cars',
    <MyTile>[
      new MyTile('Tesla'),
      new MyTile('Toyota'),
    ],
  ),
  new MyTile(
    'Phones',
    <MyTile>[
      new MyTile('Google'),
      new MyTile('Samsung'),
      new MyTile(
        'OnePlus',
        <MyTile>[
          new MyTile('1'),
          new MyTile('2'),
          new MyTile('3'),
          new MyTile('4'),
          new MyTile('5'),
          new MyTile('6'),
          new MyTile('7'),
          new MyTile('8'),
          new MyTile('9'),
          new MyTile('10'),
          new MyTile('11'),
          new MyTile('12'),
        ],
      ),
    ],
  ),
];