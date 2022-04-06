import 'package:fitup/utils/video_player.dart';
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
    super.initState();
    if (widget.data['videos'] != null) {
      videoController = VideoPlayerController.network(widget.data['videos'][0])
        ..addListener(() => setState(() {}))
        ..initialize().then((_) => videoController.play());
    }
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
      body: Column(
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
          widget.data['images'] != null && widget.data['videos'] != null
              ? Center(
                  child: SizedBox(
                      height: 400,
                      width: 200,
                      child: ListView(children: [
                        for (var image in widget.data['images'])
                          Image.network(
                            "$image",
                            width: 100,
                            height: 100,
                          ),
                        SizedBox(
                            height: 200,
                            width: 100,
                            child:
                                VideoPlayerWidget(controller: videoController))
                      ])),
                )
              : const Text("No Files uploaded yet"),
        ],
      ),
    );
  }
}
