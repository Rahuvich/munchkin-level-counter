import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/munchkin.dart';

void main() {
  group('Achievements Cubit', () {
    GameCubit gameCubit;
    BattleCubit battleCubit;
    AchievementsCubit achievementsCubit;
    Player player;

    setUp(() {
      gameCubit = GameCubit();

      gameCubit.addPlayer('Mabe', id: 'id');

      player = gameCubit.state.players.first;

      battleCubit = BattleCubit(gameCubit: gameCubit);
      battleCubit.initializeBattleWithPlayer(player,
          initialMonsterId: 'monster_id');

      achievementsCubit =
          AchievementsCubit(battleCubit: battleCubit, gameCubit: gameCubit);
    });

    tearDown(() {
      gameCubit.close();
      battleCubit.close();
    });

    test('The initial achievements are empty', () {
      expect(achievementsCubit.state, AchievementsState());
    });

    test(
        'Should track when a player wins a battle how many monsters has he killed',
        () async {
      gameCubit.addLevelToPlayer('id', 1);
      gameCubit.addGearToPlayer('id', 1);

      await Future.delayed(Duration(seconds: 4));
      battleCubit.addMonster();
      battleCubit.endBattle();

      await Future.delayed(Duration(seconds: 4));
      expect(
          achievementsCubit.state,
          AchievementsState(
              mostMonstersKilled: {'id': 2},
              mostLonelyBoy: {'id': 1},
              mostStrength: {'id': 3}));
    });

    test(
        'Should track when a player wins a battle how many treasures has he recollected',
        () async {
      gameCubit.addLevelToPlayer('id', 1);
      gameCubit.addGearToPlayer('id', 1);

      await Future.delayed(Duration(seconds: 4));
      battleCubit.addTreasuresToMonster('monster_id', 10);
      battleCubit.endBattle();

      await Future.delayed(Duration(seconds: 4));
      expect(
          achievementsCubit.state,
          AchievementsState(
              mostMonstersKilled: {'id': 1},
              mostTreasures: {'id': 10},
              mostLonelyBoy: {'id': 1},
              mostStrength: {'id': 3}));
    });

    test('Should track when a player wins a battle alone', () async {
      gameCubit.addLevelToPlayer('id', 1);
      gameCubit.addGearToPlayer('id', 1);

      await Future.delayed(Duration(seconds: 4));
      battleCubit.endBattle();

      await Future.delayed(Duration(seconds: 4));
      expect(
          achievementsCubit.state,
          AchievementsState(
              mostMonstersKilled: {'id': 1},
              mostLonelyBoy: {'id': 1},
              mostStrength: {'id': 3}));
    });

    test('Should track when a player lose a battle', () async {
      battleCubit.endBattle();

      await Future.delayed(Duration(seconds: 4));
      expect(achievementsCubit.state,
          AchievementsState(mostLostBattles: {'id': 1}));
    });

    test('Should track when a player changes strength', () async {
      gameCubit.addLevelToPlayer('id', 1);

      await Future.delayed(Duration(seconds: 4));
      expect(
          achievementsCubit.state, AchievementsState(mostStrength: {'id': 2}));

      gameCubit.addGearToPlayer('id', 1);
      await Future.delayed(Duration(seconds: 4));
      expect(
          achievementsCubit.state, AchievementsState(mostStrength: {'id': 3}));

      gameCubit.addPlayer('Planas', id: 'planas_id');
      await Future.delayed(Duration(seconds: 4));
      expect(achievementsCubit.state,
          AchievementsState(mostStrength: {'id': 3, 'planas_id': 1}));
    });
  });
}
