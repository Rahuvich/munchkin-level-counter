import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';

class PlayerTile extends StatelessWidget {
  final Player player;
  final bool forceExpanded;
  PlayerTile({this.player, this.forceExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background:
          Container(color: context.theme().scaffoldBackgroundColor.darker(5)),
      onDismissed: (direction) =>
          context.read<GameCubit>().removePlayer(player.id),
      key: Key(player.id),
      child: ExpansionTile(
        initiallyExpanded: forceExpanded,
        maintainState: false,
        leading: FancyButton(
          color: context.theme().accentColor,
          size: 20,
          onPressed: () =>
              context.read<GameCubit>().toggleGenderOfPlayer(player.id),
          child: Icon(
            player.gender == Gender.MALE
                ? FontAwesomeIcons.mars
                : FontAwesomeIcons.venus,
            color: player.gender == Gender.MALE
                ? Colors.blueAccent
                : Colors.pinkAccent,
          ),
        ),
        title: Text(
          player.name,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child:
                    Text('Battle', style: context.theme().textTheme.headline5),
              ),
              size: 30,
              color: context.theme().accentColor,
              onPressed: () =>
                  context.read<GameCubit>().addGearToPlayer(player.id, -1),
            ),
            FancyButton(
              child: Icon(FontAwesomeIcons.skull),
              size: 30,
              color: context.theme().errorColor,
              onPressed: player.gear == 0
                  ? null
                  : () => context.read<GameCubit>().killPlayer(player.id),
            ),
          ],
        ),
      ),
      Text('Strength', style: context.theme().textTheme.headline4),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(player.strength.toString(),
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
                              style: context.theme().textTheme.headline5),
                        )),
                    FancyButton(
                      child: Icon(Icons.expand_less),
                      size: 20,
                      color: context.theme().accentColor,
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
                              style: context.theme().textTheme.headline5),
                        )),
                    FancyButton(
                      child: Icon(Icons.expand_less),
                      size: 20,
                      color: context.theme().accentColor,
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
