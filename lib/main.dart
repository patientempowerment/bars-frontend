import 'package:bars_frontend/widgets/bars.dart';
import 'package:bars_frontend/widgets/bubblesPage.dart';
import 'package:bars_frontend/widgets/buttons.dart';
import 'package:bars_frontend/widgets/adminSettings.dart';
import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';

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

  final GlobalKey adminDrawerKey = GlobalKey();

  @override
  void initState() {
    initializeData().then((result) {
      setState(() {
        appConfig = result["server_config"];
        setConfig(result["subset"], appConfig["active_subset"]);
      });
    });
    super.initState();
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
              child: Bars(this)
            ),
            drawer: AdminSettings(this, key: adminDrawerKey),
            floatingActionButton: ResetButton(this),
          ),
          Scaffold(
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
