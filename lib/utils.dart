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

readData() async {
  // load server address, DB name and collection name
  String serverConfigJSON = await rootBundle.loadString(
      'assets/server.conf'); // TODO (far out): gather all this info not from file but thru GUI input
  Map<String, dynamic> serverConfig = jsonDecode(serverConfigJSON);
  Map<String, dynamic> localFallbacks = serverConfig["fallbacks"];
  String serverAddress = serverConfig["address"];
  String featureConfigString;

/*// TODO: use this once we have good feature-config generation server side (or GUI to handle the mediocre server side generation)
  String databaseJSON = jsonEncode(serverConfig["database"]);
  try {
    http.Response featureConfigResponse = await http.post(serverAddress + '/feature-config', headers: {"Content-Type": "application/json"}, body: databaseJSON);
    featureConfigString = featureConfigResponse.body;
  } catch (e) { // something with the web request went wrong, use local file fallback
    featureConfigString = await rootBundle.loadString(localFallbacks["feature-config"]);
  }
*/
  featureConfigString =
      await rootBundle.loadString(localFallbacks["feature-config"]);
  Map<String, dynamic> features = jsonDecode(featureConfigString);

  String labelsJSON = await rootBundle.loadString(
      'assets/labels.conf'); // TODO (far out): gather this info not from file but thru GUI input
  String modelsString;
  try {
    http.Response modelsResponse = await http.post(serverAddress + '/models',
        headers: {"Content-Type": "application/json"}, body: labelsJSON);
    modelsString = modelsResponse.body;
  } catch (e) {
    // something with the web request went wrong, use local file fallback
    modelsString = await rootBundle.loadString(localFallbacks["models"]);
  }
  Map<String, dynamic> models = jsonDecode(modelsString);

  return Pair(models, features);
}

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

buildInputWidget(MyHomePageState homePageState, State context,
    MapEntry<String, dynamic> feature, Map<String, dynamic> userInputs) {
  if (feature.value["choices"] != null) {
    var buttons =
        getRadioButtonInputRow(homePageState, context, feature, userInputs);
    return buttons;
  } else if (feature.value["slider_min"] != null) {
    var slider = getSliderInputRow(
        homePageState, context, feature, userInputs[feature.key]);
    return slider;
  } else {
    throw new Exception("Input Widget not supported: " + feature.key);
  }
}

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
