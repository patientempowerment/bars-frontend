import 'package:bars_frontend/fileIO.dart';
import 'package:bars_frontend/widgets/userInputPage.dart';
import 'package:bars_frontend/widgets/bubblesPage.dart';
import 'package:bars_frontend/widgets/buttons.dart';
import 'package:bars_frontend/widgets/adminSettings.dart';
import 'package:flutter/material.dart';
import 'package:bars_frontend/predictions.dart';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';

void main() => runApp(EmpowerApp());

const double PARTICLE_SIZE = 5.0;
const double STANDARD_PADDING = 5.0;
const double DIALOG_PADDING = 40.0;
const double STANDARD_FEATURE_BUBBLE_SIZE = 60;
const double LABEL_BUBBLE_BORDER_SIZE = 2.0;
const int STANDARD_ANIMATION_DURATION = 3;
const int MAX_PARTICLES = 5;
const double STANDARD_DIALOG_WIDTH = 600.0;
const double STANDARD_DIALOG_HEIGHT = 150.0;

class EmpowerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Empower',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(title: 'Empower'),
    );
  }
}

/// Represents main widget in app, consisting of two pages: bars and bubble prototype.
class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomepageState createState() => HomepageState();
}

/// [userInputs] Maps features and their current input (filled with averages for dataset at beginning).
/// [modelsConfig] Models are represented as mappings from labels to their intercept and features, whereby features each contain their coefficients and mean value for given data set (see assets/models_config_fallback.json for example)
/// [featuresConfig] Map of features to their user-facing names and their selectable min/max values or choices)
class HomepageState extends State<Homepage> {
  double globalWidth;
  double globalHeight;
  Map<String, dynamic> appConfig;
  Map<String, dynamic> userInputs;
  Map<String, bool> activeInputFields;
  Map<String, dynamic> modelsConfig;
  Map<String, dynamic> featuresConfig;
  Map<String, dynamic> subsetConfig;
  List<DataPoint> originalInputsPlot = [];
  List<DataPoint> changedInputsPlot = [];
  bool predictMode = false;

  DemoStateTracker demoStateTracker;
  String lineModel;

  final GlobalKey adminDrawerKey = GlobalKey();

  @override
  void initState() {
    _initializeData().then((result) {
      setState(() {
        appConfig = result["app_config"];
        setConfig(result["subset"], appConfig["active_subset"]);
        //storyModel = modelsConfig.entries.first.key; TODO
        lineModel = "diabetes";
        demoStateTracker = DemoStateTracker(demo: appConfig["demo_mode"]??=false);
      });
    });
    super.initState();
  }

  _initializeData() async {
    Map<String, dynamic> appConfig = {};
    try {
      appConfig = await readJSON('/', 'app_config');
    } catch (e) {
      appConfig = await legacyReadJSON('assets/app_config.json');
    }
    Map<String, dynamic> subset;
    Map<String, dynamic> response = {};
    if (appConfig["active_subset"] == null) {
      response["subset"] = {
        "columns": [],
        "models_config": Map<String, dynamic>(),
        "features_config": Map<String, dynamic>()
      };
      response["app_config"] = appConfig;
    } else {
      try {
        subset = await readJSON('subsets/', appConfig["active_subset"]);
        response["subset"] = subset;
        response["app_config"] = appConfig;
      } catch (e) {
        //TODO:
        response["subset"] = {
          "columns": [],
          "models_config": Map<String, dynamic>(),
          "features_config": Map<String, dynamic>()
        };
        response["app_config"] = appConfig;
      }
    }
    return response;
  }

  setConfig(Map<String, dynamic> fullConfig, String subsetName) {
    setState (() {
      modelsConfig = fullConfig["models_config"];
      featuresConfig = fullConfig["features_config"];
      userInputs = generateDefaultInputValues(featuresConfig);
      activeInputFields = deactivateInputFields(featuresConfig);
      appConfig["active_subset"] = subsetName;
    });
  }

  /// Deactivates all sliders and radio buttons in [featureConfig].
  deactivateInputFields(featureConfig) {
    Map<String, bool> activeInputFields = {};
    featureConfig.forEach((k, v) {
      activeInputFields[k] = false;
    });
    return activeInputFields;
  }

  /// For all features in [featureConfig]: Sets radio button or slider to mean.
  generateDefaultInputValues(featureConfig) {
    Map<String, dynamic> defaultInputs = {};
    featureConfig.forEach((k, v) {
      int mean = v["mean"].round();

      //Button selection needs int, slider needs double.
      if (v["choices"] != null) {
        defaultInputs[k] = mean;
      } else {
        defaultInputs[k] = mean.toDouble();
      }
    });
    return defaultInputs;
  }

  /// Creates either a radio button or a slider for [feature].
  /// [parentState] is the widget that the input widget is on(i.e., the widget that has to rebuild on state change).
  buildInputWidget(State parentState,
      MapEntry<String, dynamic> feature) {
    Function onChanged = (num newValue) {
      parentState.setState(() {
        userInputs[feature.key] = newValue;
        if (predictMode) {
          changedInputsPlot = generateDataPoints(this);
        }
      });
    };
    if (feature.value["choices"] != null) {
      return getRadioButtonInputRow(this, parentState, feature, onChanged);
    } else if (feature.value["slider_min"] != null) {
      return getSliderInputRow(this, parentState, feature, onChanged);
    } else {
      throw new Exception("Input Widget not supported: " + feature.key);
    }
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;

    // make sure that configs are loaded before displaying input and output
    if ((modelsConfig == null) || (featuresConfig == null)) {
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
              child: UserInputPage(this)
            ),
            drawer: AdminSettings(this, key: adminDrawerKey),
            floatingActionButton: ResetButton(this),
          ),
          if (demoStateTracker.bubbles) Scaffold(
            appBar: AppBar(
              title: MyAppBarContent(),
            ),
            body: Container(
              padding: EdgeInsets.all(STANDARD_PADDING * 2),
              child: BubblesPage(this),
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
      child: new Image.asset('assets/images/logo.png', fit: BoxFit.scaleDown),
    );
  }
}

class DemoStateTracker {
  bool demo;
  bool bars;
  bool graph;
  bool bubbles;

  DemoStateTracker({this.demo: false, this.bars: true, this.graph: false, this.bubbles: false});
}