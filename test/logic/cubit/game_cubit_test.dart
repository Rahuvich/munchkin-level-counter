import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:munchkin/models/munchkin.dart';

void main() {
  group('Gameplay Cubit', () {
    GameCubit gameCubit;

    setUp(() {
      gameCubit = GameCubit();
    });

    tearDown(() {
      gameCubit.close();
    });

    test('The initial players are 0', () {
      expect(gameCubit.state.players.length, 0);
    });

    blocTest('add one player with the default options',
        build: () => gameCubit,
        act: (GameCubit cubit) => cubit.addPlayer('Cam', id: 'id'),
        expect: [
          GameplayState(players: [
            Player(
                id: 'id', name: 'Cam', gender: Gender.MALE, level: 1, gear: 0)
          ])
        ]);

    group('Level related', () {
      blocTest('level up the player',
          build: () => gameCubit..addPlayer('Cam', id: 'id'),
          act: (GameCubit cubit) => cubit.addLevelToPlayer('id', 1),
          expect: [
            GameplayState(players: [Player(id: 'id', name: 'Cam', level: 2)])
          ]);

      blocTest('level down the player',
          build: () => gameCubit
            ..addPlayer('Cam', id: 'id')
            ..addLevelToPlayer('id', 1),
          act: (GameCubit cubit) => cubit.addLevelToPlayer('id', -1),
          expect: [
            GameplayState(players: [Player(id: 'id', name: 'Cam', level: 1)])
          ]);

      blocTest('Minimum level a player can have is set to default',
          build: () => gameCubit..addPlayer('Cam', id: 'id'),
          act: (GameCubit cubit) => cubit.addLevelToPlayer('id', -1),
          expect: []);
    });

    group('Gear related', () {
      blocTest('gear up the player',
          build: () => gameCubit..addPlayer('Cam', id: 'id'),
          act: (GameCubit cubit) => cubit.addGearToPlayer('id', 1),
          expect: [
            GameplayState(players: [Player(id: 'id', name: 'Cam', gear: 1)])
          ]);

      blocTest('gear down the player',
          build: () => gameCubit
            ..addPlayer('Cam', id: 'id')
            ..addGearToPlayer('id', 1),
          act: (GameCubit cubit) => cubit.addGearToPlayer('id', -1),
          expect: [
            GameplayState(players: [Player(id: 'id', name: 'Cam', gear: 0)])
          ]);

      blocTest('Minimum gear a player can have is set to default',
          build: () => gameCubit..addPlayer('Cam', id: 'id'),
          act: (GameCubit cubit) => cubit.addGearToPlayer('id', -1),
          expect: []);
    });

    blocTest('Change the gender of the player',
        build: () => gameCubit..addPlayer('Cam', id: 'id'),
        act: (GameCubit cubit) =>
            cubit..toggleGenderOfPlayer('id')..toggleGenderOfPlayer('id'),
        expect: [
          GameplayState(
              players: [Player(id: 'id', name: 'Cam', gender: Gender.FEMALE)]),
          GameplayState(
              players: [Player(id: 'id', name: 'Cam', gender: Gender.MALE)])
        ]);

    blocTest('Reset the stats of a player',
        build: () => gameCubit
          ..addPlayer('Cam', id: 'id')
          ..addLevelToPlayer('id', 1)
          ..addGearToPlayer('id', 1),
        act: (GameCubit cubit) => cubit..resetPlayer('id'),
        expect: [
          GameplayState(players: [
            Player(id: 'id', name: 'Cam', level: 1, gear: 0),
          ]),
        ]);

    blocTest('Remove a player',
        build: () => gameCubit..addPlayer('Temp', id: 'temp_id'),
        act: (GameCubit cubit) => cubit..removePlayer('temp_id'),
        expect: [GameplayState(players: [])]);

    blocTest('Kill the player',
        build: () => gameCubit
          ..addPlayer('Cam', id: 'id')
          ..addLevelToPlayer('id', 1)
          ..addGearToPlayer('id', 1),
        act: (GameCubit cubit) => cubit.killPlayer('id'),
        expect: [
          GameplayState(
              players: [Player(id: 'id', name: 'Cam', level: 2, gear: 0)])
        ]);

    blocTest('Reset all the players',
        build: () => gameCubit
          ..addPlayer('Cam', id: 'id')
          ..addLevelToPlayer('id', 1)
          ..addGearToPlayer('id', 1)
          ..addPlayer('Temp', id: 'temp_id')
          ..addLevelToPlayer('temp_id', 1)
          ..addGearToPlayer('temp_id', 1),
        act: (GameCubit cubit) => cubit.resetPlayers(),
        expect: [
          GameplayState(players: [
            Player(id: 'id', name: 'Cam'),
            Player(id: 'temp_id', name: 'Temp')
          ]),
        ]);
  });
}
