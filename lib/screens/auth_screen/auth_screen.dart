import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthenticationService.dart';

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
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              key: const ValueKey("emailField"),
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              key: const ValueKey("passwordField"),
              controller: passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    }),
              ),
            ),
            // FlutterPwValidator(
            //     controller: passwordController,
            //     minLength: 6,
            //     uppercaseCharCount: 2,
            //     numericCharCount: 3,
            //     specialCharCount: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  key: const ValueKey("Sign in"),
                  onPressed: () {
                    context.read<Auth>().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                  },
                  child: const Text("Sign in"),
                ),
                ElevatedButton(
                  key: const ValueKey("Sign up"),
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    context.read<Auth>().signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(color: Colors.blue)),
                ),
                ElevatedButton(
                  key: const ValueKey("DEVELOPER SIGNIN"),
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    context.read<Auth>().devSignIn();
                  },
                  child: const Text("DEVELOPER SIGNIN",
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
