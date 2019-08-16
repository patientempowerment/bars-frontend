import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

ensureDirExistence(String path) async {
  final dir = new Directory(path);
  dir.exists().then((isThere) async {
    if (!isThere)
      await dir.create(recursive: true);
  });
}

legacyReadJSON(String path) async {
  String json = await rootBundle.loadString(path);
  return jsonDecode(json);
}

directoryContents(String subDir) async {
  List<String> files = [];
  final rootDir = await getApplicationDocumentsDirectory();
  await ensureDirExistence(rootDir.path + '/' + subDir);
  final dir = new Directory(rootDir.path + '/' + subDir);

  await for (FileSystemEntity entity in dir.list(recursive: false, followLinks: false)) {
    files.add(entity.path.split('/').last.replaceAll('.json', ''));
  }
  return files;
}

readJSON(String subDir, String name) async {
  final rootDir = await getApplicationDocumentsDirectory();
  ensureDirExistence(rootDir.path + '/' + subDir); // TODO: need this?
  String json = await new File(rootDir.path + '/' + subDir + '/' + name + '.json').readAsString();
  return jsonDecode(json);
}

writeJSON(String subDir, String filename, Map<String, dynamic> content) async {
  String json = jsonEncode(content);
  final rootDir = await getApplicationDocumentsDirectory();
  ensureDirExistence(rootDir.path + '/' + subDir);
  await new File(rootDir.path + '/' + subDir + filename + '.json').writeAsString(json);
}

trainModels(Map<String, dynamic> appConfig) async {
  String db = appConfig['database']['db'];
  String subset = appConfig['database']['collection'];
  String url = '/database/' + db + '/subset/' + subset + '/train';

  Map<String, dynamic> models;
  try {
    http.Response modelsResponse = await http.post(
        appConfig['address'] + url);

    models = jsonDecode(modelsResponse.body);
  }
  catch (e) { // something with the web request went wrong, use local file fallback
    print(e);
  }
  return models;
}

getDatabase(Map<String, dynamic> appConfig) async {
  String db = appConfig['database']['db'];
  String url = '/database/' + db;

  Map<String, dynamic> database;
  try {
    http.Response subsetResponse = await http.get(appConfig['address'] + url);
    if (subsetResponse.statusCode != 200)
      throw new Exception("Server Response: ${subsetResponse.statusCode}");
    database = jsonDecode(subsetResponse.body);
  }
  catch (e) {
    rethrow;
  }
  return database;
}

getSubset(Map<String, dynamic> appConfig) async {
  String db = appConfig['database']['db'];
  String subsetName = appConfig['database']['collection'];
  String url = '/database/' + db + '/subset/' + subsetName;

  Map<String, dynamic> subset;
  try {
    http.Response subsetResponse = await http.get(appConfig['address'] + url);
    subset = jsonDecode(subsetResponse.body);
  }
  catch (e) {
    print(e);
  }
  return subset;
}

/// Requests featureConfig from [serverAddress] with [databaseJSON] if available, else takes featureConfig from [fallbackFilename].
getFeatureConfig(Map<String, dynamic> appConfig) async {
  Map<String, dynamic> requestBody = {
    'db' : appConfig['database']['db'],
    'collection' : appConfig['database']['collection'],
  };

  Map<String, dynamic> features;
  try {
    http.Response featureConfigResponse = await http.post(appConfig['address'] + '/feature-config', headers: {"Content-Type": "application/json"}, body: jsonEncode(requestBody));
    features = jsonDecode(featureConfigResponse.body);
  }
  catch (e) { // something with the web request went wrong, use local file fallback
    features = await legacyReadJSON(appConfig['fallbacks']['features_config']);
  }
  return features;
}

