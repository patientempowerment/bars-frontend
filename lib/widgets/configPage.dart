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

class _ConfigPageState extends State<ConfigPage>{

  AdminSettingsState adminSettingsState;
  _ConfigPageState(this.adminSettingsState);

  Map<String, dynamic> subsetsConfigs = {};
  Map<String, TextEditingController> textEditingControllers = {};

  @override
  void initState() {
    super.initState();
    _getConfigNames().then((configNames) {
      _loadConfigs(configNames).then((result){
        subsetsConfigs.forEach((name,config) {
         textEditingControllers[name] = TextEditingController(text: jsonEncode(config["features_config"]));

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
    adminSettingsState.homePageState.setConfig(fullConfig, configName);
  }

  _getSaveConfigButton(String name, TextEditingController textEditingController) {
    Function function;
    Color iconColor = Colors.green;
    Text text= Text("");
    try {
      jsonDecode(textEditingController.text);
      function = () async {
        setState(() {
          subsetsConfigs[name]["features_config"] = jsonDecode(textEditingController.text);
        });
        await writeJSON("subsets", name, subsetsConfigs[name]);
      };
    }
    catch (e) {
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

  _getConfigurationArea(String name) {
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
              onChanged: (text) => setState((){}),
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
                              Flexible(
                                  child: ListTile(
                                      key: Key(name),
                                      title: Text(name),
                                      onTap: () => _selectConfig(name))),
                              FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.settings, color: Colors.pink),
                                  label: Text(""),
                                  padding: EdgeInsets.all(0.0))
                            ],
                          ),
                          _getConfigurationArea(name)
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
  }
}