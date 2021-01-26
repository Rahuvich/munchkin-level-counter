import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/snackbar_redo.dart';

class PlayersSettingsBottomSheet extends StatelessWidget {
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
                ListTile(
                    title: Text('Shuffle players'),
                    subtitle: Text('Shuffle players in a random order'),
                    leading: Icon(Icons.shuffle),
                    onTap: () {
                      context.read<GameCubit>().shufflePlayers();
                      Navigator.of(context).pop();
                    }),
                Divider(),
                // * Caution actions
                ListTile(
                    title: Text(
                      'Reset players stats',
                      style: TextStyle(color: context.theme().errorColor),
                    ),
                    subtitle: Text('Restart players stats but keep them',
                        style: TextStyle(color: context.theme().errorColor)),
                    leading: Icon(Icons.settings_backup_restore_rounded,
                        color: context.theme().errorColor),
                    onTap: () {
                      context.read<GameCubit>().resetPlayers();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    title: Text(
                      'Restart game',
                      style: TextStyle(color: context.theme().errorColor),
                    ),
                    subtitle: Text(
                      'Remove all players',
                      style: TextStyle(color: context.theme().errorColor),
                    ),
                    leading: Icon(Icons.clear_all,
                        color: context.theme().errorColor),
                    onTap: () {
                      context.read<GameCubit>().restartGame();

                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
