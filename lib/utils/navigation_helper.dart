
import 'package:flutter/material.dart';

import '../screens/single_bet_screen.dart';
import '../screens/image_picker_screen.dart';

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
}