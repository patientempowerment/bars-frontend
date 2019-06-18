import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'charts/simple_bar_chart.dart';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Empowerment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Patient Empowerment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Inputs {
  double age = 18.0;
  double height = 120.0;
  double weight = 30;
  double diastolicBloodPressure = 30.0;
  double systolicBloodPressure = 70.0;
  double noOfCigarettesPerDay = 0.0;
  double noOfCigarettesPreviouslyPerDay = 0.0;
  Sex sex;
  AlcoholFrequency alcoholFrequency;
}

getIllnessProbs(Inputs inputs) {
  if(inputs.sex == Sex.female) {
    return
      [
        IllnessProb('Q1', 0),
        IllnessProb('Q2', 25000),
        IllnessProb('Q3', 100000),
        IllnessProb('Q4', 75000),
      ];
  }
  return [
    IllnessProb('Q1', 5000),
    IllnessProb('Q2', 25000),
    IllnessProb('Q3', 100000),
    IllnessProb('Q4', 75000),
  ];
}

class _MyHomePageState extends State<MyHomePage> {
  Inputs input = new Inputs();

  List<charts.Series<IllnessProb, String>> mapChartData(
      List<IllnessProb> data) {
    return [
      charts.Series<IllnessProb, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (IllnessProb sales, _) => sales.illness,
        measureFn: (IllnessProb sales, _) => sales.probability,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  getSexRadioButtons(this),
                  getAgeSlider(this),
                  getHeightSlider(this),
                  getWeightSlider(this),
                  getDiastolicBloodPressureSlider(this),
                  getSystolicBloodPressureSlider(this),
                  getAlcoholFrequencyRadioButtons(this),
                  getCurrentlySmokingRadioButtons(),
                  getNeverSmokedRadioButtons(),
                  getPreviouslySmokedRadioButtons(),
                  getNoOfCigarettesPerDaySlider(this),
                  getNoOfCigarettesPreviouslyPerDaySlider(this),
                  getWheezeInChestInLastYearRadioButtons(),
                  getCoughOnMostDaysRadioButtons(),
                  getSputumOnMostDaysRadioButtons(),
                  getCOPDRadioButtons(),
                  getAsthmaRadioButtons(),
                  getDiabetesRadioButtons(),
                  getTuberculosisRadioButtons(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SimpleBarChart(mapChartData(getIllnessProbs(input))),
            ),
          ],
        ),
      ),
    );
  }
}
