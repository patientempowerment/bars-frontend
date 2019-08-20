import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';
import 'dart:math';
import 'package:bars_frontend/widgets/adminSettings.dart';
import 'package:animator/animator.dart';


class SyncPage extends StatefulWidget {

  final AdminSettingsState adminSettingsState;

  SyncPage(this.adminSettingsState);

  @override
  _SyncPageState createState() => _SyncPageState(adminSettingsState);
}

class _SyncPageState extends State<SyncPage> {
  AdminSettingsState adminSettingsState;

  _SyncPageState(this.adminSettingsState);

  SubsetFetchState syncState = SubsetFetchState.Fetching;
  String errorMessage;

  Map<String, dynamic> subsets;

  @override
  void initState() {
    super.initState();
    subsets = _fetchSubsets();
  }

  Widget _getSyncPage() {
    Widget content;
    if (syncState == SubsetFetchState.Fetching) {
      content = getAnimator(
          1,
          0,
          Icon(Icons.autorenew,
              color: Colors.blue, size: MediaQuery.of(context).size.width / 8));
    } else if (syncState == SubsetFetchState.Fetched) {
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
                            title: Text(name))),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: getLoadingButton(name),
                    )
                  ],
                ));
          });
    } else if (syncState == SubsetFetchState.Error) {
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

  _fetchSubsets() {
    getDatabase(adminSettingsState.appConfig).then((result) {
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
    adminSettingsState.appConfig['database']['collection'] = name;

    setState(() {
      subsets[name]["syncButtonState"] = SyncButtonState.Syncing;
    });
    trainModels(adminSettingsState.appConfig).then((result) async {
      await writeJSON('subsets/', name, result);
      setState(() {
        subsets[name]["syncButtonState"] = SyncButtonState.Synced;
      });
    }).catchError((e) => {
      setState(() {
        subsets[name]["syncButtonState"] = SyncButtonState.Error;
      }),
      print(e)
    });
  }
  Widget getLoadingButton(String subsetName) {
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
      child = getAnimator(1, 0, Icon(Icons.autorenew, color: Colors.blue));
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

  Widget getAnimator(int seconds, int repeats, Widget icon) {
    return Animator(
        tween: Tween<double>(begin: 0, end: 2 * pi),
        duration: Duration(seconds: seconds),
        repeats: repeats,
        builder: (anim) => Transform.rotate(angle: anim.value, child: icon));
  }

  @override
  Widget build(BuildContext context) {
    return _getSyncPage();
  }
}

enum SubsetFetchState { Fetching, Fetched, Error }
enum SyncButtonState { Ready, Syncing, Synced, Error }
