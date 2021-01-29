import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/icons/munchkin_icons.dart';

class MagicDiceButton extends StatefulWidget {
  const MagicDiceButton({
    Key key,
  }) : super(key: key);
  @override
  _MagicDiceButtonState createState() => _MagicDiceButtonState();
}

class _MagicDiceButtonState extends State<MagicDiceButton> {
  int number = 1;
  bool isLoading = false;

  double initIconSize = 35.0;
  double sizeIcon;

  @override
  void initState() {
    super.initState();
    sizeIcon = initIconSize;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: !isLoading
          ? context.theme().accentColor
          : context.theme().accentColor.darker(15),
      child: MyAnimatedIcon(
        diceIcon,
        color: Colors.white,
        duration: Duration(milliseconds: 150),
        curve: Curves.bounceInOut,
        size: sizeIcon,
      ),
      onPressed: throwDice,
    );
  }

  void throwDice() async {
    HapticFeedback.heavyImpact();
    setState(() {
      isLoading = true;
      number = new Random().nextInt(6) + 1;
      sizeIcon = initIconSize / 1.3;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
      sizeIcon = initIconSize;
    });
  }

  IconData get diceIcon {
    if (isLoading)
      return Munchkin.munchkin_dice;
    else if (number == 1)
      return FontAwesomeIcons.diceOne;
    else if (number == 2)
      return FontAwesomeIcons.diceTwo;
    else if (number == 3)
      return FontAwesomeIcons.diceThree;
    else if (number == 4)
      return FontAwesomeIcons.diceFour;
    else if (number == 5)
      return FontAwesomeIcons.diceFive;
    else
      return FontAwesomeIcons.diceSix;
  }
}

class MyAnimatedIcon extends ImplicitlyAnimatedWidget {
  final IconData icon;
  final double size;
  final Color color;

  MyAnimatedIcon(this.icon,
      {@required this.size,
      @required this.color,
      @required Duration duration,
      @required Curve curve})
      : super(duration: duration, curve: curve);

  @override
  _MyAnimatedIconState createState() => _MyAnimatedIconState();
}

class _MyAnimatedIconState extends AnimatedWidgetBaseState<MyAnimatedIcon> {
  Tween<double> sizeTween;
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      color: widget.color,
      size: sizeTween.evaluate(animation),
    );
  }

  @override
  void forEachTween(visitor) {
    sizeTween =
        visitor(sizeTween, widget.size, (size) => Tween<double>(begin: size));
  }
}
