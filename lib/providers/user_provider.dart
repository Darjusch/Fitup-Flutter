import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/apis/firebase_api.dart';
import 'package:fitup/controller/image_picker_helper.dart';
import 'package:fitup/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  UserModel currentUser;
  UserModel get user => currentUser;

  void signIn(User firebaseUser) {
    currentUser ??= UserModel(
      userID: firebaseUser.uid,
      profilePic: firebaseUser.photoURL,
      email: firebaseUser.email,
    );
  }

  void signOut() {
    // remove user
    currentUser = null;
    notifyListeners();
  }

  void updateProfilePic(String photoURL) {
    currentUser.profilePic = photoURL;
    notifyListeners();
  }

  void updateEmailAddress(String newEmail) {
    currentUser.email = newEmail;
    notifyListeners();
  }

  Future<String> uploadProfilePicFile(path, userID) async {
    String result =
        await FirebaseApi().uploadProfilePicFile(path, currentUser.userID);
    return result;
  }

  Future<String> selectImage() async {
    String path = await ImagePickerHelper()
                        .getImageFrom(ImageSource.gallery);
    return path;
  }
}
