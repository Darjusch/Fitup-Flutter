import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthenticationService.dart';
import '../../utils/navigation_helper.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: "Password",
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: const Text("Sign in"),

          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () {
              context.read<AuthenticationService>().signUp(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: const Text("Sign Up", style: TextStyle(color: Colors.blue)),
          ),
        ],
        )
          ],
        ),
      ),
    );
  }
}