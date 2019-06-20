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
  DoubleWrapper height = new DoubleWrapper(120.0);
  DoubleWrapper weight = new DoubleWrapper(30);
  DoubleWrapper diastolicBloodPressure = new DoubleWrapper(30.0);
  DoubleWrapper systolicBloodPressure = new DoubleWrapper(70.0);
  DoubleWrapper noOfCigarettesPerDay = new DoubleWrapper(0.0);
  DoubleWrapper noOfCigarettesPreviouslyPerDay = new DoubleWrapper(0.0);
  Sex sex;
  AlcoholFrequency alcoholFrequency;
  YesNoWrapper currentlySmoking = new YesNoWrapper(null);
  YesNoWrapper neverSmoked = new YesNoWrapper(null);
  YesNoWrapper coughOnMostDays = new YesNoWrapper(null);
  YesNoWrapper asthma = new YesNoWrapper(null);
  YesNoWrapper copd = new YesNoWrapper(null);
  YesNoWrapper diabetes = new YesNoWrapper(null);
  YesNoWrapper previouslySmoked = new YesNoWrapper(null);
  YesNoWrapper sputumOnMostDays = new YesNoWrapper(null);
  YesNoWrapper wheezeInChestInLastYear = new YesNoWrapper(null);
  YesNoWrapper tuberculosis = new YesNoWrapper(null);

  getVariable(String variableName) {
    Map<String, dynamic> map = {
      'COPD': this.copd,
    };
  }
}