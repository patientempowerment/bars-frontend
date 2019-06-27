import 'package:flutter/material.dart';
import 'package:bars_frontend/main.dart';
import 'dialogs.dart';
import 'sliders.dart';
import 'radioButtons.dart';
import 'package:bars_frontend/utils.dart';

Widget getTopBubbleBar(MyHomePageState homePageState) {
  return Expanded(
    child: Column(
      children: <Widget>[
        DragBubble(Offset.zero, homePageState),
      ],
    ),
  );
}

class DragBubble extends StatefulWidget {
  final Offset initialOffset;
  final MyHomePageState homePageState;

  DragBubble(this.initialOffset, this.homePageState);

  @override
  State<StatefulWidget> createState() {
    return _DragBubbleState(initialOffset, homePageState);
  }
}

class _DragBubbleState extends State<DragBubble> {
  Offset offset;
  MyHomePageState homePageState;

  _DragBubbleState(this.offset, this.homePageState);

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
              child: Bubble(homePageState),
            ),
          ),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final MyHomePageState homePageState;

  Bubble(this.homePageState);

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
                final dynamic r =
                    await _asyncSexInputDialog(context, homePageState, "sex");
                print("Current team name is $r");
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0), child: Text("Test")),
        ],
      ),
    );
  }
}

Future<dynamic> _asyncSexInputDialog(BuildContext context,
    MyHomePageState homePageState, String inputVariable) async {
  //Widget widget = getSexRadioButtons(homePageState);

  return _asyncInputDialog(context, homePageState, inputVariable, null);
}

Future<dynamic> _asyncInputDialog(
    BuildContext context,
    MyHomePageState homePageState,
    String inputVariable,
    Widget childWidget) async {
  return showDialog<dynamic>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          content: MyDialogContent(homePageState),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(homePageState.input.getVariable(inputVariable).value);
              },
              child: new Text('Ok'),
            )
          ]);
    },
  );
}
