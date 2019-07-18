import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'bubbles.dart';
import '../utils.dart';
import 'dialogs.dart';
import 'bubbles.dart';

Widget getPatientImage(double width, Offset position) {
  return Positioned(
    child: Image(image: AssetImage('assets/man-user.png'), width: width),
    left: position.dx,
    top: position.dy,
  );
}

class BubblePrototype extends StatefulWidget {
  final MyHomePageState homePageState;
  final Map<String, dynamic> modelConfig;
  final double globalWidth;
  final double globalHeight;

  BubblePrototype(this.homePageState, this.modelConfig, this.globalWidth,
      this.globalHeight);

  @override
  State<StatefulWidget> createState() {
    return BubblePrototypeState(
        homePageState, modelConfig, globalWidth, globalHeight);
  }
}

class BubblePrototypeState extends State<BubblePrototype> {
  MyHomePageState homePageState;
  Map<String, dynamic> modelConfig;
  double globalWidth;
  double globalHeight;
  double imageDimensions = 200;
  double xOffset;
  double yOffset;
  Offset imagePosition;
  Map<String, Offset> diseaseBubbleOffsets = Map();
  List<Particle> particles = List();

  BubblePrototypeState(this.homePageState, this.modelConfig,
      this.globalWidth, this.globalHeight) {
    xOffset = globalWidth / 2 - imageDimensions / 2;
    yOffset = globalHeight / 4;
    imagePosition = Offset(xOffset, yOffset);
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = List();

    Widget COPDBubble = DiseaseBubble(
        "COPD", Offset(imagePosition.dx - 90, imagePosition.dy), homePageState);
    Widget asthmaBubble = DiseaseBubble(
        "Asthma",
        Offset(imagePosition.dx + imageDimensions, imagePosition.dy),
        homePageState);
    Widget tbBubble = DiseaseBubble(
        "Tuberculosis",
        Offset(imagePosition.dx - 90, imagePosition.dy + imageDimensions - 40),
        homePageState);
    Widget diabetesBubble = DiseaseBubble(
        "Diabetes",
        Offset(imagePosition.dx + imageDimensions,
            imagePosition.dy + imageDimensions - 40),
        homePageState);

    diseaseBubbleOffsets["COPD"] =
        Offset(imagePosition.dx - 90, imagePosition.dy);
    diseaseBubbleOffsets["asthma"] =
        Offset(imagePosition.dx + imageDimensions, imagePosition.dy);
    diseaseBubbleOffsets["tuberculosis"] =
        Offset(imagePosition.dx - 90, imagePosition.dy + imageDimensions - 40);
    diseaseBubbleOffsets["diabetes"] = Offset(
        imagePosition.dx + imageDimensions,
        imagePosition.dy + imageDimensions - 40);

    double featureBubbleOffset = 0.0;
    for(MapEntry<String, dynamic> feature in homePageState.featureConfig.entries) {
      widgets.add(DragBubble(Offset(featureBubbleOffset, 0.0), homePageState, this, modelConfig,
      feature));
      featureBubbleOffset += 100.0;
    }

    widgets.add(getPatientImage(imageDimensions, imagePosition));
    widgets.add(COPDBubble);
    widgets.add(asthmaBubble);
    widgets.add(tbBubble);
    widgets.add(diabetesBubble);
      for (Particle particle in particles) {
        widgets.add(particle);
      }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(children: getWidgets()),
          ),
        ],
      ),
    );
  }
}
