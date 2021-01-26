import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

class BountyHunterTile extends StatelessWidget {
  const BountyHunterTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

      return GameHeroTag(
        title: 'Bounty Hunter',
        description:
            '${player?.name ?? 'None'} has won the biggest amount of treasures from enemies',
        name: player?.name,
        enabled: enabled,
        value: entry?.value,
        valueKey: PlayersPageGameHeroesBottomSheetBountyHunterValue,
      );
    });
  }
}

class NaturalBornKillerTile extends StatelessWidget {
  const NaturalBornKillerTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

      return GameHeroTag(
        title: 'Natural Born Killer',
        description: '${player?.name ?? 'None'} has killed the most monsters',
        name: player?.name,
        enabled: enabled,
        value: entry?.value,
        valueKey: PlayersPageGameHeroesBottomSheetNaturalBornKillerValue,
      );
    });
  }
}

class LonelyBoyTile extends StatelessWidget {
  const LonelyBoyTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

      return GameHeroTag(
        title: 'Lonely Boy',
        description: '${player?.name ?? 'None'} has fought more battles alone',
        name: player?.name,
        enabled: enabled,
        value: entry?.value,
        valueKey: PlayersPageGameHeroesBottomSheetLonelyBoyValue,
      );
    });
  }
}

class FeederTile extends StatelessWidget {
  const FeederTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

      return GameHeroTag(
        title: 'Feeder',
        description: '${player?.name ?? 'None'} has lost the most battles',
        name: player?.name,
        enabled: enabled,
        value: entry?.value,
        valueKey: PlayersPageGameHeroesBottomSheetFeederValue,
      );
    });
  }
}

class StrongestTile extends StatelessWidget {
  const StrongestTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

      return GameHeroTag(
        title: 'Armed to the teeth',
        description:
            '${player?.name ?? 'None'} has had more strength at some point',
        name: player?.name,
        enabled: enabled,
        value: entry?.value,
        valueKey: PlayersPageGameHeroesBottomSheetArmedToTheTeethValue,
      );
    });
  }
}

class GameHeroTag extends StatelessWidget {
  final String name, title, description;
  final int value;
  final bool enabled;
  final String valueKey;
  const GameHeroTag(
      {Key key,
      this.valueKey,
      this.description,
      this.enabled,
      this.value,
      this.name,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      title: Text(title),
      subtitle: Text(description),
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Text(value == null || value == 0 ? '' : value.toString(),
              key: Key(this.valueKey),
              style: context.theme().textTheme.headline5),
        ),
      ),
    );
  }
}
