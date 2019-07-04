import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class DoubleWrapper {
  double value;

  DoubleWrapper(this.value);

  double get() {
    return this.value;
  }
}

class StringWrapper {
  String value;

  StringWrapper(this.value);
}

class MapWrapper {
  Map value;

  MapWrapper(this.value);
}
enum Sex { female, male }

class SexWrapper {
  Sex value;

  SexWrapper(this.value);

  double get() {
    return this.value == Sex.male ? 1.0 : 0.0;
  }
}

enum AlcoholFrequency {
  never,
  specialOccasions,
  oneToThreeTimesAMonth,
  OnceOrTwiceAWeek,
  threeOrFourTimesAWeek,
  daily
}

class AlcoholFrequencyWrapper {
  AlcoholFrequency value;

  AlcoholFrequencyWrapper(this.value);

  double get() {
    double result;
    switch (this.value) {
      case AlcoholFrequency.never:
        result = 6.0;
        break;
      case AlcoholFrequency.specialOccasions:
        result = 5.0;
        break;
      case AlcoholFrequency.oneToThreeTimesAMonth:
        result = 4.0;
        break;
      case AlcoholFrequency.OnceOrTwiceAWeek:
        result = 3.0;
        break;
      case AlcoholFrequency.threeOrFourTimesAWeek:
        result = 2.0;
        break;
      case AlcoholFrequency.daily:
        result = 1.0;
        break;
      default:
        result = 0.0;
        break;
    }
    return result;
  }
}

enum YesNo { yes, no }

class YesNoWrapper {
  YesNo value;

  YesNoWrapper(yesNo) {
    this.value = yesNo;
  }

  double get() {
    return value == YesNo.yes ? 1.0 : 0.0;
  }
}

class Pair {
  dynamic first;
  dynamic second;
  Pair(this.first, this.second);
}

class Inputs {
  DoubleWrapper age = new DoubleWrapper(18.0);
  AlcoholFrequencyWrapper alcoholFrequency = new AlcoholFrequencyWrapper(null);
  YesNoWrapper asthma = new YesNoWrapper(null);
  YesNoWrapper copd = new YesNoWrapper(null);
  YesNoWrapper coughOnMostDays = new YesNoWrapper(null);
  YesNoWrapper currentlySmoking = new YesNoWrapper(null);
  YesNoWrapper diabetes = new YesNoWrapper(null);
  DoubleWrapper diastolicBloodPressure = new DoubleWrapper(30.0);
  DoubleWrapper height = new DoubleWrapper(120.0);
  YesNoWrapper neverSmoked = new YesNoWrapper(null);
  DoubleWrapper noOfCigarettesPerDay = new DoubleWrapper(0.0);
  DoubleWrapper noOfCigarettesPreviouslyPerDay = new DoubleWrapper(0.0);
  YesNoWrapper previouslySmoked = new YesNoWrapper(null);
  SexWrapper sex = new SexWrapper(null);
  YesNoWrapper sputumOnMostDays = new YesNoWrapper(null);
  DoubleWrapper systolicBloodPressure = new DoubleWrapper(70.0);
  YesNoWrapper tuberculosis = new YesNoWrapper(null);
  DoubleWrapper weight = new DoubleWrapper(30);
  YesNoWrapper wheezeInChestInLastYear = new YesNoWrapper(null);

  getVariable(String variableName) {
    Map<String, dynamic> map = {
      'age': this.age,
      'alcoholFrequency': this.alcoholFrequency,
      'asthma': this.asthma,
      'COPD': this.copd,
      'coughOnMostDays': this.coughOnMostDays,
      'currentlySmoking': this.currentlySmoking,
      'diabetes': this.diabetes,
      'diastolicBloodPressure': this.diastolicBloodPressure,
      'height': this.height,
      'neverSmoked': this.neverSmoked,
      'noOfCigarettesPerDay': this.noOfCigarettesPerDay,
      'noOfCigarettesPreviouslyPerDay': this.noOfCigarettesPreviouslyPerDay,
      'previouslySmoked': this.previouslySmoked,
      'sex': this.sex,
      'sputumOnMostDays': this.sputumOnMostDays,
      'systolicBloodPressure': this.systolicBloodPressure,
      'tuberculosis': this.tuberculosis,
      'weight': this.weight,
      'wheezeInChestInLastYear': this.wheezeInChestInLastYear,
    };

    return map[variableName];
  }
}

class IllnessProb {
  final String illness;
  final double probability;

  IllnessProb(this.illness, this.probability);
}

readData() async {
  String modelsResponse = await rootBundle.loadString('assets/models.json');
  String featuresResponse = await rootBundle.loadString('assets/features.json');
  Map<String, dynamic> features = jsonDecode(featuresResponse);
  Map<String, dynamic> models = jsonDecode(modelsResponse);
  /*for (var label in models.entries) {
    Map<String, dynamic> labelFeatures = label.value["features"];

    for (var feature in features.entries) {

      double coef = feature.key != label.key
          ? labelFeatures[feature.key]['coef']
          : 0.0; //TODO: why is this 0.0 and not null
      featureFactors.value[feature.key] == null
          ? featureFactors.value[feature.key] = {label.key: coef}
          : featureFactors.value[feature.key][label.key] = coef;
    }
  }*/
  return Pair(models, features);
}

generateInputs(featureConfig) {
  Map<String, dynamic> result;
  featureConfig.forEach((k,v) => result["$k"] = null);
  return result;
}