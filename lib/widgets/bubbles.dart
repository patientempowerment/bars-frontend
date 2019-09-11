import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'package:bars_frontend/predictions.dart';
import 'bubblesPage.dart';
import 'dialogs.dart';

/// Represents a draggable widget in a circular shape.
/// [initialOffset] is the position the bubble is originally at.
/// [labelBubbleWidth] is the width of [LabelBubble]s.
/// [feature] is the MapEntry of the feature to be represented.
/// It opens a dialog if you press or drag and release it.
class FeatureBubble extends StatefulWidget {
  final Offset initialOffset;
  final double width;
  final double labelBubbleWidth;
  final HomepageState homepageState;
  final BubblesPageState bubblePrototypeState;
  final MapEntry<String, dynamic> feature;

  FeatureBubble(this.initialOffset, this.width, this.labelBubbleWidth,
      this.homepageState, this.bubblePrototypeState, this.feature);

  @override
  State<StatefulWidget> createState() {
    return FeatureBubbleState(initialOffset, width, labelBubbleWidth,
        homepageState, bubblePrototypeState, feature);
  }
}

/// [offset] is the current position. It is changed when it is dragged.
/// [color] is the current color. It is changed when the input value of the associated [feature] changes.
/// [isSmall] changes to false once the bubble is dragged away from the top. And decides whether the title of the represented [feature] should be displayed or not.
/// [width] changes when the bubble is dragged the first time.
class FeatureBubbleState extends State<FeatureBubble>
    with SingleTickerProviderStateMixin {
  final HomepageState homepageState;
  final BubblesPageState bubblePrototypeState;
  final MapEntry<String, dynamic> feature;
  final double labelBubbleWidth;
  double width;
  Offset offset;
  Color color = Colors.black;
  bool isSmall = true;

  FeatureBubbleState(this.offset, this.width, this.labelBubbleWidth,
      this.homepageState, this.bubblePrototypeState, this.feature);

  /// Sets [color] to a new value according to the impact the feature has on all labels.
  /// And reloads the state.
  _computeNewColor() {
    double colorFactor = 0;
    for (String label in homepageState.modelsConfig.keys) {
      if (homepageState.modelsConfig[label]['features'][feature.key] != null) {
        double factor = homepageState.modelsConfig[label]['features']
                [feature.key]['coef'] *
            homepageState.userInputs[feature.key];
        colorFactor += factor < 0 ? 0 : factor;
      }
    }
    // average colorFactor over amount of labels
    colorFactor = colorFactor / homepageState.modelsConfig.keys.length;
    setState(() {
      color = computeColorByFactor(colorFactor);
    });
  }

  /// Adds [Particle]s to [bubblePrototypeState.particles] and reloads its state.
  /// Add [Particle]s proportionally to [feature] influence on each label
  _getParticles() {
    List<Particle> particles = List();
    dynamic rdm = Random();
    Map<String, dynamic> activeModels = Map.from(homepageState.modelsConfig);
    activeModels.removeWhere((k, v) => v["active"] == false);
    for (String label in activeModels.keys) {
      Rectangle labelBubbleBoundingBox =
          bubblePrototypeState.labelBubbleBoundingBoxes[label];
      if (activeModels[label]['features'][feature.key] != null) {
        double factor = activeModels[label]['features'][feature.key]['coef'] *
            homepageState.userInputs[feature.key];
        factor = factor < 0 ? 0 : factor;
        for (int i = 0; i < factor * MAX_PARTICLES; i++) {
          // choose random duration around one second
          int timerDuration = ((rdm.nextInt(60) / 100 + 0.7) * 1000).toInt();
          Offset labelBubbleCenter = Offset(
              labelBubbleBoundingBox.left +
                  (labelBubbleBoundingBox.right - labelBubbleBoundingBox.left) /
                      2 -
                  PARTICLE_SIZE / 2,
              labelBubbleBoundingBox.top +
                  labelBubbleWidth / 2 -
                  PARTICLE_SIZE / 2);
          Offset ownCenter =
              Offset(offset.dx + width / 2, offset.dy + width / 2);
          particles.add(
              Particle(ownCenter, labelBubbleCenter, timerDuration, color));
        }
      }
    }
    bubblePrototypeState.setState(() {
      bubblePrototypeState.particles = particles;
    });
  }

  List<Widget> _getBubble(context) {
    List<Widget> bubbleWidgets = List();

    bubbleWidgets.add(AnimatedContainer(
      duration: Duration(seconds: 1),
      width: width,
      height: width,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: new FlatButton(
        onPressed: invokeDialog(context, homepageState, feature, this),
        child: Container(),
      ),
    ));

    if (!isSmall) {
      bubbleWidgets.add(Padding(
        padding: EdgeInsets.only(top: STANDARD_PADDING),
        child: Container(
          width: width,
          child: Text(
            feature.value["title"],
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }
    return bubbleWidgets;
  }

  /// Uses [GestureDetector] to update [offset] and [color] on drag.
  /// Calls a [Dialog] when dragging stopped to get input of [feature].
  @override
  Widget build(BuildContext context) {
    _computeNewColor();
    return Stack(
      children: <Widget>[
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanStart: (details) {
              if (isSmall) {
                setState(() {
                  width = STANDARD_FEATURE_BUBBLE_SIZE;
                  isSmall = false;
                });
              }
            },
            onPanUpdate: (details) {
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
            onPanEnd: invokeDialog(context, homepageState, feature, this),
            child: Container(
              child: Column(
                children: _getBubble(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Represents the label bubbles around the center image.
/// Computes its own inner dimensions. [dimensions] is the outer border size only.
class LabelBubble extends StatelessWidget {
  final String title;
  final Offset position;
  final double dimensions;
  final HomepageState homepageState;

  LabelBubble(this.title, this.position, this.dimensions, this.homepageState);

  /// Returns the size of the inner bubble according to the probability returned by [getLabelProbabilities]
  double _computeInnerBubbleSize() {
    double value = 0.0;
    Map<String, dynamic> probabilities = getLabelProbabilities(
        homepageState.userInputs, homepageState.modelsConfig, true);
    probabilities.forEach(
        (k, v) => (k.toLowerCase() == title.toLowerCase()) ? value = v : null);
    double innerBubbleSize = value * dimensions;
    // make sure that inner bubble isn't bigger than border
    return innerBubbleSize > dimensions - LABEL_BUBBLE_BORDER_SIZE * 2
        ? dimensions - LABEL_BUBBLE_BORDER_SIZE * 2
        : innerBubbleSize;
  }

  /// Returns the new color according to the probability returned by [getLabelProbabilities]
  /// TODO currently assumes that the label title is the same as the label name, just camel case.
  Color _computeColor() {
    Map<String, dynamic> probabilities = getLabelProbabilities(
        homepageState.userInputs, homepageState.modelsConfig, true);
    for (var probability in probabilities.entries) {
      if (probability.key.toLowerCase() == title.toLowerCase()) {
        return computeColorByFactor(probability.value);
      }
    }
    return Colors.black; // this should never happen
  }

  @override
  Widget build(BuildContext context) {
    double innerBubbleSize = _computeInnerBubbleSize();
    return Positioned(
        top: position.dy,
        left: position.dx,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: dimensions,
                height: dimensions,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                      color: _computeColor(),
                      width: LABEL_BUBBLE_BORDER_SIZE,
                      style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AnimatedContainer(
                      width: innerBubbleSize,
                      height: innerBubbleSize,
                      duration: Duration(seconds: STANDARD_ANIMATION_DURATION),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: _computeColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: STANDARD_PADDING),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ));
  }
}

/// Represents an animated small bubble that flies from a [FeatureBubble] to a [LabelBubble].
/// It gets the position of its start ([offset]) and its end point ([targetOffset]).
/// [timerDuration] is a semi-random delay of ~1 second that the [Particle] waits until it starts moving. So you can
///   (1) see it flying when dialog is closed and
///   (2) see individual [Particle]s and not only one.
/// [color] is the color of the [FeatureBubble] it starts from.
class Particle extends StatefulWidget {
  Offset offset;
  Offset targetOffset;
  final timerDuration;
  Color color;

  Particle(this.offset, this.targetOffset, this.timerDuration, this.color);

  @override
  State<StatefulWidget> createState() {
    return ParticleState(offset, targetOffset, timerDuration, color);
  }
}

class ParticleState extends State<Particle> {
  Offset offset;
  final Offset targetOffset;
  final int timerDuration;
  Timer timer;
  Color color;

  /// Starts the timer for [timerDuration].
  startTimeout() {
    timer = new Timer(Duration(milliseconds: timerDuration), handleTimeout);
  }

  /// Gets called when [timeout] is reached. Sets the new position.
  void handleTimeout() {
    if (timer != null && offset != targetOffset) {
      setState(() {
        offset = targetOffset;
      });
    }
  }

  /// Makes sure the circular timer isn't called again after [Particle] is disposed.
  @override
  dispose() {
    super.dispose();
    timer = null;
  }

  ParticleState(this.offset, this.targetOffset, this.timerDuration, this.color);

  @override
  Widget build(BuildContext context) {
    startTimeout();
    return AnimatedPositioned(
      top: offset.dy,
      left: offset.dx,
      // -1 for the average timer time of one second
      duration: Duration(seconds: STANDARD_ANIMATION_DURATION - 1),
      child: Container(
        width: PARTICLE_SIZE,
        height: PARTICLE_SIZE,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

/// Opens a dialog and prompts color and particle amount changes on close.
invokeDialog(context, homepageState, feature, dragState) {
  return ([_]) async {
    var dialogInput = await asyncInputDialog(context, homepageState, feature);

    if (dialogInput != null) {
      dragState._computeNewColor();
      dragState._getParticles();
    }
  };
}
