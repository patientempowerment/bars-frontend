import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'package:bars_frontend/predictions.dart';

class DragBubble extends StatefulWidget {
  final Offset initialOffset;
  final MyHomePageState homePageState;
  final Function dialogFunction;
  final String feature;
  final String title;
  final Map<String, dynamic> modelConfig;

  DragBubble(this.initialOffset, this.homePageState, this.modelConfig,
      this.feature, this.title, this.dialogFunction);

  @override
  State<StatefulWidget> createState() {
    return _DragBubbleState(initialOffset, homePageState, modelConfig,
        feature, title, dialogFunction);
  }
}

class _DragBubbleState extends State<DragBubble> {
  Offset offset;
  int colorIndex = 0;
  final MyHomePageState homePageState;
  final Map<String, dynamic> modelConfig;
  final Function dialogFunction;
  final String title;
  final String feature;

  _DragBubbleState(this.offset, this.homePageState, this.modelConfig,
      this.feature, this.title, this.dialogFunction);

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
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
            onPanEnd: (_) async {
              await dialogFunction(context, homePageState);

              modelConfig.forEach((k,v) {
                v["features"].forEach((k2, v2) {
                  if (v2["coef"] > 0.1) {
                    colorIndex++;
                  }
                });
              });
            },
            child: Bubble(homePageState, title, dialogFunction, colorIndex),
          ),
        ),
      ],
    );
  }
}

class Bubble extends StatelessWidget {
  final MyHomePageState homePageState;
  final Function dialogFunction;
  final String title;
  List<Color> colorGradient = [Colors.lightGreen, Colors.amber, Colors.orange, Colors.red];
  final int colorIndex;

  Bubble(this.homePageState, this.title, this.dialogFunction, this.colorIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      child: Column(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: colorGradient[colorIndex],
            ),
            child: new FlatButton(
              onPressed: () async {
                final dynamic r = await dialogFunction(context, homePageState);
                print("Current value is $r");
              },
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
    Map<String, dynamic> probs =
    getIllnessProbs(homePageState.userInputs, homePageState.modelConfig, true);
    probs.forEach((k,v) => (k == title) ? value = v :null);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    double dim = computeDimensions();
    return Positioned(
        top: position.dy,
        left: position.dx,
        child: Container(
          width: 101,
          height: 101,
          child: Column(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: dim * 80,
                      height: dim * 80,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
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
