import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/components/player_tile.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';

class MockBattleCubit extends MockBloc<BattleState> implements BattleCubit {}

class MockGameCubit extends MockBloc<GameState> implements GameCubit {}

void main() {
  group('PlayerTile', () {
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

    testWidgets('Should show player information', (WidgetTester tester) async {
      Player player = Player(
          id: 'id', name: 'Mabe', level: 5, gear: 10, gender: Gender.MALE);

      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [player],
        ),
      );

      await tester.pumpWidget(makeTestableWidget(
          child: PlayerTile(
        player: player,
        onBattle: (player) {},
      )));

      await tester.pumpAndSettle();

      Finder playerName = find.byKey(Key(PlayersPagePlayerTileName));
      expect(playerName, findsOneWidget);
      expect((playerName.evaluate().first.widget as Text).data, player.name);

      Finder playerGender = find.byKey(Key(PlayersPagePlayerTileGender));
      expect(playerGender, findsOneWidget);

      Finder expansionTile =
          find.byKey(Key(PlayersPagePlayerTileExpansionTile));
      await tester.tap(expansionTile);
      await tester.pumpAndSettle();

      Finder playerStrength = find.byKey(Key(PlayersPagePlayerTileStrength));
      expect(playerStrength, findsOneWidget);
      expect((playerStrength.evaluate().first.widget as Text).data,
          player.strength.toString());

      Finder playerLevel = find.byKey(Key(PlayersPagePlayerTileLevel));
      expect(playerLevel, findsOneWidget);
      expect((playerLevel.evaluate().first.widget as Text).data,
          player.level.toString());

      Finder playerGear = find.byKey(Key(PlayersPagePlayerTileGear));
      expect(playerGear, findsOneWidget);
      expect((playerGear.evaluate().first.widget as Text).data,
          player.gear.toString());
    });

    testWidgets('Interaction with buttons should work',
        (WidgetTester tester) async {
      Player player = Player(
          id: 'id', name: 'Mabe', level: 5, gear: 10, gender: Gender.MALE);

      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [player],
        ),
      );

      bool onBattleIsCalled = false;

      await tester.pumpWidget(makeTestableWidget(
          child: PlayerTile(
        player: player,
        onBattle: (player) {
          onBattleIsCalled = true;
        },
      )));

      await tester.pumpAndSettle();

      // Gender Button
      Finder playerGenderButton =
          find.byKey(Key(PlayersPagePlayerTileGenderButton));
      expect(playerGenderButton, findsOneWidget);
      await tester.tap(playerGenderButton);
      await tester.pumpAndSettle();

      verify(gameCubit.toggleGenderOfPlayer(player.id)).called(1);

      // Open tile
      Finder expansionTile =
          find.byKey(Key(PlayersPagePlayerTileExpansionTile));
      await tester.tap(expansionTile);
      await tester.pumpAndSettle();

      // Battle Button
      Finder playerBattleButton =
          find.byKey(Key(PlayersPagePlayerTileBattleButton));
      expect(playerBattleButton, findsOneWidget);
      await tester.tap(playerBattleButton);
      await tester.pumpAndSettle();
      expect(onBattleIsCalled, true);

      // Die Button
      Finder playerDieButton = find.byKey(Key(PlayersPagePlayerTileDieButton));
      expect(playerDieButton, findsOneWidget);
      await tester.tap(playerDieButton);
      await tester.pumpAndSettle();

      verify(gameCubit.killPlayer(player.id)).called(1);

      // Level Up Button
      Finder playerLevelUpButton =
          find.byKey(Key(PlayersPagePlayerTileLevelUpButton));
      expect(playerLevelUpButton, findsOneWidget);
      await tester.tap(playerLevelUpButton);
      await tester.pumpAndSettle();

      verify(gameCubit.addLevelToPlayer(player.id, 1)).called(1);

      // Level Down Button
      Finder playerLevelDownButton =
          find.byKey(Key(PlayersPagePlayerTileLevelDownButton));
      expect(playerLevelDownButton, findsOneWidget);
      await tester.tap(playerLevelDownButton);
      await tester.pumpAndSettle();

      verify(gameCubit.addLevelToPlayer(player.id, -1)).called(1);

      // Gear Up Button
      Finder playerGearUpButton =
          find.byKey(Key(PlayersPagePlayerTileGearUpButton));
      expect(playerGearUpButton, findsOneWidget);
      await tester.tap(playerGearUpButton);
      await tester.pumpAndSettle();

      verify(gameCubit.addGearToPlayer(player.id, 1)).called(1);

      // Gear Down Button
      Finder playerGearDownButton =
          find.byKey(Key(PlayersPagePlayerTileGearDownButton));
      expect(playerGearDownButton, findsOneWidget);
      await tester.tap(playerGearDownButton);
      await tester.pumpAndSettle();

      verify(gameCubit.addGearToPlayer(player.id, -1)).called(1);
    });

    tearDown(() {
      battleCubit.close();
      gameCubit.close();
    });
  });
}
