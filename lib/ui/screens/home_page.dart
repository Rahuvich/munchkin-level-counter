import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/ui/screens/players_page.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/screens/settings_page.dart';

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
          size: 30,
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
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.person_2_fill),
                color: currentTab == 0
                    ? Colors.white
                    : context.theme().disabledColor,
                onPressed: () => setState(() {
                  currentTab = 0;
                }),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.slider_horizontal_3,
                ),
                color: currentTab == 1
                    ? Colors.white
                    : context.theme().disabledColor,
                onPressed: () => setState(() {
                  currentTab = 1;
                }),
              ),
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
    else
      return FontAwesomeIcons.diceSix;
  }

  void throwDice() {
    HapticFeedback.heavyImpact();
    setState(() {
      dice = new Random().nextInt(6) + 1;
    });
  }
}