import 'package:bars_frontend/widgets/barsPrototype.dart';
import 'package:bars_frontend/widgets/bubblesPrototype.dart';
import 'package:bars_frontend/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';

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

/// Represents main widget in app, consisting of two pages: bars and bubble prototype.
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

/// [userInputs] Map of feature names to their input values
/// [modelConfig] Map of label names to their features, including coefficients and means
/// [featureConfig] Map of feature names to their titles and (min/max values or choices)
/// [labelConfig] Map of label names to their titles
class MyHomePageState extends State<MyHomePage> {
  double globalWidth;
  double globalHeight;
  Map<String, dynamic> userInputs;
  Map<String, dynamic> modelConfig;
  Map<String, dynamic> featureConfig;
  Map<String, dynamic> labelConfig;

  @override
  void initState() {
    readData().then((result) {
      setState(() {
        modelConfig = result[0];
        featureConfig = result[1];
        labelConfig = result[2];
        userInputs = generateDefaultInputValues(featureConfig);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    // make sure that configs are loaded before displaying input and output
    if ((modelConfig == null) || (featureConfig == null)) {
      return new Container();
    }

    return Stack(
      children: <Widget>[
        PageView(children: [
          Scaffold(
            appBar: AppBar(
              title: MyAppBarContent(),
            ),
            body: Container(
              padding: EdgeInsets.all(40.0),
              child: BarsPrototype(this),
            ),
            floatingActionButton: ResetButton(this),
          ),
          Scaffold(
            appBar: AppBar(
              title: MyAppBarContent(),
            ),
            body: Container(
              padding: EdgeInsets.all(STANDARD_PADDING * 2),
              child: BubblePrototype(this),
            ),
            floatingActionButton: ResetButton(this),
          ),
        ]),
      ],
    );
  }
}

/// Represents header bar content including the logo.
class MyAppBarContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(STANDARD_PADDING),
      child: new Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
    );
  }
}
