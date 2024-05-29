import 'package:flutter/material.dart';
import 'package:slow_sync_demo/home_page.dart';
import 'package:slow_sync_demo/login_page.dart';
import 'package:slow_sync_demo/models/User.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState navigator = navigatorKey.currentState!;

  static Route generateRoute(RouteSettings routeSettings, BuildContext context) {
    final routeName = routeSettings.name;

    switch (routeName) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case home:
        final user = routeSettings.arguments as User;
        return MaterialPageRoute(builder: (context) => HomePage(user: user));
      default:
        return MaterialPageRoute(builder: (context) => const Text("Route not found"));
    }
  }
}
