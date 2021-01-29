import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/logic/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/button.dart';
import 'package:munchkin/ui/helper.dart';
import 'package:munchkin/ui/icons/munchkin_icons.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsCubit settingsCubit = context.watch<SettingsCubit>();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            'Settings',
            style: context.theme().textTheme.headline3,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'General',
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
                          Spacer(),
                          Expanded(
                            child: FancyButton(
                              size: 20,
                              color: context.theme().accentColor,
                              child: Center(child: Text('10')),
                              onPressed: () =>
                                  context.read<GameCubit>().changeMaxLevel(10),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: FancyButton(
                              size: 20,
                              color: context.theme().accentColor,
                              child: Center(child: Text('20')),
                              onPressed: () =>
                                  context.read<GameCubit>().changeMaxLevel(20),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: FancyButton(
                              size: 20,
                              color: context.theme().accentColor,
                              child: Center(child: Text('Max')),
                              onPressed: () =>
                                  context.read<GameCubit>().changeMaxLevel(999),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'More',
                style: context.theme().textTheme.headline6,
              ),
            ),
            ListTile(
              title: Text('About me'),
              onTap: () => Helper.showSocialMediaBottomSheet(context),
            ),
            ListTile(
              title: Text('Licenses'),
              onTap: () => showAboutDialog(
                context: context,
                applicationIcon: Icon(
                  Munchkin.munchkin_dice,
                  color: Colors.white,
                ),
                applicationVersion: 'v1.0.0',
                applicationLegalese:
                    'Licenses for software used by the application',
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
