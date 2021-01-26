import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/battle_components.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/ui/components/snackbar_redo.dart';

class BattlePage extends StatelessWidget {
  final VoidCallback onBack;
  BattlePage({@required this.onBack});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BattleCubit>().state;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.theme().scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => onBack.call(),
          ),
          title: Text(
            'Battle',
            style: context.theme().textTheme.headline3,
          ),
        ),
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: PlayerInBattle()),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ScoreBattle()),
              Expanded(child: MonstersInBattle()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FancyButton(
                      child: Text(
                        'Add monster',
                        style: context.theme().textTheme.bodyText1,
                      ),
                      size: 30,
                      color: context.theme().accentColor,
                      onPressed: () => context.read<BattleCubit>().addMonster(),
                    ),
                    FancyButton(
                      onPressed: () {
                        context.read<BattleCubit>().endBattle();
                        onBack.call();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          content: RedoSnackbar(
                              title: state.playerStrength >
                                      state.monstersStrength
                                  ? '${state.player.name} has won the battle'
                                  : '${state.player.name} has lost the battle',
                              color: Colors.white,
                              onAction: context.read<GameCubit>().undo),
                        ));
                      },
                      child: Text(
                        'End battle',
                        style: context.theme().textTheme.bodyText1,
                      ),
                      size: 30,
                      color: context.theme().errorColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
