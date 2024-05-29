import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:slow_sync_demo/app_router.dart';
import 'package:slow_sync_demo/models/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> _login(String email, String password) async {
    try {
      final signInResult = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (signInResult.nextStep.signInStep != AuthSignInStep.done) {
        safePrint("Sign in step: ${signInResult.nextStep.signInStep}");
        return;
      }

      safePrint("User signed in successfully");

      final currentUser = await Amplify.Auth.getCurrentUser();

      final queryStartTime = DateTime.now();

      final result =
          await Amplify.DataStore.query(User.classType, where: User.ID.eq(currentUser.userId));
      var user = result.firstOrNull;
      if (user == null) {
        safePrint("query returned null, using observeQuery");

        final snapshot = await Amplify.DataStore.observeQuery(User.classType,
                where: User.ID.eq(currentUser.userId))
            .firstWhere((element) => element.isSynced && element.items.isNotEmpty);
        user = snapshot.items.firstOrNull;
      }

      final queryEndTime = DateTime.now();
      final elapsedTime = queryEndTime.difference(queryStartTime);

      safePrint("Query elapsed time (ms): ${elapsedTime.inMilliseconds}");

      if (user == null) {
        safePrint("User not found");
        return;
      }

      if (mounted) {
        await Navigator.pushNamed(context, AppRouter.home, arguments: user);
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      return;
    } on DataStoreException catch (e) {
      safePrint('Error querying user: ${e.message}');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
              ),
              ElevatedButton(
                  onPressed: () async =>
                      await _login(_emailController.text, _passwordController.text),
                  child: const Text("Log in")),
            ],
          ),
        ),
      ),
    );
  }
}
