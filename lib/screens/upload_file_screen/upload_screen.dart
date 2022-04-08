import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatefulWidget {
  final String betID;

  const UploadFileScreen({Key key, @required this.betID}) : super(key: key);

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

// TODO RESTRICT FOR THE BET TO UPLOAD ONLY 1 IMAGE OR VIDEO FOR THAT DAY
class _UploadFileScreenState extends State<UploadFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select File-type"),
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,
          child: Column(
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    NavigationHelper()
                        .goToBetImagePickerScreen(widget.betID, context);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Image")),
              ElevatedButton.icon(
                  onPressed: () {
                    NavigationHelper()
                        .goToBetVideoPickerScreen(widget.betID, context);
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Video"))
            ],
          ),
        ),
      ),
    );
  }
}
