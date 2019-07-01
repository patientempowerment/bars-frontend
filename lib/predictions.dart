import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bars_frontend/utils.dart';

// cause name: (disease name: factor)

List<String> featureNames = [
  'age',
  'alcoholFrequency',
  'asthma',
  'COPD',
  'coughOnMostDays',
  'currentlySmoking',
  'diabetes',
  'diastolicBloodPressure',
  'height',
  'neverSmoked',
  'noOfCigarettesPerDay',
  'noOfCigarettesPreviouslyPerDay',
  'previouslySmoked',
  'sex',
  'sputumOnMostDays',
  'systolicBloodPressure',
  'tuberculosis',
  'weight',
  'wheezeInChestInLastYear'
];

List<String> diseases = ['COPD', 'diabetes', 'asthma', 'tuberculosis'];

prepareModels(StringWrapper models, MapWrapper featureFactors) async {
  String newModels = await rootBundle.loadString('assets/models.json');
  models.value = newModels;
  Map<String, dynamic> jsonResponse = jsonDecode(newModels);

  for (String disease in diseases) {
    Map<String, dynamic> diseaseJson = jsonResponse[disease]["features"];
    for (String feature in featureNames) {
      double coef = feature != disease ? diseaseJson[feature]['coef'] : 0.0;
      featureFactors.value[feature] == null
          ? featureFactors.value[feature] = {disease: coef}
          : featureFactors.value[feature][disease] = coef;
    }
  }
  return newModels;
}

List<IllnessProb> getIllnessProbs(
    Inputs inputs, StringWrapper models, bool predictMode) {
  if (models.value != "" && predictMode) {
    Map<String, dynamic> jsonResponse = jsonDecode(models.value);

    double copdProb = computeProb('COPD', inputs, jsonResponse);
    double asthmaProb = computeProb('asthma', inputs, jsonResponse);
    double diabetesProb = computeProb('diabetes', inputs, jsonResponse);
    double tuberculosisProb = computeProb('tuberculosis', inputs, jsonResponse);

    copdProb = inputs.copd.value == YesNo.yes ? 1.0 : copdProb;
    asthmaProb = inputs.asthma.value == YesNo.yes ? 1.0 : asthmaProb;
    diabetesProb = inputs.diabetes.value == YesNo.yes ? 1.0 : diabetesProb;
    tuberculosisProb =
        inputs.tuberculosis.value == YesNo.yes ? 1.0 : tuberculosisProb;

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

  for (String feature_name in featureNames) {
    dot += getAddend(features, label, feature_name, inputs);
  }

  double intercept = json[label]['intercept'];

  double result = 1 - (1 / (1 + exp(intercept + dot)));
  return result;
}

double getAddend(Map<String, dynamic> features, String label, String feature,
    Inputs inputs) {
  var value = inputs.getVariable(feature).get();
  value ??= features[feature]['mean'];
  return label == feature ? 0.0 : value * features[feature]['coef'];
}
