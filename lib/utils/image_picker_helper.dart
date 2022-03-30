import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  double maxWidth = 1000;
  double maxHeight = 1000;

  /// Get from gallery
  Future<String> getFromGallery() async {
    XFile xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return xfile.path;
  }

  /// Get from Camera
  Future<String> getFromCamera() async {
    XFile xfile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return xfile.path;
  }
}
