import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'dart:math';
import 'bubbles.dart';

/// Returns the image at the given position with given size.
Widget getCenterImage(double width, Offset position) {
  return Positioned(
    child: Image(image: AssetImage('assets/man-user.png'), width: width),
    left: position.dx,
    top: position.dy,
  );
}

/// Represents the second prototype with bubbles as input and output representation.
class BubblePrototype extends StatefulWidget {
  final MyHomePageState homePageState;

  BubblePrototype(this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return BubblePrototypeState(homePageState);
  }
}

/// [labelBubbleOffsets] Map of label names and their position to let particles flow there.
class BubblePrototypeState extends State<BubblePrototype> {
  final MyHomePageState homePageState;
  double imageDimensions;
  Offset imagePosition;
  Map<String, Offset> labelBubbleOffsets = Map();
  List<Particle> particles = List();

  BubblePrototypeState(this.homePageState);

  @override
  initState() {
    imageDimensions = homePageState.globalHeight / 4;
    imagePosition = Offset(homePageState.globalWidth / 2 - imageDimensions / 2,
        homePageState.globalHeight / 3);
    super.initState();
  }

  /// Returns all widgets of bubble prototype as a list.
  List<Widget> _getWidgets() {
    double labelBubbleDimensions = homePageState.globalHeight / 8;
    List<Widget> widgets = List();

    widgets.add(getCenterImage(imageDimensions, imagePosition));
    _addLabelBubbles(widgets, labelBubbleDimensions);
    _addFeatureBubbles(widgets, labelBubbleDimensions);

    for (Particle particle in particles) {
      widgets.add(particle);
    }

    return widgets;
  }

  /// Adds label bubbles around center image.
  _addLabelBubbles(List<Widget> widgets, double labelBubbleDimensions) {
    var boundingRadius =
        sqrt(pow((imageDimensions / 2), 2) * 2) + labelBubbleDimensions / 2;
    var angle = 0.0;
    var step = (2 * pi) / homePageState.modelConfig.length;
    Offset imageCenter = Offset(imagePosition.dx + imageDimensions / 2,
        imagePosition.dy + imageDimensions / 2);

    homePageState.modelConfig.forEach((k, v) {
      //45 comes from bubble container height(90) and width(90) divided by 2
      var x = (boundingRadius * cos(angle) - 45).round();
      var y = (boundingRadius * sin(angle) - 45).round();

      // Actually add label bubble.
      LabelBubble labelBubble = LabelBubble(
          homePageState.labelConfig[k],
          Offset(imageCenter.dx + x, imageCenter.dy + y),
          labelBubbleDimensions,
          homePageState);
      widgets.add(labelBubble);

      labelBubbleOffsets[k] = Offset(imageCenter.dx + x, imageCenter.dy + y);
      angle += step;
    });
  }

  /// Adds Feature bubbles on top.
  _addFeatureBubbles(List<Widget> widgets, double labelBubbleDimensions) {
    double featureBubbleOffset = 0.0;
    double featureBubbleWidth =
        (homePageState.globalWidth - STANDARD_PADDING * 4) /
            homePageState.featureConfig.entries.length;
    for (MapEntry<String, dynamic> feature
    in homePageState.featureConfig.entries) {
      widgets.add(DragBubble(
          Offset(featureBubbleOffset, 0.0),
          featureBubbleWidth - STANDARD_PADDING,
          labelBubbleDimensions,
          homePageState,
          this,
          feature));
      featureBubbleOffset += featureBubbleWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(children: _getWidgets()),
        ),
      ],
    );
  }
}
