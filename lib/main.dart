import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:munchkin/logic/cubit/game_observer.dart';
import 'package:munchkin/ui/app_theme.dart';
import 'package:munchkin/ui/router/route_generator.dart';

void main() {
  Bloc.observer = GameObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Munchkin Level Counter',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: AppTheme.getTheme(isLight: false),
    );
  }
}
