import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munchkin/components/button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  void _incrementCounter() {
    HapticFeedback.lightImpact();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('MUNCHKIN',
                style: TextStyle(fontFamily: 'Quasimodo', fontSize: 60)),
            Text('$_counter',
                style: TextStyle(fontFamily: 'Quasimodo', fontSize: 60)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FancyButton(
                child: Text('Tap to start',
                    style: TextStyle(fontFamily: 'Quasimodo', fontSize: 24)),
                color: Colors.green,
                size: 50,
                onPressed: _incrementCounter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
