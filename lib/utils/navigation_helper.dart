
import 'package:flutter/material.dart';

import '../screens/bet_overview_screen/bet_overview_screen.dart';
import '../screens/create_bet_screen/create_bet_screen.dart';
import '../screens/single_bet_screen/single_bet_screen.dart';
import '../screens/image_picker_screen/image_picker_screen.dart';
import '../screens/signup_screen/signup_screen.dart';
import '../screens/signin_screen/sign_in_screen.dart';

class NavigationHelper {
  void goToBetImagePickerScreen(String docId, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            BetImagePicker(
              docId: docId,
            ),
      ),
    );
  }

  void goToSingleBetScreen(Map<String, dynamic> data, String docId, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          SingleBetScreen(
            docId: docId,
            data: data,
          ),
    ));
  }

  void goToCreateBetScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CreateBetScreen()));
  }

  void goToBetHistoryScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BetHistoryScreen()));
  }

  void goToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignUpScreen()));
  }
  void goToSignInScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignInScreen()));
  }
}