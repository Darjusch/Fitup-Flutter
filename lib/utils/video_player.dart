import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoPlayerWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller != null && controller.value.isInitialized
        ? SizedBox(height: 200, width: 200, child: buildVideo())
        : const Icon(Icons.video_file, size: 120);
  }

  Widget buildVideo() => buildVideoPlayer();

  Widget buildVideoPlayer() => VideoPlayer(controller);
}
