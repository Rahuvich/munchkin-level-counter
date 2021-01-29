import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MagicDiceIcon extends ImplicitlyAnimatedWidget {
  final int number;
  MagicDiceIcon({
    this.number,
  });

  @override
  _MagicDiceIconState createState() => _MagicDiceIconState();
}

class _MagicDiceIconState extends AnimatedWidgetBaseState<MagicDiceIcon> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void forEachTween(visitor) {}

  IconData get diceIcon {
    if (widget.number == 1)
      return FontAwesomeIcons.diceOne;
    else if (widget.number == 2)
      return FontAwesomeIcons.diceTwo;
    else if (widget.number == 3)
      return FontAwesomeIcons.diceThree;
    else if (widget.number == 4)
      return FontAwesomeIcons.diceFour;
    else if (widget.number == 5)
      return FontAwesomeIcons.diceFive;
    else
      return FontAwesomeIcons.diceSix;
  }
}
