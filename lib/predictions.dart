import 'dart:convert';
import 'package:bars_frontend/main.dart';
import 'charts/simple_bar_chart.dart';
import 'package:flutter/services.dart' show rootBundle;

prepareModels(StringWrapper models) async {
  String newModels = await rootBundle.loadString('assets/models.json');
  models.get = newModels;
  return newModels;
}

getIllnessProbs(Inputs inputs, StringWrapper models) {
  Map<String, dynamic> jsonResponse = jsonDecode(models.get);
  
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

  result += getAddend(features, label, 'COPD', inputs.copd.get());
  result += getAddend(features, label, 'asthma', inputs.asthma.get());
  result += getAddend(features, label, 'diabetes', inputs.diabetes.get());
  result += getAddend(features, label, 'tuberculosis', inputs.tuberculosis.get());

  return result;
}

double getAddend(var features, String label, String feature, var value) {
  return label == feature ? 0.0 : features[feature]['coef'] * value;
}