import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'charts/simple_bar_chart.dart';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'predictions.dart';
import 'package:bars_frontend/utils.dart';

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
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Inputs input = new Inputs();
  StringWrapper models = new StringWrapper("");
  bool predictMode = false;

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
    // TODO: not load models on every reload
    prepareModels(models);
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
                  getCurrentlySmokingRadioButtons(this),
                  getNeverSmokedRadioButtons(this),
                  getPreviouslySmokedRadioButtons(this),
                  getNoOfCigarettesPerDaySlider(this),
                  getNoOfCigarettesPreviouslyPerDaySlider(this),
                  getWheezeInChestInLastYearRadioButtons(this),
                  getCoughOnMostDaysRadioButtons(this),
                  getSputumOnMostDaysRadioButtons(this),
                  getCOPDRadioButtons(this),
                  getAsthmaRadioButtons(this),
                  getDiabetesRadioButtons(this),
                  getTuberculosisRadioButtons(this),
                ],
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  this.predictMode = true;
                });
              },
            ),
            Expanded(
              child: SimpleBarChart(
                  mapChartData(getIllnessProbs(input, models, predictMode))),
            ),
          ],
        ),
      ),
    );
  }
}
