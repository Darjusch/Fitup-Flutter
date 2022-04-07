import 'dart:io';
import 'package:fitup/utils/video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BetVideoPicker extends StatefulWidget {
  final String docId;

  const BetVideoPicker({Key key, @required this.docId}) : super(key: key);

  @override
  State<BetVideoPicker> createState() => _BetVideoPickerState();
}

class _BetVideoPickerState extends State<BetVideoPicker> {
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
          title: const Text("Video Picker"),
        ),
        body: SizedBox(
            height: 800,
            child: filePath == null || filePath == ''
                ? Column(
                    children: [
                      const Icon(Icons.camera, size: 120),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                        VideoPlayerWidget(controller: videoController),
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
                            child: const Text("Upload Video"))
                      ],
                    ),
                  )));
  }
}
