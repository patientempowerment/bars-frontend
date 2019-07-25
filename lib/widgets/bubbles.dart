import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'package:bars_frontend/predictions.dart';
import 'bubblesPrototype.dart';
import 'dialogs.dart';

/// Represents a draggable widget that includes a widget of type [FeatureBubble].
/// [initialOffset] is the position the bubble is originally at.
/// [bubbleWidth] is the width of the child [FeatureBubble].
/// [labelBubbleWidth] is the width of [LabelBubble]s.
/// [feature] is the MapEntry of the feature to be represented.
class DragBubble extends StatefulWidget {
  final Offset initialOffset;
  final double bubbleWidth;
  final double labelBubbleWidth;
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final MapEntry<String, dynamic> feature;

  DragBubble(this.initialOffset, this.bubbleWidth, this.labelBubbleWidth,
      this.homePageState, this.bubblePrototypeState, this.feature);

  @override
  State<StatefulWidget> createState() {
    return DragBubbleState(initialOffset, bubbleWidth, labelBubbleWidth,
        homePageState, bubblePrototypeState, feature);
  }
}

/// [offset] is the current position of the [DragBubble]. It is changed when the [DragBubble] is dragged.
/// [color] is the current color of the [DragBubble]. It is changed when the input value of the associated [feature] changes.
/// [isSmall] changes to false once the [DragBubble] is dragged away from the top.
/// [bubbleWidth] changes when the [DragBubble] is dragged the first time.
class DragBubbleState extends State<DragBubble>
    with SingleTickerProviderStateMixin {
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final MapEntry<String, dynamic> feature;
  final double labelBubbleWidth;
  double bubbleWidth;
  Offset offset;
  Color color = Colors.black;
  bool isSmall = true;

  DragBubbleState(this.offset, this.bubbleWidth, this.labelBubbleWidth,
      this.homePageState, this.bubblePrototypeState, this.feature);

  /// Sets [color] to a new value according to the impact the feature has on all labels.
  /// And reloads the state.
  _computeNewColor() {
    double colorFactor = 0;
    for (String label in homePageState.modelConfig.keys) {
      if (homePageState.modelConfig[label]['features'][feature.key] != null) {
        double factor = homePageState.modelConfig[label]['features']
                [feature.key]['coef'] *
            homePageState.userInputs[feature.key];
        colorFactor += factor < 0 ? 0 : factor;
      }
    }
    // average colorFactor over amount of labels
    colorFactor = colorFactor / homePageState.modelConfig.keys.length;
    setState(() {
      color = computeColorByFactor(colorFactor);
    });
  }

  /// Adds [Particle]s to [bubblePrototypeState.particles] and reloads its state.
  /// Add [Particle]s proportionally to [feature] influence on each label
  _getParticles() {
    List<Particle> particles = List();
    dynamic rdm = Random();
    for (String label in homePageState.modelConfig.keys) {
      if (homePageState.modelConfig[label]['features'][feature.key] != null) {
        double factor = homePageState.modelConfig[label]['features']
                [feature.key]['coef'] *
            homePageState.userInputs[feature.key];
        factor = factor < 0 ? 0 : factor;
        for (int i = 0; i < factor * MAX_PARTICLES; i++) {
          // choose random duration around one second
          int timerDuration = ((rdm.nextInt(60) / 100 + 0.7) * 1000).toInt();
          Offset labelBubbleCenter = Offset(
              bubblePrototypeState.labelBubbleOffsets[label].dx +
                  labelBubbleWidth / 2 -
                  PARTICLE_SIZE / 2,
              bubblePrototypeState.labelBubbleOffsets[label].dy +
                  labelBubbleWidth / 2 -
                  PARTICLE_SIZE / 2);
          Offset ownCenter =
              Offset(offset.dx + bubbleWidth / 2, offset.dy + bubbleWidth / 2);
          particles.add(
              Particle(ownCenter, labelBubbleCenter, timerDuration, color));
        }
      }
    }
    bubblePrototypeState.setState(() {
      bubblePrototypeState.particles = particles;
    });
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
                    bubbleWidth = STANDARD_FEATURE_BUBBLE_SIZE;
                    isSmall = false;
                  });
                }
              },
              onPanUpdate: (details) {
                setState(() {
                  offset = Offset(offset.dx + details.delta.dx,
                      offset.dy + details.delta.dy);
                });
              },
              onPanEnd: invokeDialog(context, homePageState, feature, this),
              child: FeatureBubble(
                  homePageState, this, feature, color, bubbleWidth, isSmall)),
        ),
      ],
    );
  }
}

/// Represents the actual bubble without any logic. Gets its color and width from parent widget.
/// [isSmall] decides whether the title of the represented [feature] should be displayed or not.
/// Has press behavior that opens the dialog just as if its [DragBubble] was pressed.
class FeatureBubble extends StatelessWidget {
  final MyHomePageState homePageState;
  final DragBubbleState dragState;
  final MapEntry<String, dynamic> feature;
  final Color color;
  final double bubbleWidth;
  final bool isSmall;

  FeatureBubble(this.homePageState, this.dragState, this.feature, this.color,
      this.bubbleWidth, this.isSmall);

  List<Widget> _composeBubble(context) {
    List<Widget> bubbleWidgets = List();

    bubbleWidgets.add(AnimatedContainer(
      duration: Duration(seconds: 1),
      width: bubbleWidth,
      height: bubbleWidth,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: new FlatButton(
        onPressed: invokeDialog(context, homePageState, feature, dragState),
        child: Container(),
      ),
    ));

    if (!isSmall) {
      bubbleWidgets.add(Padding(
        padding: EdgeInsets.only(top: STANDARD_PADDING),
        child: Container(
          width: bubbleWidth,
          child: Text(
            feature.value["title"],
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }
    return bubbleWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _composeBubble(context),
      ),
    );
  }
}

/// Represents the label bubbles around the center image.
/// Computes its own inner dimensions. [dimensions] is the outer border size only.
class LabelBubble extends StatelessWidget {
  final String title;
  final Offset position;
  final double dimensions;
  final MyHomePageState homePageState;

  LabelBubble(this.title, this.position, this.dimensions, this.homePageState);

  /// Returns the size of the inner bubble according to the probability returned by [getLabelProbabilities]
  /// TODO currently assumes that the label title is the same as the label name, just camel case.
  double _computeInnerBubbleSize() {
    double value = 0.0;
    Map<String, dynamic> probabilities = getLabelProbabilities(
        homePageState.userInputs, homePageState.modelConfig, true);
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
        homePageState.userInputs, homePageState.modelConfig, true);
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
invokeDialog(context, homePageState, feature, dragState) {
  return ([_]) async {
    var dialogInput = await asyncInputDialog(context, homePageState, feature);

    if (dialogInput != null) {
      dragState._computeNewColor();
      dragState._getParticles();
    }
  };
}
