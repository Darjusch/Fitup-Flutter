import 'dart:io';
import 'package:fitup/utils/video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BetImagePicker extends StatefulWidget {
  final String docId;

  const BetImagePicker({Key key, @required this.docId}) : super(key: key);

  @override
  State<BetImagePicker> createState() => _BetImagePickerState();
}

class _BetImagePickerState extends State<BetImagePicker> {
  String filePath;
  String fileType;
  VideoPlayerController videoController;

  void setupVideo() {
    videoController = VideoPlayerController.file(File(filePath))
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => videoController.play());
  }

  @override
  void dispose() {
    super.dispose();
    if (videoController != null) {
      videoController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker"),
        ),
        body: SizedBox(
            height: 800,
            child: filePath == null || filePath == ''
                ? Column(
                    children: [
                      const Icon(Icons.photo, size: 120),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              key: const ValueKey('galleryKey'),
                              onPressed: () async {
                                String path = await ImagePickerHelper()
                                    .getImageFrom(ImageSource.gallery);
                                setState(() {
                                  fileType = 'images';
                                  filePath = path;
                                });
                              },
                              child: const Text("PICK IMAGE FROM GALLERY"),
                            ),
                            Container(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              key: const ValueKey('cameraKey'),
                              onPressed: () async {
                                String path = await ImagePickerHelper()
                                    .getImageFrom(ImageSource.camera);
                                setState(() {
                                  fileType = 'images';
                                  filePath = path;
                                });
                              },
                              child: const Text("PICK IMAGE FROM CAMERA"),
                            ),
                            Container(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              key: const ValueKey('videoKey'),
                              onPressed: () async {
                                String path = await ImagePickerHelper()
                                    .getVideoFrom(ImageSource.gallery);
                                setState(() {
                                  fileType = 'videos';
                                  filePath = path;
                                  setupVideo();
                                });
                              },
                              child: const Text("PICK VIDEO FROM GALLERY"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        fileType == 'Image'
                            ? Image.file(
                                File(filePath),
                                fit: BoxFit.scaleDown,
                                height: 300,
                                width: 300,
                              )
                            : VideoPlayerWidget(controller: videoController),
                        ElevatedButton(
                            key: const ValueKey('uploadKey'),
                            onPressed: () async {
                              String result = await FirebaseHelper()
                                  .uploadFile(filePath, widget.docId, fileType);
                              final snackBar = SnackBar(
                                content: Text(result),
                                backgroundColor: result == "Success"
                                    ? Colors.green
                                    : Colors.red,
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text("Upload Image / Video"))
                      ],
                    ),
                  )));
  }
}
