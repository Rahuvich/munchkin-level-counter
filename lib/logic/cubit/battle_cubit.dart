import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;
import 'dart:convert';

part 'battle_state.dart';

class BattleCubit extends HydratedCubit<BattleState> {
  StreamSubscription _gameSubscription;
  GameCubit gameCubit;

  BattleCubit({@required this.gameCubit}) : super(BattleState()) {
    monitorPlayers();
  }

  StreamSubscription<GameState> monitorPlayers() {
    return _gameSubscription = gameCubit.listen((state) {
      Player player = this.state.player;
      Player ally = this.state.ally;

      if (player != null &&
          state.players.any((p) => p.id == player.id && p != player)) {
        Player auxPlayer = state.players.firstWhere(
            (p) => p.id == player.id && p != player,
            orElse: () => player);

        updatePlayer(auxPlayer);
      }

      if (ally != null &&
          state.players.any((p) => p.id == ally.id && p != ally)) {
        Player auxAlly = state.players.firstWhere(
            (p) => p.id == ally.id && p != ally,
            orElse: () => ally);

        updatePlayer(auxAlly);
      }
    });
  }

  void initializeBattleWithPlayer(Player player, {String initialMonsterId}) =>
      emit(BattleState(
          player: player,
          monsters: [Monster(id: initialMonsterId ?? Uuid().v1())]));

  void updatePlayer(player) {
    emit(this.state.copyWith(player: player));
  }

  void updateAlly(ally) {
    emit(this.state.copyWith(ally: ally));
  }

  void addModifiersToPlayer(int sum) =>
      emit(this.state.copyWith(modifiers: this.state.modifiers + sum));

  void addModifiersToMonster(String id, int sum) {
    List<Monster> monsters = this.state.monsters.map((monstr) {
      if (monstr.id == id) {
        return monstr.copyWith(modifiers: monstr.modifiers + sum);
      }
      return monstr;
    }).toList();

    emit(this.state.copyWith(monsters: monsters));
  }

  void addTreasuresToMonster(String id, int sum) {
    List<Monster> monsters = this.state.monsters.map((monstr) {
      if (monstr.id == id) {
        return monstr.copyWith(treasures: math.max(monstr.treasures + sum, 0));
      }
      return monstr;
    }).toList();

    emit(this.state.copyWith(monsters: monsters));
  }

  void addLevelToMonster(String id, int sum) {
    List<Monster> monsters = this.state.monsters.map((monstr) {
      if (monstr.id == id) {
        return monstr.copyWith(level: math.max(monstr.level + sum, 1));
      }
      return monstr;
    }).toList();

    emit(this.state.copyWith(monsters: monsters));
  }

  void addAlly(Player player) => emit(this.state.copyWith(ally: player));

  void removeAlly() => emit(BattleState(
      modifiers: this.state.modifiers,
      player: this.state.player,
      monsters: this.state.monsters));

  void addMonster({String id}) => emit(this.state.copyWith(
      monsters: List.from([]
        ..addAll(this.state.monsters)
        ..add(Monster(
          id: id ?? Uuid().v1(),
        )))));

  void removeMonster(String id) => emit(this.state.copyWith(
      monsters: this.state.monsters.where((m) => m.id != id).toList()));

  void endBattle() => emit(this.state.copyWith(battleFinished: true));

  @override
  Future<void> close() {
    _gameSubscription.cancel();
    return super.close();
  }

  @override
  BattleState fromJson(Map<String, dynamic> json) => BattleState.fromMap(json);

  @override
  Map<String, dynamic> toJson(BattleState state) => state.toMap();
}
