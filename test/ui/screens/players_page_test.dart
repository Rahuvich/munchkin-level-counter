import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:munchkin/models/models.dart';
import 'package:munchkin/ui/keys/widget_keys.dart';
import 'package:munchkin/ui/screens/players_page.dart';

class MockGameCubit extends MockBloc<GameState> implements GameCubit {}

class MockAchievementsCubit extends MockBloc<AchievementsState>
    implements AchievementsCubit {}

void main() {
  group('Players Page List', () {
    MockGameCubit gameCubit;
    MockAchievementsCubit achievementsCubit;

    setUp(() {
      gameCubit = MockGameCubit();
      achievementsCubit = MockAchievementsCubit();
    });

    Widget makeTestableWidget({Widget child}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<GameCubit>.value(
            value: gameCubit,
          ),
          BlocProvider<AchievementsCubit>.value(
            value: achievementsCubit,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(builder: (_) => child),
          ),
        ),
      );
    }

    testWidgets('Should enter a new player', (WidgetTester tester) async {
      Player player = Player(
          id: 'id', name: 'Mabe', level: 5, gear: 10, gender: Gender.MALE);

      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [player],
        ),
      );

      await tester.pumpWidget(makeTestableWidget(
          child: PlayersPage(
        onBattle: (player) {},
      )));

      await tester.pumpAndSettle();

      // There is a title
      expect(find.byKey(Key(PlayersPageTitle)), findsOneWidget);

      Finder newPlayerField = find.byKey(Key(PlayersPageNewPlayerField));
      await tester.enterText(newPlayerField, 'new_player');

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(gameCubit.addPlayer('new_player'.capitalize())).called(1);
    });

    testWidgets('Shoud show an empty GameHeroes bottom sheet',
        (WidgetTester tester) async {
      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [],
        ),
      );
      when(achievementsCubit.state).thenAnswer(
        (_) => AchievementsState(),
      );

      await tester.pumpWidget(makeTestableWidget(
          child: PlayersPage(
        onBattle: (player) {},
      )));

      await tester.pumpAndSettle();

      Finder gameHeroesButton = find.byKey(Key(PlayersPageGameHeroesButton));
      expect(gameHeroesButton, findsOneWidget);
      await tester.tap(gameHeroesButton);
      await tester.pumpAndSettle();

      Finder bountyHunterValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetBountyHunterValue));
      expect(bountyHunterValue, findsOneWidget);
      expect((bountyHunterValue.evaluate().first.widget as Text).data, '');

      Finder naturalBornKillerValue = find
          .byKey(Key(PlayersPageGameHeroesBottomSheetNaturalBornKillerValue));
      expect(naturalBornKillerValue, findsOneWidget);
      expect((naturalBornKillerValue.evaluate().first.widget as Text).data, '');

      Finder lonelyBoyValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetLonelyBoyValue));
      expect(lonelyBoyValue, findsOneWidget);
      expect((lonelyBoyValue.evaluate().first.widget as Text).data, '');

      Finder armedToTheTeethValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetArmedToTheTeethValue));
      expect(armedToTheTeethValue, findsOneWidget);
      expect((armedToTheTeethValue.evaluate().first.widget as Text).data, '');

      Finder feederValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetFeederValue));
      expect(feederValue, findsOneWidget);
      expect((feederValue.evaluate().first.widget as Text).data, '');
    });

    testWidgets('Shoud show a completed GameHeroes bottom sheet',
        (WidgetTester tester) async {
      Player player = Player(
          id: 'id', name: 'Mabe', level: 5, gear: 10, gender: Gender.MALE);

      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: [player],
        ),
      );
      when(achievementsCubit.state).thenAnswer(
        (_) => AchievementsState(
          strongest: StringAndInt(string: player.id, value: player.strength),
          mostLonelyBoy: new Map.fromEntries([MapEntry(player.id, 5)]),
          mostMonstersKilled: new Map.fromEntries([MapEntry(player.id, 5)]),
          mostTreasures: new Map.fromEntries([MapEntry(player.id, 5)]),
          mostLostBattles: new Map.fromEntries([MapEntry(player.id, 5)]),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(
          child: PlayersPage(
        onBattle: (player) {},
      )));

      await tester.pumpAndSettle();

      Finder gameHeroesButton = find.byKey(Key(PlayersPageGameHeroesButton));
      expect(gameHeroesButton, findsOneWidget);
      await tester.tap(gameHeroesButton);
      await tester.pumpAndSettle();

      Finder armedToTheTeethValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetArmedToTheTeethValue));
      expect(armedToTheTeethValue, findsOneWidget);
      expect((armedToTheTeethValue.evaluate().first.widget as Text).data,
          player.strength.toString());

      Finder naturalBornKillerValue = find
          .byKey(Key(PlayersPageGameHeroesBottomSheetNaturalBornKillerValue));
      expect(naturalBornKillerValue, findsOneWidget);
      expect(
          (naturalBornKillerValue.evaluate().first.widget as Text).data, '5');

      Finder bountyHunterValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetBountyHunterValue));
      expect(bountyHunterValue, findsOneWidget);
      expect((bountyHunterValue.evaluate().first.widget as Text).data,
          5.toString());

      Finder lonelyBoyValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetLonelyBoyValue));
      expect(lonelyBoyValue, findsOneWidget);
      expect((lonelyBoyValue.evaluate().first.widget as Text).data, '5');
      ;

      Finder feederValue =
          find.byKey(Key(PlayersPageGameHeroesBottomSheetFeederValue));
      expect(feederValue, findsOneWidget);
      expect((feederValue.evaluate().first.widget as Text).data, '5');
    });

    tearDown(() {
      gameCubit.close();
      achievementsCubit.close();
    });
  });
}
