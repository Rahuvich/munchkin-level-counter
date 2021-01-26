import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'dart:convert';
import 'package:munchkin/models/models.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'achievements_state.dart';

class AchievementsCubit extends HydratedCubit<AchievementsState>
    with ReplayCubitMixin {
  BattleCubit battleCubit;

  StreamSubscription _gameSubscription;
  StreamSubscription _battleSubscription;
  AchievementsCubit({this.battleCubit}) : super(AchievementsState()) {
    monitorGame();
    monitorBattle();
  }

  StreamSubscription<GameState> monitorGame() {
    return _gameSubscription = battleCubit.gameCubit.listen((state) {
      if (state.hasJustStarted) {
        resetAchievements();
      } else {
        state.players.forEach((player) {
          if (player.strength > this.state.strongest.value) {
            updateStrength(player);
          }
        });
      }
    });
  }

  StreamSubscription<BattleState> monitorBattle() {
    return _battleSubscription = battleCubit.listen((state) {
      if (state.battleFinished) {
        if (state.playerStrength > state.monstersStrength)
          playerKilledMonsters(
            state.player,
            state.monsters.fold(0, (sum, monster) => sum + monster.treasures),
            state.monsters.length,
          );
        else
          playerLostBattle(state.player);

        if (state.ally == null) {
          playerHasFoughtAlone(state.player);
        }
      }
    });
  }

  void resetAchievements() => emit(AchievementsState());

  void updateStrength(Player player) => emit(this.state.copyWith(
        strongest: StringAndInt(string: player.id, value: player.strength),
      ));

  void playerHasFoughtAlone(Player player) {
    Map<String, int> mostLonelyBoyMod = Map.from(this.state.mostLonelyBoy);
    mostLonelyBoyMod.update(player.id, (fightsTillNow) => fightsTillNow + 1,
        ifAbsent: () => 1);

    emit(this.state.copyWith(mostLonelyBoy: mostLonelyBoyMod));
  }

  void playerKilledMonsters(Player player, int treasuresWon, int monsters) {
    Map<String, int> mostMonstersKilledMod =
        Map.from(this.state.mostMonstersKilled);
    mostMonstersKilledMod.update(
        player.id, (monstersTillNow) => monstersTillNow + monsters,
        ifAbsent: () => monsters);

    Map<String, int> mostTreasuresMod = Map.from(this.state.mostTreasures);
    if (treasuresWon > 0) {
      mostTreasuresMod.update(
          player.id, (treasuresTillNow) => treasuresTillNow + treasuresWon,
          ifAbsent: () => treasuresWon);
    }

    emit(this.state.copyWith(
        mostMonstersKilled: mostMonstersKilledMod,
        mostTreasures: mostTreasuresMod));
  }

  void playerLostBattle(Player player) {
    Map<String, int> mostLostBattlesMod = Map.from(this.state.mostLostBattles);
    mostLostBattlesMod.update(player.id, (battlesTillNow) => battlesTillNow + 1,
        ifAbsent: () => 1);

    emit(this.state.copyWith(
          mostLostBattles: mostLostBattlesMod,
        ));
  }

  @override
  Future<void> close() {
    _gameSubscription.cancel();
    _battleSubscription.cancel();
    return super.close();
  }

  @override
  AchievementsState fromJson(Map<String, dynamic> json) =>
      AchievementsState.fromMap(json);

  @override
  Map<String, dynamic> toJson(AchievementsState state) => state.toMap();
}
