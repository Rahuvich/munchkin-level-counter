import 'package:flutter/material.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/game_heroes/game_hero_tiles.dart';

class PlayersGameHeroesBottom extends StatelessWidget {
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
            child: ListView(
              shrinkWrap: true,
              children: [
                BountyHunterTile(),
                NaturalBornKillerTile(),
                LonelyBoyTile(),
                StrongestTile(),
                FeederTile()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
