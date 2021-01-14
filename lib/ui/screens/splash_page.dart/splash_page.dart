import 'package:flutter/material.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/models/models.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                Text('MUNCHKIN',
                    style: TextStyle(fontFamily: 'Quasimodo', fontSize: 60)),
                Text('Level Counter',
                    style: TextStyle(fontFamily: 'Quasimodo', fontSize: 30)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FancyButton(
                child: Text('Tap to start',
                    style: TextStyle(fontFamily: 'Quasimodo', fontSize: 24)),
                color: context.theme().accentColor,
                size: 50,
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
