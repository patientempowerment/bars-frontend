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
    dotProduct += multiplyInputAndCoefficient(v, inputs[k]);
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
  for(var i = homepageState.featuresConfig["age"]["slider_min"]; i<=homepageState.featuresConfig["age"]["slider_max"]; i++){
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
