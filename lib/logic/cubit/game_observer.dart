import 'package:bloc/bloc.dart';

/// {@template Game_observer}
/// [BlocObserver] for the Game application which
/// observes all [Cubit] state changes.
/// {@endtemplate}
class GameObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} – $change');
    super.onChange(cubit, change);
  }
}
