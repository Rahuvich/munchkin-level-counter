import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';

part 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
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
        bool playersLengthMatch =
            state.players.length == this.state.mostStrength.length;
        bool allPlayersAreRecordedAndItsStrengthIsInferior = state.players
            .every((player) =>
                this.state.mostStrength.containsKey(player.id) &&
                this.state.mostStrength[player.id] >= player.strength);

        if (!playersLengthMatch ||
            !allPlayersAreRecordedAndItsStrengthIsInferior) {
          updateStrength(state.players);
        }
      }
    });
  }

  StreamSubscription<BattleState> monitorBattle() {
    return _battleSubscription = battleCubit.listen((state) {
      if (state.battleFinished) {
        if (state.playerStrength > state.monstersStrength)
          playerWonBattle(
              state.player,
              state.monsters.fold(0, (sum, monster) => sum + monster.treasures),
              state.monsters.length,
              state.ally);
        else
          playerLostBattle(state.player);
      }
    });
  }

  // * Unused
  void removePlayer(String id) {
    Map<String, int> mostMonstersKilledMod =
        Map.from(this.state.mostMonstersKilled);
    mostMonstersKilledMod.removeWhere((playerId, value) => playerId == id);

    Map<String, int> mostStrengthMod = Map.from(this.state.mostStrength);
    mostStrengthMod.removeWhere((playerId, value) => playerId == id);

    Map<String, int> mostLonelyBoyMod = Map.from(this.state.mostLonelyBoy);
    mostLonelyBoyMod.removeWhere((playerId, value) => playerId == id);

    Map<String, int> mostTreasuresMod = Map.from(this.state.mostTreasures);
    mostTreasuresMod.removeWhere((playerId, value) => playerId == id);

    Map<String, int> mostLostBattlesMod = Map.from(this.state.mostLostBattles);
    mostLostBattlesMod.removeWhere((playerId, value) => playerId == id);
    emit(this.state.copyWith(
        mostTreasures: sortMap(mostTreasuresMod),
        mostLonelyBoy: sortMap(mostLonelyBoyMod),
        mostStrength: sortMap(mostStrengthMod),
        mostMonstersKilled: sortMap(mostMonstersKilledMod),
        mostLostBattles: sortMap(mostLostBattlesMod)));
  }

  void resetAchievements() => emit(AchievementsState());

  void updateStrength(List<Player> players) {
    Map<String, int> map = {};

    for (Player player in players) {
      final maxStrength = this
          .state
          .mostStrength
          .entries
          .firstWhere((entry) => entry.key == player.id,
              orElse: () => MapEntry(player.id, 0))
          .value;

      map.putIfAbsent(player.id,
          () => maxStrength >= player.strength ? maxStrength : player.strength);
    }

    emit(this.state.copyWith(
          mostStrength: sortMap(map),
        ));
  }

  void playerWonBattle(
      Player player, int treasuresWon, int monsters, Player ally) {
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

    Map<String, int> mostLonelyBoyMod = Map.from(this.state.mostLonelyBoy);
    if (ally == null) {
      mostLonelyBoyMod.update(player.id, (fightsTillNow) => fightsTillNow + 1,
          ifAbsent: () => 1);
    }

    emit(this.state.copyWith(
        mostMonstersKilled: sortMap(mostMonstersKilledMod),
        mostTreasures: sortMap(mostTreasuresMod),
        mostLonelyBoy: sortMap(mostLonelyBoyMod)));
  }

  void playerLostBattle(Player player) {
    Map<String, int> mostLostBattlesMod = Map.from(this.state.mostLostBattles);
    mostLostBattlesMod.update(player.id, (battlesTillNow) => battlesTillNow + 1,
        ifAbsent: () => 1);

    emit(this.state.copyWith(
          mostLostBattles: mostLostBattlesMod,
        ));
  }

  Map<String, int> sortMap(Map<String, int> map) {
    return LinkedHashMap.from(
      SplayTreeMap.from(map, (key1, key2) => map[key2].compareTo(map[key1])),
    );
  }

  @override
  Future<void> close() {
    _gameSubscription.cancel();
    _battleSubscription.cancel();
    return super.close();
  }
}
