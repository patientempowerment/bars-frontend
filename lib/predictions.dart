import 'dart:convert';
import 'dart:math';
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




/*
double coef = feature != disease
          ? diseaseJson[feature]['coef']
          : 0.0;
      featureFactors.value[feature] == null
          ? featureFactors.value[feature] = {disease: coef}
          : featureFactors.value[feature][disease] = coef;
 */
List<IllnessProb> getIllnessProbs(
    Map<String, dynamic> inputs, Map<String, dynamic> modelConfig, Map<String, dynamic> featureConfig, bool predictMode) {
  if (predictMode) {

    var probabilities = {};

    modelConfig.forEach((k,v) => probabilities[k] = computeProb(v, inputs));

    //TODO CHECK IF THIS STUFF MAKES SENSE


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

double computeProb(Map<String, dynamic> modelValues, Map<String, dynamic> inputs) {
  double dot = 0.0;

  modelValues["features"].forEach((k,v) => dot += getSummand(v, inputs[k]));
  double intercept = modelValues["intercept"];
  double result = 1 - (1 / (1 + exp(intercept + dot)));
  return result;
}

double getSummand(Map<String, dynamic> featureValues, var featureInput) {
  featureInput ??= featureValues["mean"];
  return featureInput * featureValues["coef"];
}

