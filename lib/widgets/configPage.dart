import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';
import 'dart:convert';
import 'package:bars_frontend/widgets/adminSettings.dart';

class ConfigPage extends StatefulWidget {
  final AdminSettingsState adminSettingsState;

  ConfigPage(this.adminSettingsState);

  @override
  State<StatefulWidget> createState() {
    return _ConfigPageState(adminSettingsState);
  }
}

class _ConfigPageState extends State<ConfigPage> {
  AdminSettingsState adminSettingsState;

  _ConfigPageState(this.adminSettingsState);

  Map<String, dynamic> subsetsConfigs = {};
  Map<String, bool> cardsOpen = {};
  Map<String, TextEditingController> textEditingControllers = {};

  @override
  void initState() {
    super.initState();
    _getConfigNames().then((configNames) {
      _loadConfigs(configNames).then((result) {
        subsetsConfigs.forEach((name, config) {
          textEditingControllers[name] = TextEditingController(
              text: jsonEncode(config["features_config"]));
          cardsOpen[name] = false;
        });
      });
    });
  }

  _loadConfigs(names) async {
    Map<String, dynamic> loadedConfigs = {};

    for (String name in names) {
      loadedConfigs[name] = await readJSON("subsets", name);
    }
    setState(() {
      subsetsConfigs = loadedConfigs;
    });
  }

  _getConfigNames() async {
    return directoryContents('subsets/');
  }

  _selectConfig(String configName) async {
    Map<String, dynamic> fullConfig = await readJSON("subsets", configName);
    setState(() {
      adminSettingsState.homePageState.setConfig(fullConfig, configName);
    });
  }

  _getSaveConfigButton(
      String name, TextEditingController textEditingController) {
    Function function;
    Color iconColor = Colors.green;
    Text text = Text("");
    try {
      jsonDecode(textEditingController.text);
      function = () async {
        setState(() {
          subsetsConfigs[name]["features_config"] =
              jsonDecode(textEditingController.text);
        });
        await writeJSON("subsets", name, subsetsConfigs[name]);
      };
    } catch (e) {
      function = null;
      iconColor = Colors.grey;
      text = Text(e.toString());
    }
    return FlatButton.icon(
        onPressed: function,
        icon: Icon(Icons.save, color: iconColor),
        label: text,
        padding: EdgeInsets.all(0.0));
  }

  _toggleCardState(name) {
    setState(() {
      cardsOpen[name] = !cardsOpen[name];
    });
  }

  _getLabelsConfigurationArea(String name) {
    Map<String, dynamic> subsetConfig = subsetsConfigs[name];
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: (subsetConfig["features_config"].keys).length,
          itemBuilder: (context, position) {
            String labelName =
                subsetConfig["features_config"].keys.toList()[position];
            return Card(
                child: Row(children: <Widget>[
              Flexible(
                  child: CheckboxListTile(
                title: Text(labelName),
                value: adminSettingsState.homePageState.labelsConfig[labelName]
                    ["active"],
                onChanged: (value) {
                  adminSettingsState.homePageState.setState(() {
                    adminSettingsState.homePageState.labelsConfig[labelName]
                        ["active"] = value;
                  });
                  setState(() {});
                },
              )),
            ]));
          }),
    );
  }

  _getFeaturesConfigurationArea(String name) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: TextField(
              maxLines: null,
              controller: textEditingControllers[name],
              onChanged: (text) => setState(() {}),
            ),
          ),
          _getSaveConfigButton(name, textEditingControllers[name])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: Center(
            child: ListView.builder(
                itemCount: (subsetsConfigs.keys).length,
                itemBuilder: (context, position) {
                  String name = subsetsConfigs.keys.toList()[position];
                  return Card(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () => _toggleCardState(name),
                              label: Text(""),
                              icon: cardsOpen[name]
                                  ? Icon(Icons.keyboard_arrow_down,
                                      color: Colors.grey)
                                  : Icon(Icons.keyboard_arrow_right,
                                      color: Colors.grey)),
                          Flexible(
                              child: ListTile(
                                  key: Key(name),
                                  title: Text(name),
                                  onTap: () => _toggleCardState(name))),
                          Radio(
                              groupValue: adminSettingsState
                                  .homePageState.appConfig["active_subset"],
                              value: name,
                              onChanged: (param) => _selectConfig(name))
                          /*FlatButton.icon(
                                  onPressed: () => _selectConfig(name),
                                  icon: Icon(Icons.fastfood, color: Colors.deepPurple),
                                  label: Text(""),
                                  padding: EdgeInsets.all(0.0))*/
                        ],
                      ),
                      if (cardsOpen[name]) _getLabelsConfigurationArea(name)
                    ],
                  ));
                }),
          ),
        ),
      ],
    );
  }
}
