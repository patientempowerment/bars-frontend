import 'package:flutter/material.dart';

enum SmokingBehavior { never, previous, current }

SmokingBehavior _smokingBehavior;

Widget getRadioButtons(context) {
  return (
      Row(
        children: [
          Text("Smoking Behavior"),
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: SmokingBehavior.never,
                        groupValue: _smokingBehavior,
                        onChanged: (SmokingBehavior newValue) {
                          context.setState(() {
                            _smokingBehavior = newValue;
                          });
                        },
                      ),
                    ),
                    Text("never")
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: SmokingBehavior.previous,
                        groupValue: _smokingBehavior,
                        onChanged: (SmokingBehavior newValue) {
                          context.setState(() {
                            _smokingBehavior = newValue;
                          });
                        },
                      ),
                    ),
                    Text("previously"),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Radio(
                        value: SmokingBehavior.current,
                        groupValue: _smokingBehavior,
                        onChanged: (SmokingBehavior newValue) {
                          context.setState(() {
                            _smokingBehavior = newValue;
                          });
                        },
                      ),
                    ),
                    Text("current")
                  ],
                ),
              ),
            ],
          ),
        ],
      )
  );
}