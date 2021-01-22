import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:munchkin/models/munchkin.dart';

void main() {
  group('Battle Cubit', () {
    GameCubit gameCubit;
    BattleCubit battleCubit;
    Player player;

    setUp(() {
      gameCubit = GameCubit();

      gameCubit.addPlayer('Mabe', id: 'id');

      player = gameCubit.state.players.first;

      battleCubit = BattleCubit(gameCubit: gameCubit);
      battleCubit.initializeBattleWithPlayer(player,
          initialMonsterId: 'monster_id');
    });

    tearDown(() {
      gameCubit.close();
      battleCubit.close();
    });

    test('The initial player and monster is correct', () {
      expect(battleCubit.state,
          BattleState(player: player, monsters: [Monster(id: 'monster_id')]));
    });

    test('Level up player on GameCubit updates well the player of BattleCubit',
        () async {
      gameCubit.addLevelToPlayer('id', 1);
      gameCubit.addGearToPlayer('id', 1);

      await Future.delayed(Duration(seconds: 4));
      expectLater(
          battleCubit.state,
          BattleState(
              player: player.copyWith(
                  level: player.level + 1, gear: player.gear + 1),
              monsters: [Monster(id: 'monster_id')]));
    });

    blocTest('add or sub modifiers to player',
        build: () => battleCubit,
        act: (BattleCubit cubit) =>
            cubit..addModifiersToPlayer(1)..addModifiersToPlayer(-1),
        expect: [
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              modifiers: 1,
              monsters: [Monster(id: 'monster_id')]),
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              modifiers: 0,
              monsters: [Monster(id: 'monster_id')])
        ]);

    blocTest('add or sub modifiers to monster',
        build: () => battleCubit,
        act: (BattleCubit cubit) => cubit
          ..addModifiersToMonster('monster_id', 1)
          ..addModifiersToMonster('monster_id', -1),
        expect: [
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id', modifiers: 1)]),
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id', modifiers: 0)])
        ]);

    blocTest(
        'add or sub treasures to monster, being 0 the minimum treasures of a monster',
        build: () => battleCubit,
        act: (BattleCubit cubit) => cubit
          ..addTreasuresToMonster('monster_id', 1)
          ..addTreasuresToMonster('monster_id', -1)
          ..addTreasuresToMonster('monster_id', -1),
        expect: [
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id', treasures: 1)]),
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id', treasures: 0)]),
        ]);

    blocTest(
        'add or remove level to monster, being 1 the minimum level of a monster',
        build: () => battleCubit,
        act: (BattleCubit cubit) => cubit
          ..addLevelToMonster('monster_id', 1)
          ..addLevelToMonster('monster_id', -1)
          ..addLevelToMonster('monster_id', -1),
        expect: [
          BattleState(player: Player(id: 'id', name: 'Mabe'), monsters: [
            Monster(id: 'monster_id', level: 2),
          ]),
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id')]),
        ]);

    blocTest('add or remove ally',
        build: () => battleCubit,
        act: (BattleCubit cubit) => cubit
          ..addAlly(Player(id: 'ally_id', name: 'Marco'))
          ..removeAlly(),
        expect: [
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              ally: Player(id: 'ally_id', name: 'Marco'),
              monsters: [Monster(id: 'monster_id')]),
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id')])
        ]);

    blocTest('add or remove monster',
        build: () => battleCubit,
        act: (BattleCubit cubit) => cubit
          ..addMonster(id: 'monster2_id')
          ..removeMonster('monster2_id'),
        expect: [
          BattleState(player: Player(id: 'id', name: 'Mabe'), monsters: [
            Monster(id: 'monster_id'),
            Monster(id: 'monster2_id')
          ]),
          BattleState(
              player: Player(id: 'id', name: 'Mabe'),
              monsters: [Monster(id: 'monster_id')])
        ]);

    test(
        'Player strength is calculated from the sum of [player.strength, ally.strength, modifiers]',
        () {
      Player ally = Player(id: 'ally_id', name: 'Ally', level: 6, gear: 5);

      battleCubit.addAlly(ally);
      battleCubit.addModifiersToPlayer(-2);

      expect(battleCubit.state.playerStrength, 10);
    });

    test(
        'Monsters strength is calculated from the sum of strenghts of all monsters',
        () {
      battleCubit.addMonster(id: 'monster2_id');

      battleCubit.addModifiersToMonster('monster2_id', -5);
      battleCubit.addLevelToMonster('monster2_id', 5);

      battleCubit.addLevelToMonster('monster_id', 1);

      expect(battleCubit.state.monstersStrength, 3);
    });

    test('Battle should finish', () {
      expect(battleCubit.state.battleFinished, false);
      battleCubit.endBattle();
      expect(battleCubit.state.battleFinished, true);
    });
  });
}
