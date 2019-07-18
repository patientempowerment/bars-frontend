import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';

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
  String modelsResponse = await rootBundle.loadString('assets/ahriCleaner2_models.json');
  String featuresResponse = await rootBundle.loadString('assets/ahriCleaner2_config.json');
  Map<String, dynamic> features = jsonDecode(featuresResponse);
  Map<String, dynamic> models = jsonDecode(modelsResponse);
  return Pair(models, features);
}

generateDefaultInputValues(featureConfig) {
  Map<String, dynamic> defaultInputs = {};
  featureConfig.forEach((k,v) {
    if (v["choices"] != null) {
      defaultInputs["$k"] = 0;
    }
    else {
      defaultInputs["$k"] = v["slider_min"].toDouble();
    }
  });
  return defaultInputs;
}

buildInputWidget(MyHomePageState homePageState, State context, MapEntry<String, dynamic> feature, Map<String, dynamic> userInputs) {
  if (feature.value["choices"] != null) {
    var buttons = getRadioButtonInputRow(homePageState, context, feature, userInputs);
    return buttons;
  }
  else if (feature.value["slider_min"] != null) {
    var slider = getSliderInputRow(homePageState, context, feature, userInputs[feature.key]);
    return slider;
  }
  else {
    throw new Exception("Input Widget not supported: " + feature.key);
  }
}
final List<Color> colorGradient = [
  Colors.lightGreen,
  Colors.amber,
  Colors.orange,
  Colors.red
];

Color computeColor(int index) {
  index = index >= colorGradient.length
      ? colorGradient.length - 1
      : index;
  return colorGradient[index];
}

Color computeColorByFactor(double factor) {
  return colorGradient[(factor * (colorGradient.length - 1)).round().toInt()];
}