import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel currentUser;
  UserModel get user => currentUser;

  void signIn(User firebaseUser) {
    // init user
    currentUser = UserModel(
      user_ID: firebaseUser.uid,
      profile_pic: firebaseUser.photoURL,
      email: firebaseUser.email,
    );
  }

  void signOut() {
    // remove user
    currentUser = null;
    notifyListeners();
  }

  void updateProfilePic(String photoURL) {
    currentUser.profile_pic = photoURL;
    notifyListeners();
  }

  void updateEmailAddress(String newEmail) {
    currentUser.email = newEmail;
    notifyListeners();
  }
}
