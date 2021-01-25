import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

class EndGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameCubit gameCubit = context.watch<GameCubit>();
    AchievementsCubit achievementsCubit = context.watch<AchievementsCubit>();
    Player winnerPlayer = gameCubit.state.players
        .reduce((p1, p2) => p1.level > p2.level ? p1 : p2);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          '${winnerPlayer.name} wins',
          key: Key(EndPageTitle),
          style: context.theme().textTheme.headline3,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Game stats',
                style: context.theme().textTheme.headline6,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Level'), numeric: true),
                    DataColumn(label: Text('Gear'), numeric: true),
                    DataColumn(label: Text('Strength'), numeric: true),
                  ],
                  rows: gameCubit.state.players
                      .asMap()
                      .map((index, player) => MapEntry(
                          index,
                          DataRow(
                              selected: player.id == winnerPlayer.id,
                              cells: [
                                DataCell(Text(
                                  player.name,
                                  key: Key('$EndPagePlayerName$index'),
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Game heroes',
                style: context.theme().textTheme.headline6,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Monsters killed'), numeric: true),
                  DataColumn(label: Text('Treasures'), numeric: true),
                  DataColumn(label: Text('Battles alone'), numeric: true),
                  DataColumn(label: Text('Lost battles'), numeric: true),
                ],
                rows: gameCubit.state.players
                    .map((player) =>
                        DataRow(selected: player.id == winnerPlayer.id, cells: [
                          DataCell(Text(player.name)),
                          DataCell(Text(achievementsCubit
                                  .state.mostMonstersKilled[player.id]
                                  ?.toString() ??
                              '0')),
                          DataCell(Text(achievementsCubit
                                  .state.mostTreasures[player.id]
                                  ?.toString() ??
                              '0')),
                          DataCell(Text(achievementsCubit
                                  .state.mostLonelyBoy[player.id]
                                  ?.toString() ??
                              '0')),
                          DataCell(Text(achievementsCubit
                                  .state.mostLostBattles[player.id]
                                  ?.toString() ??
                              '0')),
                        ]))
                    .toList(),
              ),
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
                    Navigator.of(context).pushReplacementNamed('/');
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
