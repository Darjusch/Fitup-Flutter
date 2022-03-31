import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthenticationService.dart';
import '../../utils/navigation_helper.dart';
class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signUp(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: const Text("Sign up"),
          ),
          Row(
            children: [
              const Text("Already have an account?"),
              ElevatedButton(onPressed: () {
                NavigationHelper().goToSignInScreen(context);
              }, child: const Text("Sign in instead"))
            ],
          )
        ],
      ),
    );
  }
}