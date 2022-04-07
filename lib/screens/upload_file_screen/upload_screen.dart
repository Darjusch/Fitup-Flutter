import 'package:fitup/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatefulWidget {
  final String docId;

  const UploadFileScreen({Key key, @required this.docId}) : super(key: key);

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

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
                        .goToBetImagePickerScreen(widget.docId, context);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Image")),
              ElevatedButton.icon(
                  onPressed: () {
                    NavigationHelper()
                        .goToBetVideoPickerScreen(widget.docId, context);
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