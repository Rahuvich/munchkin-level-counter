import 'package:flutter/material.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

class PlayersStatisticsBottom extends StatelessWidget {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // * Subtle actions
                Builder(builder: (context) {
                  MapEntry<String, int> entry;
                  Player player;
                  bool enabled = false;
                  try {
                    entry = context
                        .select<AchievementsCubit, MapEntry<String, int>>(
                            (cubit) => cubit.state.mostTreasures.entries.first);

                    player = context.select<GameCubit, Player>((cubit) => cubit
                        .state.players
                        .firstWhere((p) => p.id == entry.key));

                    enabled = true;
                  } catch (e) {}

                  return ListTile(
                    enabled: enabled,
                    title: Text('Bounty Hunter'),
                    subtitle: Text(
                        '${player?.name ?? 'None'} has won the biggest amount of treasures from enemies'),
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text('${entry?.value ?? 0}',
                            style: context.theme().textTheme.headline5),
                      ),
                    ),
                  );
                }),
                ListTile(
                  enabled: false,
                  title: Text('Natural Born Killer'),
                  subtitle: Text('has killed 4 monsters'),
                  leading: Text('', style: TextStyle(fontFamily: 'Quasimodo')),
                ),
                Builder(builder: (context) {
                  StringAndInt entry;
                  Player player;
                  bool enabled = false;
                  try {
                    entry = context.select<AchievementsCubit, StringAndInt>(
                        (cubit) => cubit.state.strongest);

                    player = context.select<GameCubit, Player>((cubit) => cubit
                        .state.players
                        .firstWhere((p) => p.id == entry.string));

                    enabled = true;
                  } catch (e) {}

                  return ListTile(
                    enabled: enabled,
                    title: Text('Armed to the teeth'),
                    subtitle: Text(
                        '${player?.name ?? 'None'} has had more strength at some point'),
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text('${entry?.value ?? 0}',
                            style: context.theme().textTheme.headline5),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