initializeData() async {
  Map<String, dynamic> appConfig = await legacyReadJSON('assets/app_config.json');
  Map<String, dynamic> subset;
  Map<String, dynamic> response = {};
  if (appConfig["active_subset"] == null) {
    response["subset"] = {
    "columns": [],
    "models_config": Map<String, dynamic>(),
    "features_config": Map<String, dynamic>()
    };
    response["server_config"] = appConfig;
  }
  else {
    subset = await legacyReadJSON('assets/subsets/' + appConfig["active_subset"] + '.json');
    response["subset"] = subset;
    response["server_config"] = appConfig;
  }
  return response;
}

generateLabelsConfig(columns) {
  Map<String, dynamic> labels_config = {};

  for (var label in columns) {
    Map<String, dynamic> label_config = {};
    label_config["title"] = label;
    label_config["active"] = false;
    labels_config[label] = label_config;
  }

  return labels_config;
}
/// Reads model, feature and label configs.
readData() async {
  Map<String, dynamic> appConfig = await legacyReadJSON('assets/app_config.json');
  Map<String, dynamic> localFallbacks = appConfig["fallbacks"];
  String serverAddress = appConfig["address"];

  // load features
  /*
  getFeatureConfig(serverAddress, jsonEncode(appConfig["database"], localFallbacks["feature-config"])
  *//// WARN: Currently always using feature fallback.
  Map<String, dynamic> features =
      await legacyReadJSON(localFallbacks["features_config"]);

  // load labels
  Map<String, dynamic> labelsConfig = await legacyReadJSON(
      'assets/configs/labels_config.json');
  Map<String, dynamic> labels = labelsConfig["label_titles"];
  String labelsJSON = jsonEncode({"labels": labelsConfig["labels"]});

  // load model coefficients and means
  Map<String, dynamic> models;
  try {
    http.Response modelsResponse = await http
        .post(serverAddress + '/models',
            headers: {"Content-Type": "application/json"}, body: labelsJSON)
        .timeout(const Duration(seconds: 1));
    models = jsonDecode(modelsResponse.body);
  } catch (e) {
    // something with the web request went wrong, use local file fallback
    models = await legacyReadJSON(localFallbacks["models"]);
  }
  return [models, features, labels, appConfig];
}

/// For all features in [featureConfig]: Sets radio button or slider to mean.
generateDefaultInputValues(featureConfig) {
  Map<String, dynamic> defaultInputs = {};
  featureConfig.forEach((k, v) {
    int mean = v["mean"].round();

    //Button selection needs int, slider needs double.
    if (v["choices"] != null) {
      defaultInputs[k] = mean;
    } else {
      defaultInputs[k] = mean.toDouble();
    }
  });
  return defaultInputs;
}

/// Deactivates all sliders and radio buttons in [featureConfig].
deactivateInputFields(featureConfig) {
  Map<String, bool> activeInputFields = {};
  featureConfig.forEach((k, v) {
    activeInputFields[k] = false;
  });
  return activeInputFields;
}

/// Creates either a radio button or a slider for [feature].
/// [context] is the widget that the input widget is on(i.e., the widget that has to rebuild on state change).
buildInputWidget(MyHomePageState homePageState, State context,
    MapEntry<String, dynamic> feature) {
  if (feature.value["choices"] != null) {
    return getRadioButtonInputRow(homePageState, context, feature);
  } else if (feature.value["slider_min"] != null) {
    return getSliderInputRow(homePageState, context, feature);
  } else {
    throw new Exception("Input Widget not supported: " + feature.key);
  }
}

/// Returns the color for a [factor]. [factor] should be > 0.
Color computeColorByFactor(double factor) {
  final List<Color> colorGradient = [
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.red
  ];

  factor = factor > 1 ? 1 : factor;
  return colorGradient[(factor * (colorGradient.length - 1)).round().toInt()];
}

/// Returns color for active and inactive input field.
getActivityColor (MyHomePageState homePageState, String featureKey){
  return homePageState.activeInputFields[featureKey]
      ? Colors.blue
      : Colors.grey;
}
