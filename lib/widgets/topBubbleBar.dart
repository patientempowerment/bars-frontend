import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'dialogs.dart';

Widget getTopBubbleBar(MyHomePageState homePageState) {
  return Expanded(
    child: Column(
      children: <Widget>[
        DragBubble(Offset.zero, homePageState, "Sex", asyncSexInputDialog),
        DragBubble(Offset.zero, homePageState, "Sex2", asyncSexInputDialog),
      ],
    ),
  );
}

class DragBubble extends StatefulWidget {
  final Offset initialOffset;
  final MyHomePageState homePageState;
  final Function dialogFunction;
  final String title;

  DragBubble(this.initialOffset, this.homePageState, this.title, this.dialogFunction);

  @override
  State<StatefulWidget> createState() {
    return _DragBubbleState(initialOffset, homePageState, title, dialogFunction);
  }
}

class _DragBubbleState extends State<DragBubble> {
  Offset offset;
  final MyHomePageState homePageState;
  final Function dialogFunction;
  final String title;

  _DragBubbleState(this.offset, this.homePageState, this.title, this.dialogFunction);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
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
              child: Bubble(homePageState, title, dialogFunction),
            ),
          ),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final MyHomePageState homePageState;
  final Function dialogFunction;
  final String title;

  Bubble(this.homePageState, this.title, this.dialogFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      child: Column(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightGreen,
            ),
            child: new FlatButton(
              onPressed: () async {
                final dynamic r = await dialogFunction(context, homePageState);
                print("Current value is $r");
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0), child: Text("Test")),
        ],
      ),
    );
  }
}

