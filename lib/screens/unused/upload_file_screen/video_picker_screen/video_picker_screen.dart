import 'dart:io';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:fitup/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BetVideoPicker extends StatefulWidget {
  final String betID;

  const BetVideoPicker({Key key, @required this.betID}) : super(key: key);

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
        appBar: customAppBar(title: "Video picker screen", context: context),
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
                                  .uploadFile(filePath, widget.betID, fileType);
                              if (result != 'error') {
                                Provider.of<BetProvider>(context, listen: false)
                                    .updateBetFile(widget.betID, result);
                              }
                              final snackBar = SnackBar(
                                content: Text(
                                    result != 'error' ? "Success" : result),
                                backgroundColor: result != 'error'
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
