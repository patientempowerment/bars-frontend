import 'package:flutter/material.dart';
import 'charts/simple_bar_chart.dart';
import 'predictions.dart';
import 'package:bars_frontend/utils.dart';

import 'widgets/topBubbleBar.dart';

void main() => runApp(MyApp());

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
  Inputs input = new Inputs();
  StringWrapper models = new StringWrapper("");
  MapWrapper featureFactors = MapWrapper(Map());
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
        predictMode = true;
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
                padding: const EdgeInsets.all(5.0),
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
                          buildInputWidget(this, feature, userInputs),
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
                        mapChartData(getIllnessProbs(userInputs, modelConfig, predictMode))),
                  ),
                ],
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(5.0),
                child:
                    new Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  getTopBubbleBar(this, modelConfig, globalWidth, globalHeight),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
