import 'package:flutter/material.dart';

enum SmokingBehavior { never, previous, current }

SmokingBehavior _smokingBehavior;

Widget getSmokingStatusRadioButtons(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Smoking Behavior"),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: SmokingBehavior.never,
                          groupValue: _smokingBehavior,
                          onChanged: (SmokingBehavior newValue) {
                            context.setState(() {
                              _smokingBehavior = newValue;
                            });
                          },
                        ),
                      ),
                      Text("never")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: SmokingBehavior.previous,
                          groupValue: _smokingBehavior,
                          onChanged: (SmokingBehavior newValue) {
                            context.setState(() {
                              _smokingBehavior = newValue;
                            });
                          },
                        ),
                      ),
                      Text("previously"),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: SmokingBehavior.current,
                          groupValue: _smokingBehavior,
                          onChanged: (SmokingBehavior newValue) {
                            context.setState(() {
                              _smokingBehavior = newValue;
                            });
                          },
                        ),
                      ),
                      Text("current")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}

enum Sex { female, male }

Sex _sex;

Widget getSexRadioButtons(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Sex"),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: Sex.female,
                          groupValue: _sex,
                          onChanged: (Sex newValue) {
                            context.setState(() {
                              _sex = newValue;
                            });
                          },
                        ),
                      ),
                      Text("female")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: Sex.male,
                          groupValue: _sex,
                          onChanged: (Sex newValue) {
                            context.setState(() {
                              _sex = newValue;
                            });
                          },
                        ),
                      ),
                      Text("male"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}

enum AlcoholFrequency { never, daily }
AlcoholFrequency _alcoholFrequency;

Widget getAlcoholFrequencyRadioButtons(context) {
  return (Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Alcohol Frequency"),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: AlcoholFrequency.never,
                          groupValue: _alcoholFrequency,
                          onChanged: (AlcoholFrequency newValue) {
                            context.setState(() {
                              _alcoholFrequency = newValue;
                            });
                          },
                        ),
                      ),
                      Text("never")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Radio(
                          value: AlcoholFrequency.daily,
                          groupValue: _alcoholFrequency,
                          onChanged: (AlcoholFrequency newValue) {
                            context.setState(() {
                              _alcoholFrequency = newValue;
                            });
                          },
                        ),
                      ),
                      Text("daily"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}


enum COPD { yes, no }
COPD _copd;

Widget getCOPDRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("COPD"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: COPD.yes,
                        groupValue: _copd,
                        onChanged: (COPD newValue) {
                          context.setState(() {
                            _copd = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: COPD.no,
                        groupValue: _copd,
                        onChanged: (COPD newValue) {
                          context.setState(() {
                            _copd = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

enum Asthma { yes, no }
Asthma _asthma;

Widget getAsthmaRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Asthma"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: Asthma.yes,
                        groupValue: _asthma,
                        onChanged: (Asthma newValue) {
                          context.setState(() {
                            _asthma = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: Asthma.no,
                        groupValue: _asthma,
                        onChanged: (Asthma newValue) {
                          context.setState(() {
                            _asthma = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

enum CoughOnMostDays { yes, no }
CoughOnMostDays _coughOnMostDays;

Widget getCoughOnMostDaysRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Cough On Most Days"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: CoughOnMostDays.yes,
                        groupValue: _coughOnMostDays,
                        onChanged: (CoughOnMostDays newValue) {
                          context.setState(() {
                            _coughOnMostDays = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: CoughOnMostDays.no,
                        groupValue: _coughOnMostDays,
                        onChanged: (CoughOnMostDays newValue) {
                          context.setState(() {
                            _coughOnMostDays = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

enum CurrentlySmoking { yes, no }
CurrentlySmoking _currentlySmoking;

Widget getCurrentlySmokingRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Currently Smoking"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: CurrentlySmoking.yes,
                        groupValue: _currentlySmoking,
                        onChanged: (CurrentlySmoking newValue) {
                          context.setState(() {
                            _currentlySmoking = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: CurrentlySmoking.no,
                        groupValue: _currentlySmoking,
                        onChanged: (CurrentlySmoking newValue) {
                          context.setState(() {
                            _currentlySmoking = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

enum Diabetes { yes, no }
Diabetes _diabetes;

Widget getDiabetesRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Diabetes"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: Diabetes.yes,
                        groupValue: _diabetes,
                        onChanged: (Diabetes newValue) {
                          context.setState(() {
                            _diabetes = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: Diabetes.no,
                        groupValue: _diabetes,
                        onChanged: (Diabetes newValue) {
                          context.setState(() {
                            _diabetes = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

enum NeverSmoked { yes, no }
NeverSmoked _NeverSmoked;

Widget getNeverSmokedRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Never Smoked"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: NeverSmoked.yes,
                        groupValue: _NeverSmoked,
                        onChanged: (NeverSmoked newValue) {
                          context.setState(() {
                            _NeverSmoked = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: NeverSmoked.no,
                        groupValue: _NeverSmoked,
                        onChanged: (NeverSmoked newValue) {
                          context.setState(() {
                            _NeverSmoked = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

enum PreviouslySmoked { yes, no }
PreviouslySmoked _PreviouslySmoked;

Widget getPreviouslySmokedRadioButtons(context) {
  return (Padding(
    padding: EdgeInsets.only(bottom: 5.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("Previously Smoked"),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: PreviouslySmoked.yes,
                        groupValue: _PreviouslySmoked,
                        onChanged: (PreviouslySmoked newValue) {
                          context.setState(() {
                            _PreviouslySmoked = newValue;
                          });
                        },
                      ),
                    ),
                    Text("yes")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: PreviouslySmoked.no,
                        groupValue: _PreviouslySmoked,
                        onChanged: (PreviouslySmoked newValue) {
                          context.setState(() {
                            _PreviouslySmoked = newValue;
                          });
                        },
                      ),
                    ),
                    Text("no"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}