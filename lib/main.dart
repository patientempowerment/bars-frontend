import 'package:bars_frontend/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'charts/simple_bar_chart.dart';
import 'predictions.dart';
import 'package:bars_frontend/utils.dart';

import 'widgets/topBubbleBar.dart';

void main() => runApp(MyApp());

const double PARTICLE_SIZE = 5.0;
const double STANDARD_PADDING = 5.0;
const double STANDARD_FEATURE_BUBBLE_SIZE = 60;
const double LABEL_BUBBLE_BORDER_SIZE = 2.0;
const int STANDARD_ANIMATION_DURATION = 3;
const int MAX_PARTICLES = 5;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Empower',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Empower'),
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
  bool predictMode = false;
  bool successfulDrop = false;
  double globalWidth;
  double globalHeight;
  Map<String, dynamic> userInputs;
  Map<String, dynamic> modelConfig;
  Map<String, dynamic> featureConfig;

  @override
  void initState() {
    readData().then((result) {
      setState(() {
        modelConfig = result.first;
        featureConfig = result.second;
        userInputs = generateDefaultInputValues(featureConfig);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    if ((modelConfig == null) || (featureConfig == null)) {
      return new Container();
    }

    return Stack(
      children: <Widget>[
        PageView(children: [
          Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(STANDARD_PADDING),
                child:
                    new Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(40.0),
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        for(var feature in featureConfig.entries)
                          buildInputWidget(this, this, feature, userInputs),
                      ],
                    ),
                  ),
                  PredictModeButton(this),
                  Expanded(
                    child: SimpleBarChart(
                        mapChartData(getIllnessProbs(userInputs, modelConfig, predictMode))),
                  ),
                ],
              ),
            ),
            floatingActionButton: ResetButton(this),
          ),
          Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(STANDARD_PADDING),
                child:
                    new Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(STANDARD_PADDING * 2),
              child: Column(
                children: <Widget>[
                  BubblePrototype(this, modelConfig, globalWidth, globalHeight),
                ],
              ),
            ),
            floatingActionButton: ResetButton(this),
          ),
        ]),
      ],
    );
  }
}
