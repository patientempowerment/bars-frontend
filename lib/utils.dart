class DoubleWrapper {
  double get;
  DoubleWrapper(this.get);
}

class StringWrapper {
  String get;
  StringWrapper(this.get);
}

enum Sex { female, male }

enum AlcoholFrequency { never, daily }

enum YesNo { yes, no }

class YesNoWrapper {
  YesNo yesNo;
  YesNoWrapper(yesNo) {
    this.yesNo = yesNo;
  }
  double get() {
    return yesNo == YesNo.yes ? 1.0 : 0.0;
  }
}

class Inputs {
  DoubleWrapper age = new DoubleWrapper(18.0);
  AlcoholFrequency alcoholFrequency;
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
  Sex sex;
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
      'diastolicBloodPRessure': this.diastolicBloodPressure,
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