import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/ui/components/bloc_listener.dart';
import 'package:munchkin/ui/icons/munchkin_icons.dart';
import 'package:munchkin/ui/screens/battle_page.dart';
import 'package:munchkin/ui/screens/players_page.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/screens/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int dice = 1;
  List<Widget> screens;
  int currentPage = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentPage, keepPage: true);

    screens = [
      PlayersPage(
        onBattle: (Player player) {
          context.read<BattleCubit>().initializeBattleWithPlayer(player);
          _pageController.animateToPage(1,
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        },
      ),
      BattlePage(
        onBack: () => _pageController.animateToPage(0,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut),
      ),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocsListener(
        child: PageView(
          children: screens,
          onPageChanged: (index) => setState(() {
            FocusScope.of(context).unfocus();
            currentPage = index;
          }),
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Munchkin.munchkin_dice,
          /* diceIcon, */
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: context.theme().accentColor,
        onPressed: throwDice,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: context.theme().bottomAppBarColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 7.0,
        child: Container(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(CupertinoIcons.person_2_fill),
                  color: currentPage == 0
                      ? Colors.white
                      : context.theme().disabledColor,
                  onPressed: () => _pageController.jumpToPage(
                        0,
                      )),
              IconButton(
                  icon: Icon(
                    CupertinoIcons.settings,
                  ),
                  color: currentPage == 2
                      ? Colors.white
                      : context.theme().disabledColor,
                  onPressed: () => _pageController.jumpToPage(2)),
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
