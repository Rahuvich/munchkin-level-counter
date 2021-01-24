import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/models/munchkin.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('Achievements Cubit', () {
    GameCubit gameCubit;
    BattleCubit battleCubit;
    AchievementsCubit achievementsCubit;
    Player player;
    Storage storage;

    setUp(() {
      storage = MockStorage();
      when(storage.write(any, any)).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      gameCubit = GameCubit();

      gameCubit.addPlayer('Mabe', id: 'id');

      player = gameCubit.state.players.first;

      battleCubit = BattleCubit(gameCubit: gameCubit);
      battleCubit.initializeBattleWithPlayer(player,
          initialMonsterId: 'monster_id');

      achievementsCubit = AchievementsCubit(battleCubit: battleCubit);
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
      expectLater(
          achievementsCubit,
          emits(AchievementsState(
              mostMonstersKilled: {'id': 2}, mostLonelyBoy: {'id': 1})));

      battleCubit.addModifiersToMonster('monster_id', -5);
      battleCubit.addMonster(id: 'monster_id_2');

      battleCubit.addModifiersToMonster('monster_id_2', -5);
      battleCubit.endBattle();
    });

    test(
        'Should track when a player wins a battle how many treasures has he recollected',
        () async {
      expectLater(
          achievementsCubit,
          emits(AchievementsState(
              mostMonstersKilled: {'id': 1},
              mostTreasures: {'id': 10},
              mostLonelyBoy: {'id': 1})));

      battleCubit.addModifiersToMonster('monster_id', -5);
      battleCubit.addTreasuresToMonster('monster_id', 10);
      battleCubit.endBattle();
    });

    test('Should track when a player wins a battle alone', () async {
      expectLater(
          achievementsCubit,
          emits(AchievementsState(
              mostMonstersKilled: {'id': 1}, mostLonelyBoy: {'id': 1})));
      battleCubit.addModifiersToMonster('monster_id', -5);
      battleCubit.endBattle();
    });

    test('Should track when a player lose a battle', () async {
      expectLater(achievementsCubit,
          emits(AchievementsState(mostLostBattles: {'id': 1})));
      battleCubit.endBattle();
    });

    test('Should track when a player changes strength', () async {
      expectLater(
          achievementsCubit,
          emitsInOrder([
            AchievementsState(strongest: StringAndInt(string: 'id', value: 2)),
            AchievementsState(strongest: StringAndInt(string: 'id', value: 3)),
          ]));
      gameCubit.addLevelToPlayer('id', 1);
      gameCubit.addGearToPlayer('id', 1);
    });

    test('Should reset when game is restarted', () async {
      expectLater(
          achievementsCubit,
          emitsInOrder([
            AchievementsState(strongest: StringAndInt(string: 'id', value: 2)),
            AchievementsState(strongest: StringAndInt(string: 'id', value: 3)),
            AchievementsState()
          ]));
      gameCubit.addLevelToPlayer('id', 1);
      gameCubit.addGearToPlayer('id', 1);
      gameCubit.restartGame();
    });
  });
}
