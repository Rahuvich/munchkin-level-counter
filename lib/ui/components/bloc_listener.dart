import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/ui/components/snackbar_redo.dart';
import 'package:munchkin/models/models.dart';

class BlocsListener extends StatelessWidget {
  final Widget child;
  const BlocsListener({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      // * Trigger when game finishes
      listenWhen: (prevState, nextState) =>
          !prevState.gameFinished && nextState.gameFinished,
      listener: (context, state) {
        Navigator.of(context).pushNamed('finished');
      },
      child: BlocListener<GameCubit, GameState>(
        // * Trigger when game restarts
        listenWhen: (prevState, nextState) =>
            !prevState.hasJustStarted && nextState.hasJustStarted,
        listener: (context, state) {
          Scaffold.of(context).showSnackBar(SnackBar(
            padding: const EdgeInsets.symmetric(vertical: 0),
            content: RedoSnackbar(
                title: 'Game restarted',
                subtitle: 'You can undo this action',
                color: Colors.white,
                onAction: () {
                  context.read<GameCubit>().undo();
                  context.read<AchievementsCubit>().undo();
                }),
          ));
        },
        child: child,
      ),
    );
  }
}
