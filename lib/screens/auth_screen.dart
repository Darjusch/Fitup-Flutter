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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
            top: 40.0.h, bottom: 40.0.h, left: 45.0.w, right: 45.0.w),
        child: Form(
          key: formKey,
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
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: const ValueKey("emailField"),
      controller: emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
      validator: (text) {
        if (!(text.contains('@')) && text.isNotEmpty) {
          return "Enter a valid email address!";
        }
        return null;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: const ValueKey("passwordField"),
      controller: passwordController,
      validator: (text) {
        if (text.length <= 8 && text.isNotEmpty) {
          return "Password has to be atleast 8 characters!";
        }
        return null;
      },
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
        if (formKey.currentState.validate()) {
          context.read<AuthProvider>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
        }
      },
      child: const Text("Sign in"),
    );
  }

  Widget singUpButton() {
    return ElevatedButton(
      key: const ValueKey("Sign up"),
      style: ElevatedButton.styleFrom(primary: Colors.white),
      onPressed: () {
        if (formKey.currentState.validate()) {
          context.read<AuthProvider>().signUp(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
        }
      },
      child: const Text("Sign Up", style: TextStyle(color: Colors.blue)),
    );
  }

  Widget developerSignInButton() {
    return ElevatedButton(
      key: const ValueKey("DEVELOPER"),
      style: ElevatedButton.styleFrom(primary: Colors.white),
      onPressed: () {
        context.read<AuthProvider>().devSignIn();
      },
      child: const Text("DEVELOPER", style: TextStyle(color: Colors.red)),
    );
  }
}
