import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/battle_components.dart';

class MockBattleCubit extends MockBloc<BattleState> implements BattleCubit {}

class MockGameCubit extends MockBloc<GameState> implements GameCubit {}

void main() {
  group('Player Card', () {
    MockBattleCubit battleCubit;
    MockGameCubit gameCubit;

    setUp(() {
      battleCubit = MockBattleCubit();
      gameCubit = MockGameCubit();
    });

    Widget makeTestableWidget({Widget child}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<BattleCubit>.value(
            value: battleCubit,
          ),
          BlocProvider<GameCubit>.value(
            value: gameCubit,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(builder: (_) => child),
          ),
        ),
      );
    }

    testWidgets('Should show players information', (WidgetTester tester) async {
      Player player = Player(
          id: 'id', name: 'Mabe', level: 5, gear: 10, gender: Gender.MALE);
      int modifiers = 5;

      when(battleCubit.state).thenAnswer(
        (_) => BattleState(player: player, modifiers: modifiers),
      );
      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [player],
        ),
      );

      await tester.pumpWidget(makeTestableWidget(child: PlayerInBattle()));

      await tester.pumpAndSettle();

      Finder playerName = find.byKey(Key('battlePage_player_name'));
      Finder playerGender = find.byKey(Key('battlePage_player_gender'));

      Finder playerLevel = find.byKey(Key('battlePage_player_level'));
      Finder playerGear = find.byKey(Key('battlePage_player_gear'));
      Finder playerModifiers = find.byKey(Key('battlePage_player_modifiers'));
      Finder allyStrength = find.byKey(Key('battlePage_player_ally_strength'));

      expect(playerName, findsOneWidget);
      expect(playerGender, findsOneWidget);
      expect(playerLevel, findsOneWidget);
      expect(playerGear, findsOneWidget);
      expect(playerModifiers, findsOneWidget);
      expect(allyStrength, findsOneWidget);

      expect((playerName.evaluate().first.widget as Text).data, player.name);
      expect((playerLevel.evaluate().first.widget as Text).data,
          player.level.toString());
      expect((playerGear.evaluate().first.widget as Text).data,
          player.gear.toString());
      expect((playerModifiers.evaluate().first.widget as Text).data,
          modifiers.toString());
      expect((allyStrength.evaluate().first.widget as Text).data, '0');
      expect((playerGender.evaluate().first.widget as Icon).icon,
          FontAwesomeIcons.mars);
    });

    testWidgets('Should show monsters information',
        (WidgetTester tester) async {
      Player player = Player(
          id: 'id', name: 'Mabe', level: 5, gear: 10, gender: Gender.MALE);
      List<Monster> monsters = [
        Monster(
          level: 5,
          modifiers: 10,
        ),
        Monster(
          level: 1,
          modifiers: 5,
        ),
        Monster(
          level: 5,
          modifiers: 20,
        ),
      ];

      when(battleCubit.state).thenAnswer(
        (_) => BattleState(player: player, monsters: monsters),
      );
      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [player],
        ),
      );

      await tester.pumpWidget(makeTestableWidget(child: MonstersInBattle()));

      await tester.pumpAndSettle();

      List<Map<Finder, String>> monstersInfoFinders = monsters
          .asMap()
          .map((index, m) => MapEntry(
              index,
              new Map<Finder, String>.from(<Finder, String>{
                find.byKey(Key('battlePage_monster_${index + 1}_name')):
                    'Monster ${index + 1}',
                find.byKey(Key('battlePage_monster_${index + 1}_level')):
                    monsters[index].level.toString(),
                find.byKey(Key('battlePage_monster_${index + 1}_modifiers')):
                    monsters[index].modifiers.toString(),
                find.byKey(Key('battlePage_monster_${index + 1}_treasures')):
                    monsters[index].treasures.toString()
              })))
          .values
          .toList();

      for (Map<Finder, String> monster in monstersInfoFinders) {
        for (MapEntry<Finder, String> entry in monster.entries) {
          expect(entry.key, findsOneWidget);
          expect((entry.key.evaluate().first.widget as Text).data, entry.value);
        }
        await tester.drag(find.byType(PageView), Offset(-500, 0.0));
        await tester.pumpAndSettle();
      }
    });

    tearDown(() {
      battleCubit.close();
    });
  });
}
