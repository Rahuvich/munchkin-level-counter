import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/ui/components/new_player.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players = context.select<GameCubit, List<Player>>(
        (GameCubit bloc) => bloc.state.players);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.theme().scaffoldBackgroundColor,
          title: Text(
            'Players',
            style: context.theme().textTheme.headline3,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shuffle),
              onPressed: () => context.read<GameCubit>().shufflePlayers(),
            ),
            IconButton(
              icon: Icon(Icons.replay),
              onPressed: () => context.read<GameCubit>().resetPlayers(),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: NewPlayerInput(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
              players.map((player) => PlayerItem(player: player)).toList()),
        ),
      ],
    );
  }
}

class PlayerItem extends StatelessWidget {
  final Player player;
  PlayerItem({this.player});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background:
          Container(color: context.theme().scaffoldBackgroundColor.darker(5)),
      onDismissed: (direction) =>
          context.read<GameCubit>().removePlayer(player.id),
      key: Key(player.id),
      child: ListTile(
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
      ),
    );
  }
}
