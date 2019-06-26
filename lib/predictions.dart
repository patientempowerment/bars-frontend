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

    copdProb = inputs.copd.yesNo == YesNo.yes ? 1.0 : copdProb;
    asthmaProb = inputs.asthma.yesNo == YesNo.yes ? 1.0 : asthmaProb;
    diabetesProb = inputs.diabetes.yesNo == YesNo.yes ? 1.0 : diabetesProb;
    tuberculosisProb = inputs.tuberculosis.yesNo == YesNo.yes ? 1.0 : tuberculosisProb;

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
  Map<String, dynamic> features = json[label];
  double dot = 0.0;

  dot += getAddend(features, label, 'age', inputs);
  dot += getAddend(features, label, 'alcoholFrequency', inputs);
  dot += getAddend(features, label, 'asthma', inputs);
  dot += getAddend(features, label, 'COPD', inputs);
  dot += getAddend(features, label, 'coughOnMostDays', inputs);
  dot += getAddend(features, label, 'currentlySmoking', inputs);
  dot += getAddend(features, label, 'diabetes', inputs);
  dot += getAddend(features, label, 'diastolicBloodPressure', inputs);
  dot += getAddend(features, label, 'height', inputs);
  dot += getAddend(features, label, 'neverSmoked', inputs);
  dot += getAddend(features, label, 'noOfCigarettesPerDay', inputs);
  dot += getAddend(features, label, 'noOfCigarettesPreviouslyPerDay', inputs);
  dot += getAddend(features, label, 'previouslySmoked', inputs);
  dot += getAddend(features, label, 'sex', inputs);
  dot += getAddend(features, label, 'sputumOnMostDays', inputs);
  dot += getAddend(features, label, 'systolicBloodPressure', inputs);
  dot += getAddend(features, label, 'tuberculosis', inputs);
  dot += getAddend(features, label, 'weight', inputs);
  dot += getAddend(features, label, 'wheezeInChestInLastYear', inputs);

  double result = 0.0;
  result = 1 / (1 + pow($Epsilon, dot)); // TODO add intercept

  return result;
}

double getAddend(var features, String label, String feature, Inputs inputs) {
  var value = inputs.getVariable(feature).get();
  return label == feature ? 0.0 : features[feature]['coef'] * value;
}
