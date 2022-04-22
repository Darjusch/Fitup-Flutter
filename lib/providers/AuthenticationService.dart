import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({this.auth});

  Stream<User> get user => auth.authStateChanges();


  Future<String> devSignIn() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: "dev@test.de", password: "somepassword123");
      debugPrint("Signed in");
      return "Success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint("Signed in");
      return "Success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      debugPrint("Signed up");
      return "Success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> changePassword(
      String currentPassword, String newPassword, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfully changed Password")));
        return "Success";
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("There was a problem chaning your password")));
        return "Error";
      });
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("There was a problem chaning your password")));
      return err;
    });
  }
}
