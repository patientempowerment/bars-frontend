import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'charts/simple_bar_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Empowerment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Patient Empowerment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _sliderValue = 0.0;

  final mockedData = [
    QuarterSales('Q1', 5000),
    QuarterSales('Q2', 25000),
    QuarterSales('Q3', 100000),
    QuarterSales('Q4', 75000),
  ];

  List<charts.Series<QuarterSales, String>> mapChartData(
      List<QuarterSales> data) {
    return [
      charts.Series<QuarterSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (QuarterSales sales, _) => sales.quarter,
        measureFn: (QuarterSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container (
        padding: EdgeInsets.all(40.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("Smoking Behavior"),
                      Slider(
                          value: _sliderValue,
                          onChanged: (double newValue) {
                            setState(() {
                              _sliderValue = newValue;
                            });
                          },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Smoking Behavior"),
                      Slider(
                        value: _sliderValue,
                        onChanged: (double newValue) {
                          setState(() {
                            _sliderValue = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  child:  SimpleBarChart(mapChartData(mockedData)),
                )
            ),
          ],
        ),
      ),
    );
  }
}
