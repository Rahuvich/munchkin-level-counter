import 'package:flutter/material.dart';
import 'package:munchkin/ui/screens/home_page.dart';
import 'package:munchkin/ui/screens/splash_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    print(settings.name);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case 'welcome':
        return MaterialPageRoute(builder: (_) => SplashPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(
                elevation: 0,
              ),
              body: Center(
                child: Text('Error'),
              ),
            ));
  }
}
