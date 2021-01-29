import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:munchkin/logic/cubit/achievements_cubit.dart';
import 'package:munchkin/logic/cubit/battle_cubit.dart';
import 'package:munchkin/logic/cubit/game_observer.dart';
import 'package:munchkin/logic/cubit/settings_cubit.dart';
import 'package:munchkin/ui/theme/app_theme.dart';
import 'package:munchkin/ui/router/route_generator.dart';
import 'package:path_provider/path_provider.dart';

import 'logic/cubit/game_cubit.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Bloc.observer = GameObserver();
  GameCubit gameCubit = GameCubit();
  BattleCubit battleCubit = BattleCubit(gameCubit: gameCubit);
  AchievementsCubit achievementsCubit =
      AchievementsCubit(battleCubit: battleCubit);

  runApp(MyApp(
    gameCubit: gameCubit,
    battleCubit: battleCubit,
    achievementsCubit: achievementsCubit,
  ));
}

class MyApp extends StatelessWidget {
  final GameCubit gameCubit;
  final BattleCubit battleCubit;
  final AchievementsCubit achievementsCubit;
  MyApp({this.gameCubit, this.battleCubit, this.achievementsCubit});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => gameCubit,
        ),
        BlocProvider(
          create: (context) => battleCubit,
        ),
        BlocProvider(
          create: (context) => achievementsCubit,
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Munchkin Level Counter',
        initialRoute: 'welcome',
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: AppTheme.getTheme(isLight: false),
      ),
    );
  }
}
