import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  double maxWidth = 1000;
  double maxHeight = 1000;

  /// Get from gallery or camera
  Future<String> getImageFrom(ImageSource source) async {
    try {
      XFile xfile = await ImagePicker().pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      return xfile.path;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
      return '';
    }
  }
}
