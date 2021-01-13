import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/cubit/game_cubit.dart';
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

    test('The initial players are 3', () {
      expect(gameCubit.state.players.length, 3);
    });

    blocTest('The cubit should add one player',
        build: () => gameCubit,
        act: (GameCubit cubit) => cubit.addPlayer('Cam'),
        expect: [
          GameplayState(players: [Player(name: 'Cam')])
        ]);

    /*  blocTest('The cubit should remove one player',
        build: () => gameCubit,
        act: (GameCubit cubit) => cubit.removePlayer('Cam'),
        expect: [
          GameplayState(players: [Player(name: 'Cam')])
        ]); */
  });
}
