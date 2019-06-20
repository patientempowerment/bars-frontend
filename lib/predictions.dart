import 'dart:convert';
import 'charts/simple_bar_chart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bars_frontend/utils.dart';

prepareModels(StringWrapper models) async {
  String newModels = await rootBundle.loadString('assets/models.json');
  models.value = newModels;
  return newModels;
}

getIllnessProbs(Inputs inputs, StringWrapper models) {
  Map<String, dynamic> jsonResponse = jsonDecode(models.value);
  
  double copdProb = computeProb('COPD', inputs, jsonResponse);
  double asthmaProb = computeProb('asthma', inputs, jsonResponse);
  double diabetesProb = computeProb('diabetes', inputs, jsonResponse);
  double tuberculosisProb = computeProb('tuberculosis', inputs, jsonResponse);

  return [
    IllnessProb('COPD', copdProb),
    IllnessProb('Asthma', asthmaProb),
    IllnessProb('Diabetes', diabetesProb),
    IllnessProb('Tuberculosis', tuberculosisProb),
  ];
}

double computeProb(String label, Inputs inputs, Map<String, dynamic> json) {
  Map<String, dynamic> features = json[label];
  double result = 0.0;

  result += getAddend(features, label, 'age', inputs);
  result += getAddend(features, label, 'asthma', inputs);
  result += getAddend(features, label, 'COPD', inputs);
  result += getAddend(features, label, 'diabetes', inputs);
  result += getAddend(features, label, 'tuberculosis', inputs);

  return result;
}

double getAddend(var features, String label, String feature, Inputs inputs) {
  var value = inputs.getVariable(feature).get();
  return label == feature ? 0.0 : features[feature]['coef'] * value;
}