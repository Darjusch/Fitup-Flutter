import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthenticationService.dart';
import '../../utils/navigation_helper.dart';
class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({Key key}) : super(key: key);

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
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: const Text("Sign in"),
          ),
          Row(
            children: [
              const Text("Not signed in yet?"),
              ElevatedButton(onPressed: () {
                NavigationHelper().goToSignUpScreen(context);
              }, child: const Text("Sign up now!"))
            ],
          )
        ],
      ),
    );
  }
}