import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/battle_components.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/ui/components/snackbar_redo.dart';
import 'package:munchkin/ui/helper.dart';

class BattlePage extends StatelessWidget {
  final VoidCallback onBack;
  BattlePage({@required this.onBack});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BattleCubit>().state;
    return WillPopScope(
      onWillPop: () {
        onBack.call();
        return Future.value(false);
      },
      child: CustomScrollView(
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlayerInBattle(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ScoreBattle(),
                  ),
                  MonstersInBattle(),
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
                          onPressed: () =>
                              context.read<BattleCubit>().addMonster(),
                        ),
                        FancyButton(
                          onPressed: () {
                            Helper.showConfirmDialog(
                                title: state.playerStrength >
                                        state.monstersStrength
                                    ? '${state.player.name} wins'
                                    : '${state.player.name} loses',
                                destructive: true,
                                context: context,
                                onConfirm: () {
                                  context.read<BattleCubit>().endBattle();
                                  onBack.call();
                                });
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
                  SizedBox(
                    height: kToolbarHeight * 1.5,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
