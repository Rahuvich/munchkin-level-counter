import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/logic/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsCubit settingsCubit = context.watch<SettingsCubit>();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.theme().scaffoldBackgroundColor,
          title: Text(
            'Settings',
            style: context.theme().textTheme.headline3,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Appearance',
                style: context.theme().textTheme.headline6,
              ),
            ),
            ListTile(
              title: Text('Theme'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Advanced settings',
                style: context.theme().textTheme.headline6,
              ),
            ),
            ListTile(
              onTap: () => settingsCubit.toggleScreenWake(),
              title: Text('Keep screen awake'),
              subtitle: Text(settingsCubit.state.screenWakeLocked
                  ? 'Screen is locked to be awake'
                  : 'Screen is not locked'),
              trailing: settingsCubit.state.screenWakeLocked
                  ? Icon(
                      Icons.lock_rounded,
                      color: Colors.greenAccent,
                    )
                  : Icon(
                      Icons.lock_open_rounded,
                    ),
            ),
            Builder(
              builder: (context) {
                int maxLevel = context.select<GameCubit, int>(
                    (cubit) => cubit.state.maxLevelTrigger);
                return ExpansionTile(
                  title: Text('Winning level'),
                  subtitle: Text(
                      'When a player reaches this level the game will end'),
                  trailing: Text(maxLevel.toString(),
                      style: context.theme().textTheme.subtitle1),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FancyButton(
                            size: 20,
                            color: context.theme().accentColor,
                            child: Text('10'),
                            onPressed: () =>
                                context.read<GameCubit>().changeMaxLevel(10),
                          ),
                          FancyButton(
                            size: 20,
                            color: context.theme().accentColor,
                            child: Text('20'),
                            onPressed: () =>
                                context.read<GameCubit>().changeMaxLevel(20),
                          ),
                          FancyButton(
                            size: 20,
                            color: context.theme().accentColor,
                            child: Text('Max'),
                            onPressed: () =>
                                context.read<GameCubit>().changeMaxLevel(999),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'About me',
                style: context.theme().textTheme.headline6,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
