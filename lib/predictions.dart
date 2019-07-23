import 'dart:math';

/// Computes probabilities of al labels in modelConfig, only if predict mode is on.
Map<String, dynamic> getLabelProbabilities(Map<String, dynamic> inputs,
    Map<String, dynamic> modelConfig, bool predictMode) {
  Map<String, dynamic> probabilities = {};
  predictMode
      ? modelConfig
          .forEach((k, v) => probabilities[k] = computeProbability(v, inputs))
      : modelConfig.forEach((k, v) => probabilities[k] = 0);

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
