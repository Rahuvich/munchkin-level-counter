import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/ui/screens/players_page/players_page.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/screens/settings_page/settings_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentTab = 0;
  int dice = 1;
  final List<Widget> screens = [
    PlayersPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentTab],
      floatingActionButton: FloatingActionButton(
        child: Icon(
          diceIcon,
          color: Colors.white,
        ),
        backgroundColor: context.theme().accentColor,
        onPressed: throwDice,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: context.theme().appBarTheme.color,
        shape: CircularNotchedRectangle(),
        notchMargin: 7.0,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.people),
                onPressed: () => setState(() {
                  currentTab = 0;
                }),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => setState(() {
                  currentTab = 1;
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData get diceIcon {
    if (dice == 1)
      return FontAwesomeIcons.diceOne;
    else if (dice == 2)
      return FontAwesomeIcons.diceTwo;
    else if (dice == 3)
      return FontAwesomeIcons.diceThree;
    else if (dice == 4)
      return FontAwesomeIcons.diceFour;
    else if (dice == 5)
      return FontAwesomeIcons.diceFive;
    else if (dice == 6) return FontAwesomeIcons.diceSix;
  }

  void throwDice() => setState(() {
        dice = new Random().nextInt(6) + 1;
      });
}
