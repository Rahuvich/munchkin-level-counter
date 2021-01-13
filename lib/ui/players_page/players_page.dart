import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: PlayersView(),
    );
  }
}

class PlayersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text(
              'Players',
              style: context.theme().textTheme.headline3,
            ),
            BlocBuilder<GameCubit, GameplayState>(
              builder: (context, state) {
                return ListView(
                  shrinkWrap: true,
                  children: state.players
                      .map((player) => PlayerItem(player: player))
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class PlayerItem extends StatelessWidget {
  final Player player;
  PlayerItem({this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        player.male == Gender.MALE
            ? FontAwesomeIcons.mars
            : FontAwesomeIcons.venus,
        color:
            player.male == Gender.MALE ? Colors.blueAccent : Colors.pinkAccent,
      ),
      title: Text(
        player.name,
        style: context.theme().textTheme.bodyText1,
      ),
      subtitle: Text(
          'Level ${player.level} – Gear ${player.gear} – Strength ${player.strength}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FancyButton(
            color: context.theme().accentColor,
            child: Icon(Icons.expand_less),
            size: 20,
            onPressed: () => context.read<GameCubit>().levelUpPlayer(player.id),
          )
        ],
      ),
    );
  }
}
