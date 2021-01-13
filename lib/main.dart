import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:munchkin/cubit/game_observer.dart';
import 'package:munchkin/ui/app_theme.dart';
import 'package:munchkin/ui/route_generator.dart';
import 'package:munchkin/ui/splash_page.dart/splash_page.dart';

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
      initialRoute: '/welcome',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: AppTheme.getTheme(isLight: false),
      home: SplashPage(),
    );
  }
}
