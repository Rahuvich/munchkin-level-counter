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
import 'package:munchkin/ui/keys/widget_keys.dart';

class MockBattleCubit extends MockBloc<BattleState> implements BattleCubit {}

class MockGameCubit extends MockBloc<GameState> implements GameCubit {}

void main() {
  group('Battle Components Cards', () {
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

      Finder playerName = find.byKey(Key(BattlePagePlayerName));
      Finder playerGender = find.byKey(Key(BattlePagePlayerGender));

      Finder playerLevel = find.byKey(Key(BattlePagePlayerLevel));
      Finder playerGear = find.byKey(Key(BattlePagePlayerGear));
      Finder playerModifiers = find.byKey(Key(BattlePagePlayerModifiers));
      Finder allyStrength = find.byKey(Key(BattlePagePlayerAllyStrength));

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

      await tester.pumpWidget(makeTestableWidget(
          child: SingleChildScrollView(
        child: MonstersInBattle(),
      )));

      await tester.pumpAndSettle();

      List<Map<Finder, String>> monstersInfoFinders = monsters
          .asMap()
          .map((index, m) => MapEntry(
              index,
              new Map<Finder, String>.from(<Finder, String>{
                find.byKey(Key('$BattlePageMonstersName${index + 1}')):
                    'Monster ${index + 1}',
                find.byKey(Key('$BattlePageMonstersLevel${index + 1}')):
                    monsters[index].level.toString(),
                find.byKey(Key('$BattlePageMonstersModifiers${index + 1}')):
                    monsters[index].modifiers.toString(),
                find.byKey(Key('$BattlePageMonstersTreasures${index + 1}')):
                    monsters[index].treasures.toString()
              })))
          .values
          .toList();

      for (Map<Finder, String> monster in monstersInfoFinders) {
        for (MapEntry<Finder, String> entry in monster.entries) {
          expect(entry.key, findsOneWidget);
          expect((entry.key.evaluate().first.widget as Text).data, entry.value);
        }
        await tester.drag(
            find.byType(SingleChildScrollView), Offset(0, -500.0));
        await tester.pumpAndSettle();
      }
    });

    tearDown(() {
      battleCubit.close();
      gameCubit.close();
    });
  });
}
