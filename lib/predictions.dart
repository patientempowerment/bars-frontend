import 'dart:convert';
import 'dart:math';
import 'package:bars_frontend/utils.dart';

Map<String, dynamic> getIllnessProbs(
    Map<String, dynamic> inputs, Map<String, dynamic> modelConfig, bool predictMode) {

  Map<String, dynamic> probabilities = {};
  if (predictMode) {
    modelConfig.forEach((k,v) => probabilities[k] = computeProb(v, inputs));
  } else {
    modelConfig.forEach((k,v) => probabilities[k] = 0);
  }
  return probabilities;
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

