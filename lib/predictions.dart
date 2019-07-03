import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bars_frontend/utils.dart';

/* import json
features:
  aFeature:
    title: "a title"
    choices:
      Never: 0
      Always: 2
      Sometimes: 1
  aSecondFeature:
    title: "a second title"
    slider_min: 0
    slider_max 100
 */

/*List<String> featureNames = [
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

List<String> diseases = ['COPD', 'diabetes', 'asthma', 'tuberculosis'];*/

Map<String, dynamic> features = {};
Map<String, dynamic> models = {};

prepareModels(StringWrapper modelFactors, MapWrapper featureFactors) async {

  String modelsResponse = await rootBundle.loadString('assets/models.json');
  String featuresResponse = await rootBundle.loadString('assets/features.json');
  features = jsonDecode(featuresResponse);
  models = jsonDecode(modelsResponse);
  modelFactors.value = modelsResponse;

  for (var label in models.entries) {

    Map<String, dynamic> labelFeatures = label.value["features"];

    for (var feature in features.entries) {

      double coef = feature.key != label.key
          ? labelFeatures[feature.key]['coef']
          : 0.0; //TODO: why is this 0.0 and not null
      featureFactors.value[feature.key] == null
          ? featureFactors.value[feature.key] = {label.key: coef}
          : featureFactors.value[feature.key][label.key] = coef;
    }
  }
  return modelsResponse;
}
/*
double coef = feature != disease
          ? diseaseJson[feature]['coef']
          : 0.0;
      featureFactors.value[feature] == null
          ? featureFactors.value[feature] = {disease: coef}
          : featureFactors.value[feature][disease] = coef;
 */
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
  Map<String, dynamic> relevantFeatures = models[label]["features"];
  double dot = 0.0;

  for (var feature in features.entries) {
    dot += getAddend(relevantFeatures, label, feature.key, inputs);
  }

  double intercept = models[label]['intercept'];

  double result = 1 - (1 / (1 + exp(intercept + dot)));
  return result;
}

double getAddend(Map<String, dynamic> features, String label, String feature,
    Inputs inputs) {
  var value = inputs.getVariable(feature).get();
  value ??= features[feature]['mean'];
  return label == feature ? 0.0 : value * features[feature]['coef'];
}
