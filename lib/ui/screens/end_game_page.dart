import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/ui/components/game_heroes/game_hero_tiles.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

class EndGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameCubit gameCubit = context.watch<GameCubit>();

    Player winnerPlayer = gameCubit.state.players
        .reduce((p1, p2) => p1.level > p2.level ? p1 : p2);

    List<Player> players = List.from(gameCubit.state.players);
    players.sort((b, a) {
      if (a.strength.compareTo(b.strength) != 0) {
        return a.strength.compareTo(b.strength);
      }

      if (a.level.compareTo(b.level) != 0) {
        return a.level.compareTo(b.level);
      }

      return a.gear.compareTo(b.gear);
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.undo,
                ),
                onPressed: () {
                  gameCubit.undo();
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                '${winnerPlayer.name} wins',
                key: Key(EndPageTitle),
                style: context.theme().textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Game heroes',
                style: context.theme().textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  BountyHunterTile(),
                  NaturalBornKillerTile(),
                  LonelyBoyTile(),
                  StrongestTile(),
                  FeederTile(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Game stats',
                style: context.theme().textTheme.headline6,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Level'), numeric: true),
                      DataColumn(label: Text('Gear'), numeric: true),
                      DataColumn(label: Text('Strength'), numeric: true),
                    ],
                    rows: players
                        .asMap()
                        .map((index, player) => MapEntry(
                            index,
                            DataRow(
                                selected: player.id == winnerPlayer.id,
                                cells: [
                                  DataCell(SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          player.name,
                                          key: Key('$EndPagePlayerName$index'),
                                        ),
                                      ],
                                    ),
                                  )),
                                  DataCell(Text(
                                    player.level.toString(),
                                    key: Key('$EndPagePlayerLevel$index'),
                                  )),
                                  DataCell(Text(
                                    player.gear.toString(),
                                    key: Key('$EndPagePlayerGear$index'),
                                  )),
                                  DataCell(Text(
                                    player.strength.toString(),
                                    key: Key('$EndPagePlayerStrength$index'),
                                  )),
                                ])))
                        .values
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: context.theme().appBarTheme.color,
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FancyButton(
                  key: Key(EndPageNewGameButton),
                  child: Center(
                    child: Text(
                      'New game',
                      style: context.theme().textTheme.bodyText1,
                    ),
                  ),
                  size: 30,
                  color: context.theme().accentColor,
                  onPressed: () {
                    gameCubit.resetPlayers();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (_) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
