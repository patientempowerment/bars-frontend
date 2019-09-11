import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'dart:math';
import 'bubbles.dart';

/// Returns the center image at the given position with given size.
Widget getCenterImage(double width, Offset position) {
  return Positioned(
    child: Image(image: AssetImage('assets/images/man-user.png'), width: width),
    left: position.dx,
    top: position.dy,
  );
}

/// Second prototype with bubbles as input and output representation.
class BubblesPage extends StatefulWidget {
  final HomepageState homepageState;

  BubblesPage(this.homepageState);

  @override
  State<StatefulWidget> createState() {
    return BubblesPageState(homepageState);
  }
}

/// [labelBubbleBoundingBoxes] Map of labels and their bubble position to let particles flow there.
class BubblesPageState extends State<BubblesPage> {
  final HomepageState homepageState;
  double imageDimensions;
  Offset imagePosition;
  Map<String, Rectangle> labelBubbleBoundingBoxes = Map();
  List<Particle> particles = List();

  BubblesPageState(this.homepageState);

  @override
  initState() {
    imageDimensions = homepageState.globalHeight / 4;
    imagePosition = Offset(homepageState.globalWidth / 2 - imageDimensions / 2,
        homepageState.globalHeight / 3);
    super.initState();
  }

  /// Returns all widgets of this page in a list.
  List<Widget> _getWidgets(BuildContext context) {
    double labelBubbleDimensions = homepageState.globalHeight / 8;
    List<Widget> widgets = List();

    widgets.add(getCenterImage(imageDimensions, imagePosition));
    _addLabelBubbles(widgets, labelBubbleDimensions, context);
    _addFeatureBubbles(widgets, labelBubbleDimensions);

    for (Particle particle in particles) {
      widgets.add(particle);
    }

    return widgets;
  }

  _getTextBoxWidth(String text, BuildContext context) {
    final textWidget = Text(text).build(context) as RichText;
    final renderObject = textWidget.createRenderObject(context);
    renderObject.layout(BoxConstraints());
    final lastBox = renderObject
        .getBoxesForSelection(TextSelection(
        baseOffset: 0, extentOffset: text.length))
        .last;
    return lastBox;
  }

  /// Arranges and adds label bubbles around center image. Does not check for overlapping bubbles in case of a high number.
  _addLabelBubbles(List<Widget> widgets, double labelBubbleDimensions, BuildContext context) {

    Map<String, dynamic> activeModels = Map.from(homepageState.modelsConfig);
    activeModels.removeWhere((k, v) => v["active"] == false);
    var boundingRadius =
        sqrt(pow((imageDimensions / 2), 2) * 2) + labelBubbleDimensions / 2;
    var angle = 0.0;
    var step = (2 * pi) / activeModels.length;
    Offset imageCenter = Offset(imagePosition.dx + imageDimensions / 2,
        imagePosition.dy + imageDimensions / 2);

    activeModels.forEach((k, v) {
      //45 comes from bubble container height(90) and width(90) divided by 2
      var textBoxBounds = (_getTextBoxWidth(v['title'], context));
      var x = (boundingRadius * cos(angle) - max(labelBubbleDimensions / 2, textBoxBounds.right / 2)).round();
      var y = (boundingRadius * sin(angle) - labelBubbleDimensions / 2).round();

      // Actually add label bubble.
      LabelBubble labelBubble = LabelBubble(
          v["title"],
          Offset(imageCenter.dx + x, imageCenter.dy + y),
          labelBubbleDimensions,
          homepageState);
      widgets.add(labelBubble);

      labelBubbleBoundingBoxes[k] = Rectangle(imageCenter.dx + x, imageCenter.dy + y, max(labelBubbleDimensions, textBoxBounds.right), labelBubbleDimensions);
      angle += step;
    });
  }

  /// Adds Feature bubbles and places them at the top bar.
  _addFeatureBubbles(List<Widget> widgets, double labelBubbleDimensions) {
    double featureBubbleOffset = 0.0;
    double featureBubbleWidth =
        (homepageState.globalWidth - STANDARD_PADDING * 4) /
            homepageState.featuresConfig.entries.length;
    for (MapEntry<String, dynamic> feature
    in homepageState.featuresConfig.entries) {
      widgets.add(FeatureBubble(
          Offset(featureBubbleOffset, 0.0),
          featureBubbleWidth - STANDARD_PADDING,
          labelBubbleDimensions,
          homepageState,
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
          child: Stack(children: _getWidgets(context)),
        ),
      ],
    );
  }
}
