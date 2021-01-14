import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:munchkin/logic/cubit/game_observer.dart';
import 'package:munchkin/ui/theme/app_theme.dart';
import 'package:munchkin/ui/router/route_generator.dart';

import 'logic/cubit/game_cubit.dart';

void main() {
  Bloc.observer = GameObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
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
