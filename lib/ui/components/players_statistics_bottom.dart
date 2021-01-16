import 'package:flutter/material.dart';
import 'package:munchkin/models/models.dart';

class PlayersStatisticsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: context.theme().scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // * Subtle actions
                ListTile(
                  enabled: false,
                  title: Text('Bounty Hunter'),
                  subtitle: Text(
                      'Have won the biggest amount of treasures from enemies'),
                  leading:
                      Text('Mabe', style: TextStyle(fontFamily: 'Quasimodo')),
                ),
                ListTile(
                  enabled: false,
                  title: Text('Natural Born Killer'),
                  subtitle: Text('has killed 4 monsters'),
                  leading: Text('', style: TextStyle(fontFamily: 'Quasimodo')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
