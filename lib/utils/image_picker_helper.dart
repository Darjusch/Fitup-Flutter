import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  double maxWidth = 1000;
  double maxHeight = 1000;

  /// Get image from gallery or camera
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

  // Get video from gallery or camera
  // TODO show warning that video can not be longer than 5 min
  Future<String> getVideoFrom(ImageSource source) async {
    try {
      XFile xfile = await ImagePicker().pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      if (xfile.path == null) {
        return '';
      }
      return xfile.path;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick video: $e');
      return '';
    }
  }
}
