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
import 'package:munchkin/ui/screens/end_game_page.dart';
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

    testWidgets(
        'End page should show the winner and show the statistics of all the players',
        (WidgetTester tester) async {
      List<Player> players = [
        Player(
            id: 'id', name: 'Mabe', level: 10, gear: 10, gender: Gender.MALE),
        Player(
            id: 'loser_id',
            name: 'Planas',
            level: 5,
            gear: 10,
            gender: Gender.MALE)
      ];

      when(gameCubit.state).thenAnswer(
        (_) => GameState(
          players: players,
        ),
      );
      when(achievementsCubit.state).thenAnswer((_) => AchievementsState());

      await tester.pumpWidget(makeTestableWidget(child: EndGamePage()));
      await tester.pumpAndSettle();

      Finder title = find.byKey(Key(EndPageTitle));
      expect(title, findsOneWidget);
      expect((title.evaluate().first.widget as Text).data,
          '${players.first.name} wins');

      players.asMap().forEach((index, player) {
        Finder playerName = find.byKey(Key('$EndPagePlayerName$index'));
        expect(playerName, findsOneWidget);
        expect((playerName.evaluate().first.widget as Text).data, player.name);

        Finder playerLevel = find.byKey(Key('$EndPagePlayerLevel$index'));
        expect(playerLevel, findsOneWidget);
        expect((playerLevel.evaluate().first.widget as Text).data,
            player.level.toString());

        Finder playerGear = find.byKey(Key('$EndPagePlayerGear$index'));
        expect(playerGear, findsOneWidget);
        expect((playerGear.evaluate().first.widget as Text).data,
            player.gear.toString());

        Finder playerStrength = find.byKey(Key('$EndPagePlayerStrength$index'));
        expect(playerStrength, findsOneWidget);
        expect((playerStrength.evaluate().first.widget as Text).data,
            player.strength.toString());
      });

      Finder newGameButton = find.byKey(Key(EndPageNewGameButton));
      expect(newGameButton, findsOneWidget);
      await tester.tap(newGameButton);
      await tester.pumpAndSettle();
      verify(gameCubit.resetPlayers()).called(1);
    });

    tearDown(() {
      gameCubit.close();
      achievementsCubit.close();
    });
  });
}
