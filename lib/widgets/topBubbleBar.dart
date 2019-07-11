import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'bubbles.dart';
import '../utils.dart';
import 'dialogs.dart';

Widget getPatientImage(double width, Offset position) {
  return Positioned(
    child: Image(image: AssetImage('assets/man-user.png'), width: width),
    left: position.dx,
    top: position.dy,
  );
}

Widget getTopBubbleBar(MyHomePageState homePageState, MapWrapper featureFactors,
    double globalWidth, double globalHeight) {
  return BubblePrototype(
      homePageState, featureFactors, globalWidth, globalHeight);
}

class BubblePrototype extends StatefulWidget {
  MyHomePageState homePageState;
  MapWrapper featureFactors;
  double globalWidth;
  double globalHeight;

  BubblePrototype(this.homePageState, this.featureFactors, this.globalWidth,
      this.globalHeight);

  @override
  State<StatefulWidget> createState() {
    return BubblePrototypeState(
        homePageState, featureFactors, globalWidth, globalHeight);
  }
}

class BubblePrototypeState extends State<BubblePrototype> {
  MyHomePageState homePageState;
  MapWrapper featureFactors;
  double globalWidth;
  double globalHeight;
  double imageDimensions = 200;
  double xOffset;
  double yOffset;
  Offset imagePosition;
  Map<State, List<Widget>> particleList = Map();

  BubblePrototypeState(this.homePageState, this.featureFactors,
      this.globalWidth, this.globalHeight) {
    xOffset = globalWidth / 2 - imageDimensions / 2;
    yOffset = globalHeight / 4;
    imagePosition = Offset(xOffset, yOffset);
  }

  List<Widget> getWidgets() {
    List<Widget> list = List();

    list.add(DragBubble(Offset(0.0, 0.0), homePageState, this, featureFactors,
        "sex", "Sex", asyncSexInputDialog));
    list.add(DragBubble(Offset(100.0, 0.0), homePageState, this, featureFactors,
        "wheezeInChestInLastYear", "Wheeze", asyncWheezeInputDialog));
    list.add(DragBubble(Offset(200.0, 0.0), homePageState, this, featureFactors,
        "COPD", "COPD", asyncCOPDInputDialog));
    list.add(DragBubble(Offset(300, 0.0), homePageState, this, featureFactors,
        "neverSmoked", "Never Smoked", asyncNeverSmokedInputDialog));
    list.add(getPatientImage(imageDimensions, imagePosition));
    list.add(DiseaseBubble("COPD",
        Offset(imagePosition.dx - 90, imagePosition.dy), homePageState));
    list.add(DiseaseBubble(
        "Asthma",
        Offset(imagePosition.dx + imageDimensions, imagePosition.dy),
        homePageState));
    list.add(DiseaseBubble(
        "Tuberculosis",
        Offset(imagePosition.dx - 90, imagePosition.dy + imageDimensions - 40),
        homePageState));
    list.add(DiseaseBubble(
        "Diabetes",
        Offset(imagePosition.dx + imageDimensions,
            imagePosition.dy + imageDimensions - 40),
        homePageState));
    for (List<Widget> particleList in particleList.values) {
      for (Widget particle in particleList) {
        list.add(particle);
      }
    }
    return list;
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
