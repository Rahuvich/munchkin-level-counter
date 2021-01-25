import 'package:flutter/material.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

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
                mostTreasures(),
                mostMonstersKilled(),
                mostLonelyBoy(),
                strongest(),
                mostLostBattles()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mostTreasures() {
    return Builder(builder: (context) {
      MapEntry<String, int> entry;
      Player player;
      bool enabled = false;
      try {
        entry = context.select<AchievementsCubit, MapEntry<String, int>>(
            (cubit) => cubit.state.mostTreasures.entries.first);

        player = context.select<GameCubit, Player>((cubit) =>
            cubit.state.players.firstWhere((p) => p.id == entry.key));

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
            child: Text('${entry?.value ?? ''}',
                key: Key(PlayersPageGameHeroesBottomSheetBountyHunterValue),
                style: context.theme().textTheme.headline5),
          ),
        ),
      );
    });
  }

  Widget mostMonstersKilled() {
    return Builder(builder: (context) {
      MapEntry<String, int> entry;
      Player player;
      bool enabled = false;
      try {
        entry = context.select<AchievementsCubit, MapEntry<String, int>>(
            (cubit) => cubit.state.mostMonstersKilled.entries.first);

        player = context.select<GameCubit, Player>((cubit) =>
            cubit.state.players.firstWhere((p) => p.id == entry.key));

        enabled = true;
      } catch (e) {}

      return ListTile(
        enabled: enabled,
        title: Text('Natural Born Killer'),
        subtitle:
            Text('${player?.name ?? 'None'} has killed the most monsters'),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text('${entry?.value ?? ''}',
                key:
                    Key(PlayersPageGameHeroesBottomSheetNaturalBornKillerValue),
                style: context.theme().textTheme.headline5),
          ),
        ),
      );
    });
  }

  Widget mostLonelyBoy() {
    return Builder(builder: (context) {
      MapEntry<String, int> entry;
      Player player;
      bool enabled = false;
      try {
        entry = context.select<AchievementsCubit, MapEntry<String, int>>(
            (cubit) => cubit.state.mostLonelyBoy.entries.first);

        player = context.select<GameCubit, Player>((cubit) =>
            cubit.state.players.firstWhere((p) => p.id == entry.key));

        enabled = true;
      } catch (e) {}

      return ListTile(
        enabled: enabled,
        title: Text('Lonely Boy'),
        subtitle: Text(
            '${player?.name ?? 'None'} who have fought more battles alone'),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text('${entry?.value ?? ''}',
                key: Key(PlayersPageGameHeroesBottomSheetLonelyBoyValue),
                style: context.theme().textTheme.headline5),
          ),
        ),
      );
    });
  }

  Widget mostLostBattles() {
    return Builder(builder: (context) {
      MapEntry<String, int> entry;
      Player player;
      bool enabled = false;
      try {
        entry = context.select<AchievementsCubit, MapEntry<String, int>>(
            (cubit) => cubit.state.mostLostBattles.entries.first);

        player = context.select<GameCubit, Player>((cubit) =>
            cubit.state.players.firstWhere((p) => p.id == entry.key));

        enabled = true;
      } catch (e) {}

      return ListTile(
        enabled: enabled,
        title: Text('Feeder'),
        subtitle: Text('${player?.name ?? 'None'} has lost the most battles'),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text('${entry?.value ?? ''}',
                key: Key(PlayersPageGameHeroesBottomSheetFeederValue),
                style: context.theme().textTheme.headline5),
          ),
        ),
      );
    });
  }

  Widget strongest() {
    return Builder(builder: (context) {
      StringAndInt entry;
      Player player;
      bool enabled = false;
      try {
        entry = context.select<AchievementsCubit, StringAndInt>(
            (cubit) => cubit.state.strongest);

        player = context.select<GameCubit, Player>((cubit) =>
            cubit.state.players.firstWhere((p) => p.id == entry.string));

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
            child: Text(enabled ? '${entry?.value ?? ''}' : '',
                key: Key(PlayersPageGameHeroesBottomSheetArmedToTheTeethValue),
                style: context.theme().textTheme.headline5),
          ),
        ),
      );
    });
  }
}
