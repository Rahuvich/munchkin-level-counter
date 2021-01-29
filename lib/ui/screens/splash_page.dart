import 'package:flutter/material.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/models/models.dart';
import 'dart:math' as math;

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/img/munchkin_pattern.png',
            scale: 1.5,
            repeat: ImageRepeat.repeat,
            height: double.infinity,
            width: double.infinity),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Text('MUNCHKIN',
                        style:
                            TextStyle(fontFamily: 'Quasimodo', fontSize: 60)),
                    Text('Level Counter',
                        style:
                            TextStyle(fontFamily: 'Quasimodo', fontSize: 30)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FancyButton(
                    child: Text('Tap to start',
                        style:
                            TextStyle(fontFamily: 'Quasimodo', fontSize: 24)),
                    color: context.theme().accentColor,
                    size: 50,
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
