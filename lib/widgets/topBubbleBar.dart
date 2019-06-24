import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';

Widget getTopBubbleBar() {
  return Expanded(
    child: Column(
      children: <Widget>[
        DragBubble(Offset.zero),
      ],
    ),
  );
}

class Bubble extends StatelessWidget {
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
          ),
          Padding(padding: EdgeInsets.only(top: 5.0), child: Text("Test")),
        ],
      ),
    );
  }
}

class DragBubble extends StatefulWidget {
  final Offset initialOffset;

  DragBubble(this.initialOffset);

  @override
  State<StatefulWidget> createState() {
    return _DragBubbleState(initialOffset);
  }
}

class _DragBubbleState extends State<DragBubble> {
  Offset offset = Offset.zero;

  _DragBubbleState(this.offset);

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
                  offset = Offset(
                      offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                });
              },
              child: Bubble(),
            ),
          ),
        ],
      ),
    );
  }
}
