import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pair {
  dynamic first;
  dynamic second;
  Pair(this.first, this.second);
}

readJSON(String path) async {
  String JSON = await rootBundle.loadString(path);
  print("loading " + path);
  return jsonDecode(JSON);
}

readData() async {
  Map<String, dynamic> serverConfig = await readJSON('assets/server.conf'); // TODO (far out): gather all this info not from file but thru GUI input
  Map<String, dynamic> localFallbacks = serverConfig["fallbacks"];
  String serverAddress = serverConfig["address"];

  /*// use this once we have good feature-config generation server side (or GUI to handle the mediocre server side generation)
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
  Map<String, dynamic> features = await readJSON(localFallbacks["feature-config"]);

  Map<String, dynamic> labelsConfig = await readJSON('assets/labels.conf'); // TODO (far out): gather this info not from file but thru GUI input
  Map<String, dynamic> labels = labelsConfig["label_titles"];
  String labelsJSON = jsonEncode({"labels": labelsConfig["labels"]});

  // load model coefficients and means
  Map<String, dynamic> models;
  try {
    http.Response modelsResponse = await http.post(serverAddress + '/models',
        headers: {"Content-Type": "application/json"},
        body: labelsJSON);
    models = jsonDecode(modelsResponse.body);
  }
  catch (e) { // something with the web request went wrong, use local file fallback
    models = await readJSON(localFallbacks["models"]);
  }
  return [models, features, labels];
}

generateDefaultInputValues(featureConfig) {
  Map<String, dynamic> defaultInputs = {};
  featureConfig.forEach((k,v) {
    if (v["choices"] != null) {
      defaultInputs["$k"] = 0;
    }
    else {
      defaultInputs["$k"] = v["slider_min"].toDouble();
    }
  });
  return defaultInputs;
}

buildInputWidget(MyHomePageState homePageState, State context, MapEntry<String, dynamic> feature, Map<String, dynamic> userInputs) {
  if (feature.value["choices"] != null) {
    var buttons = getRadioButtonInputRow(homePageState, context, feature, userInputs);
    return buttons;
  }
  else if (feature.value["slider_min"] != null) {
    var slider = getSliderInputRow(homePageState, context, feature, userInputs[feature.key]);
    return slider;
  }
  else {
    throw new Exception("Input Widget not supported: " + feature.key);
  }
}
final List<Color> colorGradient = [
  Colors.lightGreen,
  Colors.amber,
  Colors.orange,
  Colors.red
];

Color computeColor(int index) {
  index = index >= colorGradient.length
      ? colorGradient.length - 1
      : index;
  return colorGradient[index];
}

Color computeColorByFactor(double factor) {
  return colorGradient[(factor * (colorGradient.length - 1)).round().toInt()];
}