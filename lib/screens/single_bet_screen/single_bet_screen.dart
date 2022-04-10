import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:fitup/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class SingleBetScreen extends StatefulWidget {
  final BetModel bet;

  const SingleBetScreen({Key key, @required this.bet}) : super(key: key);

  @override
  State<SingleBetScreen> createState() => _SingleBetScreenState();
}

class _SingleBetScreenState extends State<SingleBetScreen> {
  String fileType;
  String filePath;
  VideoPlayerController videoController;
  var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');
  List<String> videos = [];
  List<String> images = [];

  @override
  void initState() {
    if (videos.isNotEmpty) {
      videoController = VideoPlayerController.network(videos[0])
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
    BetModel bet = widget.bet;
    images =
        Provider.of<BetProvider>(context, listen: false).getImagesOfBet(bet);
    videos =
        Provider.of<BetProvider>(context, listen: false).getVideosOfBet(bet);

    return Scaffold(
              appBar: customAppBar(title: "Bet details", context: context),

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
                    Text("Action: ${widget.bet.action}"),
                    Text("Duration: ${widget.bet.duration}"),
                    Text("Time: ${widget.bet.time}"),
                    Text("Value: ${widget.bet.value}€"),
                    Text(
                        "StartDate: ${dateFormat.format(widget.bet.startDate)}"),
                    Text("isActive: ${widget.bet.isActive}"),
                    Text("success: ${widget.bet.success}"),
                  ],
                )),
            images != null
                ? SizedBox(
                    height: 200,
                    width: 300,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      for (var image in images)
                        SizedBox(
                          height: 200,
                          width: 100,
                          child: Column(
                            children: [
                              Image.network(
                                image,
                                height: 150,
                                width: 100,
                              ),
                            ],
                          ),
                        )
                    ]))
                : const Text("No Images uploaded yet"),
            videos != null
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
