import 'dart:math';

import 'package:bars_frontend/main.dart';

/// Computes probabilities for all labels, if app is in predict mode.
Map<String, double> getLabelProbabilities(Map<String, dynamic> inputs,
    Map<String, dynamic> modelsConfig, bool predictMode) {
  Map<String, double> probabilities = {};
  predictMode
      ? modelsConfig
          .forEach((k, v) => probabilities[k] = computeProbability(v, inputs))
      : modelsConfig.forEach((k, v) => probabilities[k] = 0);

  return probabilities;
}

/// Computes probability for one label.
double computeProbability(
    Map<String, dynamic> modelValues, Map<String, dynamic> inputs) {
  double dotProduct = 0.0;

  modelValues["features"].forEach((k, v) {
    if(inputs[k]!= null) {
      dotProduct += multiplyInputAndCoefficient(v, inputs[k]);
    } else if (v["mean"] != null){
      dotProduct += multiplyInputAndCoefficient(v, v["mean"]);
    }
  });
  double intercept = modelValues["intercept"];
  double result = 1 - (1 / (1 + exp(intercept + dotProduct)));
  return result;
}

/// Takes mean when no input value is given.
double multiplyInputAndCoefficient(
    Map<String, dynamic> featureValues, var featureInput) {
  featureInput ??= featureValues["mean"];
  return featureInput * featureValues["coef"];
}

List<DataPoint> generateDataPoints(HomepageState homepageState) {
  List<DataPoint> points = [];
  Map<String, dynamic> inputs = Map.from(homepageState.userInputs);
  for(var i = 0; i<=100; i++){
    inputs["age"] = i;
    Map<String, double> probability = getLabelProbabilities(inputs, {homepageState.lineModel: homepageState.modelsConfig[homepageState.lineModel]}, true);
    points.add(DataPoint(i.toInt(), probability[homepageState.lineModel]));
  }
  return points;
}


class DataPoint {
  final int x;
  final double y;

  DataPoint(this.x, this.y);
}
