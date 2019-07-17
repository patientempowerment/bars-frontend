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
  computeNewColor(double input) {
    int newColorIndex = 0;
    for (String label in modelConfig.keys) {
      if (modelConfig[label]['features'][feature] != null) {
        double factor = modelConfig[label]['features'][feature]['coef'] * input;
        factor = factor < 0 ? 0 : factor;
        newColorIndex += factor.round().toInt();
      }
    }

    setState(() {
      colorIndex = newColorIndex;
    });
  }

  getParticles(double input) {
    List<Widget> particleList = List();
    dynamic rdm = Random();
    for (String label in modelConfig.keys) {
      if (modelConfig[label]['features'][feature] != null) {
        double factor = modelConfig[label]['features'][feature]['coef'] * input;
        factor = factor < 0 ? 0 : factor;
        for (int i = 0; i < factor * 50; i++) {
          int timerDuration = ((rdm.nextInt(60) / 100 + 0.7) * 1000).toInt();
          particleList.add(Particle(offset,
              bubblePrototypeState.diseaseBubbleOffsets[label], timerDuration));
        }
      }
    }

    bubblePrototypeState.setState(() {
      bubblePrototypeState.particleList[this] = particleList;
    });
  }

  @override
  Widget build(BuildContext context) {
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

class DiseaseBubble extends StatelessWidget {
  final String title;
  final Offset position;
  final MyHomePageState homePageState;

  DiseaseBubble(this.title, this.position, this.homePageState);

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
                    Container(
                      width: dim * 80,
                      height: dim * 80,
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
  final Offset targetOffset;
  final timerDuration;

  Particle(this.offset, this.targetOffset, this.timerDuration);

  @override
  State<StatefulWidget> createState() {
    return ParticleState(offset, targetOffset, timerDuration);
  }
}

class ParticleState extends State<Particle> {
  Offset offset;
  final Offset targetOffset;
  final int timerDuration;
  dynamic timeout;
  final ms = const Duration(milliseconds: 1);
  Timer timer;

  startTimeout([int milliseconds]) {
    timeout = Duration(milliseconds: timerDuration);
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    timer = new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    if (timer != null) {
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

  ParticleState(this.offset, this.targetOffset, this.timerDuration);

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
          color: Colors.black,
        ),
      ),
    );
  }
}

invokeDialog(context, homePageState, feature, dragState) {
  return ([_]) async {
    var dialogInput = await asyncInputDialog(context, homePageState, feature);

    if (dialogInput != null) {
      double inputValue = dialogInput.toDouble();
      dragState.computeNewColor(inputValue);
      dragState.getParticles(inputValue);
    }
  };
}
