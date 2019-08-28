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
  Map<String, TextEditingController> featureEditingControllers = {};
  TextEditingController modelTitleEditingController;
  String modelTitleBeingEdited = "";

  @override
  void initState() {
    super.initState();
    _getConfigNames().then((configNames) {
      _loadConfigs(configNames).then((result) {
        subsetsConfigs.forEach((name, config) {
          featureEditingControllers[name] = TextEditingController(
              text: jsonEncode(config["features_config"]));
          cardsOpen[name] = false;
        });
      });
    });
  }

  _getModelTitleTextField(String subset, String model) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: modelTitleEditingController,
              maxLines: 1,
              onSubmitted: (text) => {},
              onEditingComplete: () {
                setState(() async {
                  String text = modelTitleEditingController.text;
                  subsetsConfigs[subset]["models_config"][model]["title"] =
                      text;
                  await _saveConfigs({subset: subsetsConfigs[subset]});

                  adminSettingsState.homePageState.setState(() {
                    adminSettingsState.homePageState.modelsConfig[model]
                        ["title"] = text;
                  });
                  modelTitleBeingEdited = "";
                });
              },
              decoration: InputDecoration(helperText: "database_field: "+ model, helperStyle: TextStyle(color: Colors.blue))),
        )
      ],
    );
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

    Map<String, dynamic> appConfig = adminSettingsState.homePageState.appConfig;

    appConfig["active_subset"] = configName;
    await writeJSON('/', 'app_config', appConfig);
    setState(() {
      adminSettingsState.homePageState.setConfig(fullConfig, configName);
    });
  }

  //Saves one or many configuration files to disk. Keys => config name, values => config content
  _saveConfigs(Map<String, Map<String, dynamic>> configs) async {
    for (MapEntry<String, dynamic> config in configs.entries) {
      try {
        await writeJSON("subsets", config.key, config.value);
      } catch (e) {
        print(e);
        rethrow;
      }
    }
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
            Widget cardChild;
            String model =
                subsetConfig["features_config"].keys.toList()[position];
            if (modelTitleBeingEdited == model) {
              cardChild = _getModelTitleTextField(name, model);
            } else {
              cardChild = Row(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() {
                          modelTitleBeingEdited = model;
                          modelTitleEditingController = TextEditingController(
                              text: subsetConfig["models_config"][model]
                                  ["title"]);
                        })),
                Flexible(
                    child: CheckboxListTile(
                  title: Text(subsetConfig["models_config"][model]["title"],
                      style: TextStyle(fontWeight: FontWeight.w300)),
                  value: adminSettingsState.homePageState.modelsConfig[model]
                      ["active"],
                  onChanged: (value) {
                    subsetsConfigs[name]["models_config"][model]["active"] =
                        value;
                    _saveConfigs({name: subsetsConfigs[name]});
                    adminSettingsState.homePageState.setState(() {
                      adminSettingsState.homePageState.modelsConfig[model]
                          ["active"] = value;
                    });
                    setState(() {});
                  },
                )),
              ]);
            }
            return Card(
              child: cardChild,
            );
          }),
    );
  }

  //Functional, but not "usable"
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
              controller: featureEditingControllers[name],
              onChanged: (text) => setState(() {}),
            ),
          ),
          _getSaveConfigButton(name, featureEditingControllers[name])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String activeSubset =
        adminSettingsState.homePageState.appConfig["active_subset"];

    return Column(
      children: <Widget>[
        Flexible(
          child: Center(
            child: ListView.builder(
                itemCount: (subsetsConfigs.keys).length,
                itemBuilder: (context, position) {
                  String name = subsetsConfigs.keys.toList()[position];
                  return Container(
                    decoration: (activeSubset == name)
                        ? BoxDecoration(
                            border: Border.all(
                                width: 4, color: Colors.lightBlueAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))
                        : null,
                    child: Card(
                        elevation: (activeSubset == name) ? 4 : 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Card(
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                        child: ListTile(
                                            key: Key(name),
                                            title: Text(name),
                                            onTap: () => _selectConfig(name))),
                                    Radio(
                                        groupValue: adminSettingsState
                                            .homePageState
                                            .appConfig["active_subset"],
                                        value: name,
                                        onChanged: (param) =>
                                            _selectConfig(name))
                                  ],
                                ),
                              ),
                              if (activeSubset == name)
                                _getLabelsConfigurationArea(name)
                            ],
                          ),
                        )),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
