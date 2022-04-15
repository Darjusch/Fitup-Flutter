import 'package:fitup/screens/my_home_screen/my_home_screen.dart';
import 'package:fitup/screens/upload_file_screen/upload_screen.dart';
import 'package:fitup/screens/video_picker_screen/video_picker_screen.dart';
import 'package:flutter/material.dart';

import '../screens/bet_overview_screen/bet_overview_screen.dart';
import '../screens/create_bet_screen/create_bet_screen.dart';
import '../screens/single_bet_screen/single_bet_screen.dart';
import '../screens/image_picker_screen/image_picker_screen.dart';
import '../screens/auth_screen/auth_screen.dart';

class NavigationHelper {
  void goToUploadFileScreen(String betID, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UploadFileScreen(betID: betID)));
  }

  void goToBetVideoPickerScreen(String betID, BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BetVideoPicker(betID: betID)));
  }

  void goToBetImagePickerScreen(String betID, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BetImagePicker(
          betID: betID,
        ),
      ),
    );
  }

  void goToSingleBetScreen(String betID, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SingleBetScreen(
        betID: betID,
      ),
    ));
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyHomeScreen()));
  }

  void goToCreateBetScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CreateBetScreen()));
  }

  void goToBetHistoryScreen(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const BetOverviewScreen()));
  }

  void goToAuthScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AuthScreen()));
  }
}
