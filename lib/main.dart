import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slow_sync_demo/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Slow Sync Demo',
      initialRoute: AppRouter.login,
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings, context),
    );
  }
}
