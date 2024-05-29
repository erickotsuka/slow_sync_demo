import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:slow_sync_demo/amplifyconfiguration.dart';
import 'package:slow_sync_demo/app_router.dart';
import 'package:slow_sync_demo/models/ModelProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final dataStore = AmplifyDataStore(
        modelProvider: ModelProvider.instance,
        authModeStrategy: AuthModeStrategy.defaultStrategy,
      );
      final api = AmplifyAPI(modelProvider: ModelProvider.instance);
      await Amplify.addPlugins([auth, dataStore, api]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

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
