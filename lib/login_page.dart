import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slow_sync_demo/app_router.dart';

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
                  onPressed: () async => await Navigator.pushNamed(context, AppRouter.home),
                  child: const Text("Log in")),
            ],
          ),
        ),
      ),
    );
  }
}
