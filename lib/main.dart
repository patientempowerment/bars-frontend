import 'package:bars_frontend/widgets/barsPrototype.dart';
import 'package:bars_frontend/widgets/bubblesPrototype.dart';
import 'package:bars_frontend/widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';

void main() => runApp(MyApp());

const double PARTICLE_SIZE = 5.0;
const double STANDARD_PADDING = 5.0;
const double DIALOG_PADDING = 40.0;
const double STANDARD_FEATURE_BUBBLE_SIZE = 60;
const double LABEL_BUBBLE_BORDER_SIZE = 2.0;
const int STANDARD_ANIMATION_DURATION = 3;
const int MAX_PARTICLES = 5;
const double STANDARD_DIALOG_WIDTH = 600.0;
const double STANDARD_DIALOG_HEIGHT = 150.0;

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

/// [userInputs] Maps features and their current input (filled with averages for dataset at beginning).
/// [modelConfig] Models are represented as mappings from labels to their intercept and features, whereby features each contain their coefficients and mean value for given data set (see assets/models.json for example)
/// [featureConfig] Map of features to their user-facing names and their selecteable min/max values or choices)
/// [labelConfig] Map of labels to their user-facing names.
class MyHomePageState extends State<MyHomePage> {
  double globalWidth;
  double globalHeight;
  Map<String, dynamic> serverConfig;
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
        serverConfig = result[3];
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
