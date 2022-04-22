import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: 40.0.h, bottom: 40.0.h, left: 40.0.w, right: 40.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            emailField(),
            passwordField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                signInButton(),
                singUpButton(),
                developerSignInButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return TextField(
      key: const ValueKey("emailField"),
      controller: emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      key: const ValueKey("passwordField"),
      controller: passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: 'Enter your password',
        suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            }),
      ),
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      key: const ValueKey("Sign in"),
      onPressed: () {
        context.read<AuthProvider>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
      },
      child: const Text("Sign in"),
    );
  }

  Widget singUpButton() {
    return ElevatedButton(
      key: const ValueKey("Sign up"),
      style: ElevatedButton.styleFrom(primary: Colors.white),
      onPressed: () {
        context.read<AuthProvider>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
      },
      child: const Text("Sign Up", style: TextStyle(color: Colors.blue)),
    );
  }

  Widget developerSignInButton() {
    return ElevatedButton(
      key: const ValueKey("DEVELOPER SIGNIN"),
      style: ElevatedButton.styleFrom(primary: Colors.white),
      onPressed: () {
        context.read<AuthProvider>().devSignIn();
      },
      child:
          const Text("DEVELOPER SIGNIN", style: TextStyle(color: Colors.red)),
    );
  }
}
