import 'package:fitup/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class SingleBetScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const SingleBetScreen({Key key, @required this.docId, @required this.data})
      : super(key: key);

  @override
  State<SingleBetScreen> createState() => _SingleBetScreenState();
}

class _SingleBetScreenState extends State<SingleBetScreen> {
  String fileType;
  String filePath;
  VideoPlayerController videoController;
  var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');

  @override
  void initState() {
    if (widget.data['videos'] != null) {
      videoController = VideoPlayerController.network(widget.data['videos'][0])
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) {
          videoController.setVolume(0.0);
          videoController.play();
        });
    }
    super.initState();
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
        title: const Text("Bet details"),
      ),
      body: SizedBox(
        height: 1000,
        width: 400,
        child: Column(
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child: Column(
                  children: [
                    Text("Action: ${widget.data['action']}"),
                    Text("Duration: ${widget.data['duration']}"),
                    Text("Time: ${widget.data['time']}"),
                    Text("Value: ${widget.data['value']}€"),
                    Text(
                        "StartDate: ${dateFormat.format(widget.data['startDate'].toDate())}"),
                    Text("isActive: ${widget.data['isActive']}"),
                    Text("success: ${widget.data['success']}"),
                  ],
                )),
            widget.data['images'] != null
                ? SizedBox(
                    height: 200,
                    width: 300,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      for (var image in widget.data['images'])
                        SizedBox(
                          height: 200,
                          width: 100,
                          child: Column(
                            children: [
                              Image.network(
                                "$image",
                                height: 150,
                                width: 100,
                              ),
                            ],
                          ),
                        )
                    ]))
                : const Text("No Images uploaded yet"),
            widget.data['videos'] != null
                ? SizedBox(
                    height: 150,
                    width: 300,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      // TODO how to make videoController dynamic so we can create this for each video maybe a list of controllers?
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: VideoPlayerWidget(controller: videoController))
                    ]))
                : const Text("No Videos uploaded yet"),
          ],
        ),
      ),
    );
  }

}
