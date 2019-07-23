import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'package:bars_frontend/predictions.dart';
import 'topBubbleBar.dart';
import 'dialogs.dart';

class DragBubble extends StatefulWidget {
  final Offset initialOffset;
  final double bubbleWidth;
  final double labelBubbleWidth;
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final MapEntry<String, dynamic> feature;
  final Map<String, dynamic> modelConfig;

  DragBubble(
      this.initialOffset,
      this.bubbleWidth,
      this.labelBubbleWidth,
      this.homePageState,
      this.bubblePrototypeState,
      this.modelConfig,
      this.feature);

  @override
  State<StatefulWidget> createState() {
    return DragBubbleState(initialOffset, bubbleWidth, labelBubbleWidth,
        homePageState, bubblePrototypeState, modelConfig, feature);
  }
}

class DragBubbleState extends State<DragBubble>
    with SingleTickerProviderStateMixin {
  Offset offset;
  Color color = Colors.black;
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final Map<String, dynamic> modelConfig;
  final MapEntry<String, dynamic> feature;
  AnimationController animationController;
  Animation animation;
  double bubbleWidth;
  double labelBubbleWidth;
  bool isSmall;

  DragBubbleState(
      this.offset,
      this.bubbleWidth,
      this.labelBubbleWidth,
      this.homePageState,
      this.bubblePrototypeState,
      this.modelConfig,
      this.feature);

  @override
  initState() {
    isSmall = true;
    super.initState();
  }

  computeNewColor() {
    double colorFactor = 0;
    for (String label in modelConfig.keys) {
      if (modelConfig[label]['features'][feature.key] != null) {
        double factor = modelConfig[label]['features'][feature.key]['coef'] *
            homePageState.userInputs[feature.key];
        colorFactor += factor < 0 ? 0 : factor;
      }
    }
    // normalize colorFactor
    colorFactor = colorFactor / modelConfig.keys.length;
    setState(() {
      color = computeColorByFactor(colorFactor);
    });
  }

  getParticles() {
    List<Particle> particles = List();
    dynamic rdm = Random();
    for (String label in modelConfig.keys) {
      if (modelConfig[label]['features'][feature.key] != null) {
        double factor = modelConfig[label]['features'][feature.key]['coef'] *
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
          Offset center =
              Offset(offset.dx + bubbleWidth / 2, offset.dy + bubbleWidth / 2);
          particles.add(
              Particle(center, labelBubbleCenter, timerDuration, color));
        }
      }
    }
    bubblePrototypeState.setState(() {
      bubblePrototypeState.particles = particles;
    });
  }

  @override
  Widget build(BuildContext context) {
    computeNewColor();
    return Stack(
      children: <Widget>[
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  bubbleWidth = STANDARD_FEATURE_BUBBLE_SIZE;
                  isSmall = false;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  offset = Offset(offset.dx + details.delta.dx,
                      offset.dy + details.delta.dy);
                });
              },
              onPanEnd: invokeDialog(context, homePageState, feature, this),
              child: Bubble(
                  homePageState,
                  this,
                  feature.value["title"],
                  feature,
                  color,
                  animationController,
                  bubbleWidth,
                  isSmall)),
        ),
      ],
    );
  }
}

class Bubble extends StatelessWidget {
  final MyHomePageState homePageState;
  final DragBubbleState dragState;
  final String title;
  final MapEntry<String, dynamic> feature;
  final Color color;
  final animationController;
  final double bubbleWidth;
  final bool isSmall;

  Bubble(
      this.homePageState,
      this.dragState,
      this.title,
      this.feature,
      this.color,
      this.animationController,
      this.bubbleWidth,
      this.isSmall);

  composeBubble(context) {
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
            title,
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
        children: composeBubble(context),
      ),
    );
  }
}

class LabelBubble extends StatelessWidget {
  final String title;
  final Offset position;
  final double dimensions;
  final MyHomePageState homePageState;

  LabelBubble(this.title, this.position, this.dimensions, this.homePageState);

  double computeInnerBubbleSize() {
    double value = 0.0;
    Map<String, dynamic> probabilities = getIllnessProbs(
        homePageState.userInputs, homePageState.modelConfig, true);
    probabilities.forEach(
        (k, v) => (k.toLowerCase() == title.toLowerCase()) ? value = v : null);
    double innerBubbleSize = value * dimensions;
    return innerBubbleSize > dimensions - LABEL_BUBBLE_BORDER_SIZE * 2
        ? dimensions - LABEL_BUBBLE_BORDER_SIZE * 2
        : innerBubbleSize;
  }

  Color computeColor() {
    Map<String, dynamic> probs = getIllnessProbs(
        homePageState.userInputs, homePageState.modelConfig, true);
    for (var prob in probs.entries) {
      if (prob.key.toLowerCase() == title.toLowerCase()) {
        return computeColorByFactor(prob.value);
      }
    }
    return Colors.black; // this should never happen
  }

  @override
  Widget build(BuildContext context) {
    double innerBubbleSize = computeInnerBubbleSize();
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
                      color: computeColor(),
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
                        color: computeColor(),
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

class Particle extends StatefulWidget {
  Offset offset;
  Offset targetOffset;
  final timerDuration;
  Color color;
  State state;

  Particle(this.offset, this.targetOffset, this.timerDuration, this.color);

  @override
  State<StatefulWidget> createState() {
    state = ParticleState(offset, targetOffset, timerDuration, color);
    return state;
  }
}

class ParticleState extends State<Particle> {
  Offset offset;
  final Offset targetOffset;
  final int timerDuration;
  dynamic timeout;
  Timer timer;
  Color color;

  startTimeout() {
    timer = new Timer(Duration(milliseconds: timerDuration), handleTimeout);
  }

  void handleTimeout() {
    if (timer != null && offset != targetOffset) {
      setState(() {
        offset = targetOffset;
      });
    }
  }

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

invokeDialog(context, homePageState, feature, dragState) {
  return ([_]) async {
    var dialogInput = await asyncInputDialog(context, homePageState, feature);

    if (dialogInput != null) {
      dragState.computeNewColor();
      dragState.getParticles();
    }
  };
}
