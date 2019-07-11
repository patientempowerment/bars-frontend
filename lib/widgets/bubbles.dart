import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/utils.dart';
import 'package:bars_frontend/predictions.dart';
import 'topBubbleBar.dart';

class DragBubble extends StatefulWidget {
  final Offset initialOffset;
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final Function dialogFunction;
  final String feature;
  final String title;
  final MapWrapper featureFactors;

  DragBubble(this.initialOffset, this.homePageState, this.bubblePrototypeState,
      this.featureFactors, this.feature, this.title, this.dialogFunction);

  @override
  State<StatefulWidget> createState() {
    return DragBubbleState(initialOffset, homePageState, bubblePrototypeState,
        featureFactors, feature, title, dialogFunction);
  }
}

class DragBubbleState extends State<DragBubble>
    with SingleTickerProviderStateMixin {
  Offset offset;
  final List<Color> colorGradient = [
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.red
  ];
  int colorIndex = 0;
  final MyHomePageState homePageState;
  final BubblePrototypeState bubblePrototypeState;
  final MapWrapper featureFactors;
  final Function dialogFunction;
  final String title;
  final String feature;
  AnimationController animationController;
  Animation animation;

  DragBubbleState(this.offset, this.homePageState, this.bubblePrototypeState,
      this.featureFactors, this.feature, this.title, this.dialogFunction);

  computeNewColor(double input) {
    int newColorIndex = 0;
    for (var label in models.entries) {
      if (featureFactors.value[feature] != null) {
        double factor = featureFactors.value[feature][label.key] * input;
        factor = factor < 0 ? 0 : factor;
        newColorIndex += factor.round().toInt();
      }
    }
    newColorIndex = newColorIndex >= colorGradient.length
        ? colorGradient.length - 1
        : newColorIndex;
    setState(() {
      colorIndex = newColorIndex;
    });
  }

  getParticles() {
    List<Widget> particleList = List();
    for (int i = 0; i < colorIndex; i++) {
      particleList.add(Particle(offset, animation));
    }
    bubblePrototypeState.setState(() {
      bubblePrototypeState.particleList[this] = particleList;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0, end: 60).animate(animationController)
      ..addListener(() {
        setState(() {});
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
              onPanEnd: (_) async {
                double input =
                    (await dialogFunction(context, homePageState)).get();
                computeNewColor(input);
                getParticles();
              },
              child: Bubble(homePageState, this, title, dialogFunction,
                  colorGradient, colorIndex, animationController)),
        ),
      ],
    );
  }
}

class Bubble extends StatelessWidget {
  final MyHomePageState homePageState;
  final DragBubbleState dragState;
  final Function dialogFunction;
  final String title;
  final colorGradient;
  final int colorIndex;
  final animationController;

  Bubble(this.homePageState, this.dragState, this.title, this.dialogFunction,
      this.colorGradient, this.colorIndex, this.animationController);

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
              color: colorGradient[colorIndex],
            ),
            child: new FlatButton(
              onPressed: () async {
                var dialogInput = await dialogFunction(context, homePageState);
                if (dialogInput != null) {
                  double inputValue = dialogInput.get();
                  dragState.computeNewColor(inputValue);
                  animationController.forward();
                }
              },
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
    List<IllnessProb> probs =
        getIllnessProbs(homePageState.input, homePageState.models, true);
    for (IllnessProb prob in probs) {
      if (prob.illness == title) {
        return prob.probability;
      }
    }
    return 0.0; //this should never happen
  }

  Color computeColor() {
    final List<Color> colorGradient = [
      Colors.lightGreen,
      Colors.amber,
      Colors.orange,
      Colors.red
    ];
    List<IllnessProb> probs =
        getIllnessProbs(homePageState.input, homePageState.models, true);
    for (IllnessProb prob in probs) {
      if (prob.illness == title) {
        return colorGradient[
            (prob.probability * (colorGradient.length - 1)).round().toInt()];
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

class Particle extends StatelessWidget {
  final dynamic animation;
  final Offset offset;

  Particle(this.offset, this.animation);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: offset.dy,
      left: offset.dx,
      duration: Duration(seconds: 1),
      width: 5,
      height: 5,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
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
