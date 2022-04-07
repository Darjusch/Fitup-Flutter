
import 'package:fitup/screens/my_home_screen/my_home_screen.dart';
import 'package:fitup/screens/video_picker_screen/video_picker_screen.dart';
import 'package:flutter/material.dart';

import '../screens/bet_overview_screen/bet_overview_screen.dart';
import '../screens/create_bet_screen/create_bet_screen.dart';
import '../screens/single_bet_screen/single_bet_screen.dart';
import '../screens/image_picker_screen/image_picker_screen.dart';
import '../screens/auth_screen/auth_screen.dart';

class NavigationHelper {

  void goToBetVideoPickerScreen(String docId, BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BetVideoPicker(docId: docId)));
  }

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

  void goToHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyHomeScreen()));
  }

  void goToCreateBetScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CreateBetScreen()));
  }

  void goToBetHistoryScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BetHistoryScreen()));
  }

  void goToAuthScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AuthScreen()));
  }
}