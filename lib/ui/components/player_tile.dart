import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:munchkin/ui/components/snackbar_redo.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

class PlayerTile extends StatelessWidget {
  final Player player;
  final bool forceExpanded;
  final Function(Player) onBattle;
  PlayerTile(
      {@required this.player,
      @required this.onBattle,
      this.forceExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background:
          Container(color: context.theme().scaffoldBackgroundColor.darker(5)),
      onDismissed: (direction) =>
          context.read<GameCubit>().removePlayer(player.id),
      key: Key(player.id),
      child: ExpansionTile(
        key: Key(PlayersPagePlayerTileExpansionTile),
        initiallyExpanded: forceExpanded,
        maintainState: false,
        leading: FancyButton(
          key: Key(PlayersPagePlayerTileGenderButton),
          color: context.theme().accentColor,
          size: 20,
          onPressed: () =>
              context.read<GameCubit>().toggleGenderOfPlayer(player.id),
          child: Icon(
            player.gender == Gender.MALE
                ? FontAwesomeIcons.mars
                : FontAwesomeIcons.venus,
            key: Key(PlayersPagePlayerTileGender),
            color: player.gender == Gender.MALE
                ? Colors.blueAccent
                : Colors.pinkAccent,
          ),
        ),
        title: Text(
          player.name,
          key: Key(PlayersPagePlayerTileName),
          style: context.theme().textTheme.bodyText1,
        ),
        subtitle: Text('Level ${player.level} – Strength ${player.strength}'),
        children: _children(context),
      ),
    );
  }

  List<Widget> _children(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FancyButton(
              key: Key(PlayersPagePlayerTileBattleButton),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child:
                    Text('Battle', style: context.theme().textTheme.bodyText1),
              ),
              size: 30,
              color: context.theme().accentColor,
              onPressed: () => onBattle.call(player),
            ),
            FancyButton(
              key: Key(PlayersPagePlayerTileDieButton),
              child: Icon(FontAwesomeIcons.skull),
              size: 30,
              color: context.theme().errorColor,
              onPressed: player.gear == 0
                  ? null
                  : () {
                      context.read<GameCubit>().killPlayer(player.id);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        content: RedoSnackbar(
                            title: '${player.name} has died',
                            color: Colors.white,
                            onAction: context.read<GameCubit>().undo),
                      ));
                    },
            ),
          ],
        ),
      ),
      Text('Strength', style: context.theme().textTheme.headline4),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(player.strength.toString(),
            key: Key(PlayersPagePlayerTileStrength),
            style: context.theme().textTheme.headline3),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text('Level', style: context.theme().textTheme.headline6),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    FancyButton(
                      key: Key(PlayersPagePlayerTileLevelDownButton),
                      child: Icon(Icons.expand_more),
                      size: 20,
                      color: context.theme().accentColor,
                      onPressed: player.level == 1
                          ? null
                          : () => context
                              .read<GameCubit>()
                              .addLevelToPlayer(player.id, -1),
                    ),
                    SizedBox(
                        width: 60,
                        height: 20,
                        child: FittedBox(
                          child: Text(player.level.toString(),
                              key: Key(PlayersPagePlayerTileLevel),
                              style: context.theme().textTheme.headline5),
                        )),
                    FancyButton(
                      child: Icon(Icons.expand_less),
                      size: 20,
                      color: context.theme().accentColor,
                      key: Key(PlayersPagePlayerTileLevelUpButton),
                      onPressed: () => context
                          .read<GameCubit>()
                          .addLevelToPlayer(player.id, 1),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Text('Gear', style: context.theme().textTheme.headline6),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    FancyButton(
                      child: Icon(Icons.expand_more),
                      size: 20,
                      color: context.theme().accentColor,
                      key: Key(PlayersPagePlayerTileGearDownButton),
                      onPressed: player.gear == 0
                          ? null
                          : () => context
                              .read<GameCubit>()
                              .addGearToPlayer(player.id, -1),
                    ),
                    SizedBox(
                        width: 60,
                        height: 20,
                        child: FittedBox(
                          child: Text(player.gear.toString(),
                              key: Key(PlayersPagePlayerTileGear),
                              style: context.theme().textTheme.headline5),
                        )),
                    FancyButton(
                      child: Icon(Icons.expand_less),
                      size: 20,
                      color: context.theme().accentColor,
                      key: Key(PlayersPagePlayerTileGearUpButton),
                      onPressed: () => context
                          .read<GameCubit>()
                          .addGearToPlayer(player.id, 1),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ];
  }
}
