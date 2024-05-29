import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome, User"),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Log out"))
          ],
        ),
      ),
    );
  }
}
