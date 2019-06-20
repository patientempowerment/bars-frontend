import 'dart:convert';
import 'package:bars_frontend/main.dart';
import 'charts/simple_bar_chart.dart';
import 'package:flutter/services.dart' show rootBundle;

String exampleResponse = "\{\"models\":\{\"COPD\":\{\"features\":\{\"asthma\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"diabetes\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"tuberculosis\":\{\"coefficient\": 0.2, \"mean\": 0.5\}\}\}\},\"asthma\":\{\"features\":\{\"COPD\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"diabetes\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"tuberculosis\":\{\"coefficient\": 0.2, \"mean\": 0.5\}\}\},\"diabetes\":\{\"features\":\{\"COPD\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"asthma\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"tuberculosis\":\{\"coefficient\": 0.2, \"mean\": 0.5\}\}\},\"tuberculosis\":\{\"features\":\{\"COPD\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"asthma\":\{\"coefficient\": 0.2, \"mean\": 0.5\},\"diabetes\":\{\"coefficient\": 0.2, \"mean\": 0.5\}\}\}\}";

prepareModels(StringWrapper models) async {
  String newModels = await rootBundle.loadString('assets/models.json');
  models.get = newModels;
  return newModels;
}

getIllnessProbs(Inputs inputs) {
  Map<String, dynamic> jsonResponse = jsonDecode(exampleResponse);
  
  double copdProb = computeProb('COPD', inputs, jsonResponse);
  //double asthmaProb = computeProb('asthma', inputs, jsonResponse);

  return [
    IllnessProb('COPD', copdProb),
    IllnessProb('Asthma', 0.0),
    IllnessProb('Diabetes', 0.6),
    IllnessProb('Tuberculosis', 0.0),
  ];
}

//List<String> allFeatures = ["COPD", "asthma", "diabetes", "tuberculosis"];

double computeProb(String label, Inputs inputs, Map<String, dynamic> json) {
  Map<String, dynamic> features = json['models'][label]['features'];
  double result = 0.0;

  result += label == 'COPD' ? 0 : features['COPD']['coefficient'] * inputs.copd.get();
  result += label == 'asthma' ? 0 : features['asthma']['coefficient'] * inputs.asthma.get();
  result += label == 'diabetes' ? 0 : features['diabetes']['coefficient'] * inputs.diabetes.get();
  result += label == 'tuberculosis' ? 0 : features['tuberculosis']['coefficient'] * inputs.tuberculosis.get();

  return result;
}