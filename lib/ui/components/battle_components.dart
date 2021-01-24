import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/ally_bottom.dart';
import 'package:munchkin/ui/components/button.dart';

class PlayerInBattle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Player player =
        context.select<BattleCubit, Player>((cubit) => cubit.state.player);
    Player allyPlayer =
        context.select<BattleCubit, Player>((cubit) => cubit.state.ally);
    int modifiersNum =
        context.select<BattleCubit, int>((cubit) => cubit.state.modifiers);
    return GlassCard(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              FancyButton(
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
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  allyPlayer == null
                      ? player.name
                      : '${player.name} x ${allyPlayer.name}',
                  style: context.theme().textTheme.bodyText1,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          level(context, player),
          SizedBox(
            height: 10,
          ),
          gear(context, player),
          SizedBox(
            height: 10,
          ),
          modifiers(context, modifiersNum),
          SizedBox(
            height: 10,
          ),
          ally(context, player, allyPlayer),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Row level(BuildContext context, Player player) {
    return Row(
      children: [
        Text('Level', style: context.theme().textTheme.headline6),
        Spacer(),
        FancyButton(
          child: Icon(Icons.expand_more),
          size: 20,
          color: context.theme().accentColor,
          onPressed: player.level == 1
              ? null
              : () => context.read<GameCubit>().addLevelToPlayer(player.id, -1),
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
          onPressed: () =>
              context.read<GameCubit>().addLevelToPlayer(player.id, 1),
        )
      ],
    );
  }

  Row gear(BuildContext context, Player player) {
    return Row(
      children: [
        Text('Gear', style: context.theme().textTheme.headline6),
        Spacer(),
        FancyButton(
          child: Icon(Icons.expand_more),
          size: 20,
          color: context.theme().accentColor,
          onPressed: player.gear == 0
              ? null
              : () => context.read<GameCubit>().addGearToPlayer(player.id, -1),
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
          onPressed: () =>
              context.read<GameCubit>().addGearToPlayer(player.id, 1),
        )
      ],
    );
  }

  Row modifiers(BuildContext context, int modifiersNum) {
    return Row(
      children: [
        Text('Modifiers', style: context.theme().textTheme.headline6),
        Spacer(),
        FancyButton(
          child: Icon(Icons.expand_more),
          size: 20,
          color: context.theme().accentColor,
          onPressed: () => context.read<BattleCubit>().addModifiersToPlayer(-1),
        ),
        SizedBox(
            width: 60,
            height: 20,
            child: FittedBox(
              child: Text(modifiersNum.toString(),
                  style: context.theme().textTheme.headline5),
            )),
        FancyButton(
          child: Icon(Icons.expand_less),
          size: 20,
          color: context.theme().accentColor,
          onPressed: () => context.read<BattleCubit>().addModifiersToPlayer(1),
        )
      ],
    );
  }

  Row ally(BuildContext context, Player player, Player ally) {
    return Row(
      children: [
        Text('Ally', style: context.theme().textTheme.headline6),
        Spacer(),
        SizedBox(
            width: 60,
            height: 20,
            child: FittedBox(
              child: Text(ally?.strength?.toString() ?? 0.toString(),
                  style: context.theme().textTheme.headline5),
            )),
        Builder(builder: (context) {
          List<Player> otherPlayers = context
              .select<GameCubit, List<Player>>((cubit) => cubit.state.players)
              .where((p) => p.id != player.id)
              .toList();

          return FancyButton(
            child: Icon(ally == null ? Icons.add : Icons.edit),
            size: 20,
            color: context.theme().accentColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => PlayersBottomSheet(
                  players: otherPlayers,
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

class ScoreBattle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int playerStrength =
        context.select<BattleCubit, int>((cubit) => cubit.state.playerStrength);
    int monstersStrength = context
        .select<BattleCubit, int>((cubit) => cubit.state.monstersStrength);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${playerStrength.toString()} vs ${monstersStrength.toString()}',
            style: context.theme().textTheme.headline3),
      ],
    );
  }
}

class MonstersInBattle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Monster> monsters = context
        .select<BattleCubit, List<Monster>>((cubit) => cubit.state.monsters);

    return PageView(
      children: monsters
          .asMap()
          .map((index, m) => MapEntry(
              index,
              SingleMonsterInBattle(
                deleteable: monsters.length > 1,
                monster: m,
                index: index + 1,
              )))
          .values
          .toList(),
    );
  }
}

class SingleMonsterInBattle extends StatelessWidget {
  final Monster monster;
  final int index;
  final bool deleteable;
  SingleMonsterInBattle({this.deleteable, this.monster, this.index});
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (deleteable)
                FancyButton(
                  color: context.theme().accentColor,
                  size: 20,
                  onPressed: () =>
                      context.read<BattleCubit>().removeMonster(monster.id),
                  child: Icon(Icons.clear),
                ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Monster $index',
                  style: context.theme().textTheme.bodyText1,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          level(context, monster),
          SizedBox(
            height: 10,
          ),
          modifier(context, monster),
          SizedBox(
            height: 10,
          ),
          treasures(context, monster),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Row level(BuildContext context, Monster monster) {
    return Row(
      children: [
        Text('Level', style: context.theme().textTheme.headline6),
        Spacer(),
        FancyButton(
          child: Icon(Icons.expand_more),
          size: 20,
          color: context.theme().accentColor,
          onPressed: monster.level == 1
              ? null
              : () =>
                  context.read<BattleCubit>().addLevelToMonster(monster.id, -1),
        ),
        SizedBox(
            width: 60,
            height: 20,
            child: FittedBox(
              child: Text(monster.level.toString(),
                  style: context.theme().textTheme.headline5),
            )),
        FancyButton(
          child: Icon(Icons.expand_less),
          size: 20,
          color: context.theme().accentColor,
          onPressed: () =>
              context.read<BattleCubit>().addLevelToMonster(monster.id, 1),
        )
      ],
    );
  }

  Row modifier(BuildContext context, Monster monster) {
    return Row(
      children: [
        Text('Modifiers', style: context.theme().textTheme.headline6),
        Spacer(),
        FancyButton(
          child: Icon(Icons.expand_more),
          size: 20,
          color: context.theme().accentColor,
          onPressed: () =>
              context.read<BattleCubit>().addModifiersToMonster(monster.id, -1),
        ),
        SizedBox(
            width: 60,
            height: 20,
            child: FittedBox(
              child: Text(monster.modifiers.toString(),
                  style: context.theme().textTheme.headline5),
            )),
        FancyButton(
          child: Icon(Icons.expand_less),
          size: 20,
          color: context.theme().accentColor,
          onPressed: () =>
              context.read<BattleCubit>().addModifiersToMonster(monster.id, 1),
        )
      ],
    );
  }

  Row treasures(BuildContext context, Monster monster) {
    return Row(
      children: [
        Text('Treasures', style: context.theme().textTheme.headline6),
        Spacer(),
        FancyButton(
          child: Icon(Icons.expand_more),
          size: 20,
          color: context.theme().accentColor,
          onPressed: monster.treasures == 0
              ? null
              : () => context
                  .read<BattleCubit>()
                  .addTreasuresToMonster(monster.id, -1),
        ),
        SizedBox(
            width: 60,
            height: 20,
            child: FittedBox(
              child: Text(monster.treasures.toString(),
                  style: context.theme().textTheme.headline5),
            )),
        FancyButton(
          child: Icon(Icons.expand_less),
          size: 20,
          color: context.theme().accentColor,
          onPressed: () =>
              context.read<BattleCubit>().addTreasuresToMonster(monster.id, 1),
        )
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  GlassCard({this.child});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: Colors.white.withOpacity(.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: child),
        ),
      ),
    );
  }
}
