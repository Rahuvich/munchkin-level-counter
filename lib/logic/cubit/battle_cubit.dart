import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';

part 'battle_state.dart';

class BattleCubit extends Cubit<BattleState> {
  StreamSubscription _gameSubscription;

  BattleCubit(
      {@required GameCubit gameCubit,
      @required Player player,
      String initialMonsterId})
      : super(BattleState(player: player, monsters: [
          Monster(
            id: initialMonsterId,
          )
        ])) {
    _gameSubscription = gameCubit.listen((state) {
      if (state.players.any((player) =>
          player.id == this.state.player.id && player != this.state.player)) {
        Player auxPlayer = state.players.firstWhere((player) =>
            player.id == this.state.player.id && player != this.state.player);

        updatePlayer(auxPlayer);
      }

      if (this.state.ally != null &&
          state.players.any((player) =>
              player.id == this.state.ally.id && player != this.state.ally)) {
        Player auxAlly = state.players.firstWhere((player) =>
            player.id == this.state.ally.id && player != this.state.ally);

        updatePlayer(auxAlly);
      }
    });
  }

  void updatePlayer(player) {
    emit(this.state.copyWith(player: player));
  }

  void updateAlly(ally) {
    emit(this.state.copyWith(ally: ally));
  }

  @override
  Future<void> close() {
    _gameSubscription.cancel();
    return super.close();
  }
}
