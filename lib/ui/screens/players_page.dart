import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/new_player.dart';
import 'package:munchkin/ui/components/player_tile.dart';
import 'package:munchkin/ui/components/players_settings_bottom.dart';
import 'package:munchkin/ui/components/players_statistics_bottom.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players =
        context.select<GameCubit, List<Player>>((cubit) => cubit.state.players);
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
              icon: Icon(Icons.bar_chart_rounded),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PlayersStatisticsBottom(),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.tune_rounded),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PlayersSettingsBottomSheet(),
                );
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: NewPlayerInput(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(players
              .map((player) => PlayerTile(
                    player: player,
                  ))
              .toList()),
        ),
      ],
    );
  }
}