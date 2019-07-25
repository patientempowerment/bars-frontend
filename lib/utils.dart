import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

readJSON(String path) async {
  String json = await rootBundle.loadString(path);
  return jsonDecode(json);
}

/// Reads model, feature and label configs.
readData() async {
  Map<String, dynamic> serverConfig = await readJSON(
      'assets/server.conf');
  Map<String, dynamic> localFallbacks = serverConfig["fallbacks"];
  String serverAddress = serverConfig["address"];

  // load features
  /*
  String databaseJSON = jsonEncode(serverConfig["database"]);
  Map<String, dynamic> features;
  try {
    http.Response featureConfigResponse = await http.post(serverAddress + '/feature-config', headers: {"Content-Type": "application/json"}, body: databaseJSON);
    features = jsonDecode(featureConfigResponse.body);
  }
  catch (e) { // something with the web request went wrong, use local file fallback
    features = loadJSON(localFallbacks['feature-config']);
  }
  */
  Map<String, dynamic> features =
      await readJSON(localFallbacks["feature-config"]);

  // load labels
  Map<String, dynamic> labelsConfig = await readJSON('assets/labels.conf');
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
    models = await readJSON(localFallbacks["models"]);
  }
  return [models, features, labels];
}

/// Sets first radio button or slider to min for all features in [featureConfig].
generateDefaultInputValues(featureConfig) {
  Map<String, dynamic> defaultInputs = {};
  featureConfig.forEach((k, v) {
    if (v["choices"] != null) {
      defaultInputs["$k"] = 0;
    } else {
      defaultInputs["$k"] = v["slider_min"].toDouble();
    }
  });
  return defaultInputs;
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

/// Returns the color for a [factor] greater 0.
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
