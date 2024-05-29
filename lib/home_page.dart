import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:slow_sync_demo/models/ModelProvider.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  Future<void> _logout(context) async {
    await Amplify.Auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${user.name}"),
            ElevatedButton(
              onPressed: () async => await _logout(context),
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
