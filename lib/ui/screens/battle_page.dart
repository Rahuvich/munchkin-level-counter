import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/battle_components.dart';
import 'package:munchkin/ui/components/button.dart';

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
            icon: Icon(Icons.arrow_back_ios),
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
              PlayerInBattle(),
              ScoreBattle(),
              MonstersInBattle(),
              Row(
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
                    child: Text(
                      'End battle',
                      style: context.theme().textTheme.bodyText1,
                    ),
                    size: 30,
                    color: context.theme().accentColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
