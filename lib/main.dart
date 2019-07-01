import 'package:flutter/material.dart';
import 'charts/simple_bar_chart.dart';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'predictions.dart';
import 'package:bars_frontend/utils.dart';

import 'widgets/topBubbleBar.dart';

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
  MapWrapper featureFactors = MapWrapper(Map());
  bool predictMode = false;
  bool successfulDrop = false;
  double globalWidth;
  double globalHeight;

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    prepareModels(models, featureFactors);
    return Stack(
      children: <Widget>[
        PageView(children: [
          Scaffold(
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
                        getSexRadioButtons(this, null),
                        getAgeSlider(this),
                        getHeightSlider(this),
                        getWeightSlider(this),
                        getDiastolicBloodPressureSlider(this),
                        getSystolicBloodPressureSlider(this),
                        getAlcoholFrequencyRadioButtons(this),
                        getCurrentlySmokingRadioButtons(this, null),
                        getNeverSmokedRadioButtons(this, null),
                        getPreviouslySmokedRadioButtons(this, null),
                        getNoOfCigarettesPerDaySlider(this),
                        getNoOfCigarettesPreviouslyPerDaySlider(this),
                        getWheezeInChestInLastYearRadioButtons(this, null),
                        getCoughOnMostDaysRadioButtons(this, null),
                        getSputumOnMostDaysRadioButtons(this, null),
                        getCOPDRadioButtons(this, null),
                        getAsthmaRadioButtons(this, null),
                        getDiabetesRadioButtons(this, null),
                        getTuberculosisRadioButtons(this, null),
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
          ),
          Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  getTopBubbleBar(this, featureFactors, globalWidth, globalHeight),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
