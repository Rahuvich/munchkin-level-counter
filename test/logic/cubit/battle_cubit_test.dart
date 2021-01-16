import 'package:flutter_test/flutter_test.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:munchkin/logic/cubit/settings_cubit.dart';
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

      battleCubit = BattleCubit(
          gameCubit: gameCubit, player: player, initialMonsterId: 'monster_id');
    });

    tearDown(() {
      battleCubit.close();
    });

    test('The initial player and monster is correct', () {
      expect(battleCubit.state,
          BattleState(player: player, monsters: [Monster(id: 'monster_id')]));
    });

    test('Level up player on GameCubit updates well the player of BattleCubit',
        () {
      expectLater(
          battleCubit.state,
          BattleState(
              player: player.copyWith(level: player.level + 1),
              monsters: [Monster(id: 'monster_id')]));

      gameCubit.addLevelToPlayer('id', 1);
    });
  });
}
