import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'dart:math';
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
  Map<String, Offset> labelBubbleOffsets = Map();
  List<Particle> particles = List();

  BubblePrototypeState(this.homePageState, this.modelConfig,
      this.globalWidth, this.globalHeight) {
    xOffset = globalWidth / 2 - imageDimensions / 2;
    yOffset = globalHeight / 3;
    imagePosition = Offset(xOffset, yOffset);
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = List();
    var boundingRadius = sqrt(pow((imageDimensions/2),2)*2) + 50;
    var angle = 0.0;
    var step = (2*pi)/modelConfig.length;
    Offset imageCenter = Offset(imagePosition.dx+imageDimensions/2, imagePosition.dy+imageDimensions/2);

    modelConfig.forEach((k,v) {
      var x = (boundingRadius * cos(angle)-45).round(); //45 comes from bubble container height(90) and width(90) divided by 2
      var y = (boundingRadius * sin(angle)-45).round();
      LabelBubble labelBubble = LabelBubble(
        k, Offset(imageCenter.dx + x, imageCenter.dy + y), homePageState);
      labelBubbleOffsets[k] = Offset(imageCenter.dx + x, imageCenter.dy + y);
      angle += step;
      widgets.add(labelBubble);
    });

    double featureBubbleOffset = 0.0;
    double featureBubbleWidth = (globalWidth - 20) / homePageState.featureConfig.entries.length;
    for(MapEntry<String, dynamic> feature in homePageState.featureConfig.entries) {
      widgets.add(DragBubble(Offset(featureBubbleOffset, 0.0), featureBubbleWidth - 5, homePageState, this, modelConfig,
      feature));
      featureBubbleOffset += featureBubbleWidth;
    }

    widgets.add(getPatientImage(imageDimensions, imagePosition));
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
