import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';

part 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  BattleCubit battleCubit;
  GameCubit gameCubit;

  StreamSubscription _gameSubscription;
  StreamSubscription _battleSubscription;
  AchievementsCubit({this.battleCubit, this.gameCubit})
      : super(AchievementsState()) {
    monitorGame();
    monitorBattle();
  }

  StreamSubscription<GameState> monitorGame() {
    return _gameSubscription = gameCubit.listen((state) {
      if (!state.players.every((player) =>
          this.state.mostStrength.containsKey(player.id) &&
          this.state.mostStrength[player.id] >= player.strength)) {
        updateStrength(state.players);
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

  void updateStrength(List<Player> players) {
    Map<String, int> mostStrengthMod = Map.from(this.state.mostStrength);

    for (Player player in players) {
      mostStrengthMod.update(
          player.id,
          (maxStrength) =>
              maxStrength >= player.strength ? maxStrength : player.strength,
          ifAbsent: () => player.strength);
    }

    emit(this.state.copyWith(
          mostStrength: mostStrengthMod,
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
        mostMonstersKilled: mostMonstersKilledMod,
        mostTreasures: mostTreasuresMod,
        mostLonelyBoy: mostLonelyBoyMod));
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
}
