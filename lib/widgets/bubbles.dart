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
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final MapEntry<String, dynamic> feature;
  final Map<String, dynamic> modelConfig;

  DragBubble(this.initialOffset, this.homePageState, this.bubblePrototypeState,
      this.modelConfig, this.feature);

  @override
  State<StatefulWidget> createState() {
    return DragBubbleState(initialOffset, homePageState, bubblePrototypeState,
        modelConfig, feature);
  }
}

class DragBubbleState extends State<DragBubble>
    with SingleTickerProviderStateMixin {
  Offset offset;
  int colorIndex = 0;
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final Map<String, dynamic> modelConfig;
  final MapEntry<String, dynamic> feature;
  AnimationController animationController;
  Animation animation;

  DragBubbleState(this.offset, this.homePageState, this.bubblePrototypeState,
      this.modelConfig, this.feature);

  // TODO: also use computeColorByFactor method?
  computeNewColor() {
    int newColorIndex = 0;
    for (String label in modelConfig.keys) {
      if (modelConfig[label]['features'][feature.key] != null) {
        double factor = modelConfig[label]['features'][feature.key]['coef'] *
            homePageState.userInputs[feature.key];
        factor = factor < 0 ? 0 : factor;
        newColorIndex += factor.round().toInt();
      }
    }

    setState(() {
      colorIndex = newColorIndex;
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
        for (int i = 0; i < factor * 5; i++) {
          int timerDuration = ((rdm.nextInt(60) / 100 + 0.7) * 1000).toInt();
          particles.add(Particle(offset,
              bubblePrototypeState.labelBubbleOffsets[label], timerDuration, factor));
        }
      }
    }
    bubblePrototypeState.setState(() {
      //bubblePrototypeState.particles.forEach((Particle p) => p.state.dispose());
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
              onPanUpdate: (details) {
                setState(() {
                  offset = Offset(offset.dx + details.delta.dx,
                      offset.dy + details.delta.dy);
                });
              },
              onPanEnd: invokeDialog(context, homePageState, feature, this),
              child: Bubble(homePageState, this, feature.value["title"],
                  feature, colorIndex, animationController)),
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
  final int colorIndex;
  final animationController;

  Bubble(this.homePageState, this.dragState, this.title, this.feature,
      this.colorIndex, this.animationController);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      child: Column(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(seconds: 1),
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: computeColor(colorIndex),
            ),
            child: new FlatButton(
              onPressed:
                  invokeDialog(context, homePageState, feature, dragState),
              child: Container(),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}

class LabelBubble extends StatelessWidget {
  final String title;
  final Offset position;
  final MyHomePageState homePageState;

  LabelBubble(this.title, this.position, this.homePageState);

  double computeDimensions() {
    double value = 0.0;
    Map<String, dynamic> probs = getIllnessProbs(
        homePageState.userInputs, homePageState.modelConfig, true);
    probs.forEach(
        (k, v) => (k.toLowerCase() == title.toLowerCase()) ? value = v : null);
    return value;
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
    double dim = computeDimensions();
    return Positioned(
        top: position.dy,
        left: position.dx,
        child: Container(
          width: 105,
          height: 105,
          child: Column(
            children: <Widget>[
              Container(
                width: 84,
                height: 84,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                      color: computeColor(),
                      width: 2.0,
                      style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedContainer(
                      width: dim * 80,
                      height: dim * 80,
                      duration: Duration(seconds: 3),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: computeColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
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
  double correspondingFactor;
  State state;

  Particle(this.offset, this.targetOffset, this.timerDuration, this.correspondingFactor){
    offset = Offset(offset.dx+45, offset.dy+20);
    targetOffset = Offset(targetOffset.dx+50, targetOffset.dy+40);
  }

  @override
  State<StatefulWidget> createState() {
    state = ParticleState(offset, targetOffset, timerDuration, correspondingFactor);
    return state;
  }
}

class ParticleState extends State<Particle> {
  Offset offset;
  final Offset targetOffset;
  final int timerDuration;
  dynamic timeout;
  final ms = const Duration(milliseconds: 1);
  Timer timer;
  double correspondingFactor;

  startTimeout([int milliseconds]) {
    timeout = Duration(milliseconds: timerDuration);
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    timer = new Timer(duration, handleTimeout);
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

  ParticleState(this.offset, this.targetOffset, this.timerDuration, this.correspondingFactor);

  @override
  Widget build(BuildContext context) {
    startTimeout();
    return AnimatedPositioned(
      top: offset.dy,
      left: offset.dx,
      duration: Duration(seconds: 2),
      width: 5,
      height: 5,
      child: Container(
        width: 5,
        height: 5,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: computeColorByFactor(correspondingFactor),
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
