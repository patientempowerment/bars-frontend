import 'dart:convert';
import 'dart:math';
import 'package:charcode/charcode.dart';

import 'charts/simple_bar_chart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bars_frontend/utils.dart';

prepareModels(StringWrapper models) async {
  String newModels = await rootBundle.loadString('assets/models.json');
  models.value = newModels;
  return newModels;
}

getIllnessProbs(Inputs inputs, StringWrapper models, bool predictMode) {
  if (models.value != "" && predictMode) {
    Map<String, dynamic> jsonResponse = jsonDecode(models.value);

    double copdProb = computeProb('COPD', inputs, jsonResponse);
    double asthmaProb = computeProb('asthma', inputs, jsonResponse);
    double diabetesProb = computeProb('diabetes', inputs, jsonResponse);
    double tuberculosisProb = computeProb('tuberculosis', inputs, jsonResponse);

    copdProb = inputs.copd.value == YesNo.yes ? 1.0 : copdProb;
    asthmaProb = inputs.asthma.value == YesNo.yes ? 1.0 : asthmaProb;
    diabetesProb = inputs.diabetes.value == YesNo.yes ? 1.0 : diabetesProb;
    tuberculosisProb = inputs.tuberculosis.value == YesNo.yes ? 1.0 : tuberculosisProb;

    return [
      IllnessProb('COPD', copdProb),
      IllnessProb('Asthma', asthmaProb),
      IllnessProb('Diabetes', diabetesProb),
      IllnessProb('Tuberculosis', tuberculosisProb),
    ];
  } else {
    return [
      IllnessProb('COPD', 0.0),
      IllnessProb('Asthma', 0.0),
      IllnessProb('Diabetes', 0.0),
      IllnessProb('Tuberculosis', 0.0),
    ];
  }
}

double computeProb(String label, Inputs inputs, Map<String, dynamic> json) {
  Map<String, dynamic> features = json[label]["features"];
  double dot = 0.0;

  List<String> feature_names = ['age', 'alcoholFrequency', 'asthma', 'COPD', 'coughOnMostDays', 'currentlySmoking', 'diabetes', 'diastolicBloodPressure', 'height', 'neverSmoked', 'noOfCigarettesPerDay', 'noOfCigarettesPreviouslyPerDay', 'previouslySmoked', 'sex', 'sputumOnMostDays', 'systolicBloodPressure', 'tuberculosis', 'weight', 'wheezeInChestInLastYear'];
  for (String feature_name in feature_names) {
    dot += getAddend(features, label, feature_name, inputs);
  }

  double intercept = json[label]['intercept'];

  double result = 1 - (1 / (1 + exp(intercept + dot)));
  return result;
}

double getAddend(Map<String, dynamic> features, String label, String feature, Inputs inputs) {
  var value = inputs.getVariable(feature).get();
  value ??= features[feature]['mean'];
  return label == feature ? 0.0 : value * features[feature]['coef'];
}