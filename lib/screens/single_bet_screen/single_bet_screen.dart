import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:fitup/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
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

  var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');
  List<String> videos = [];
  List<String> images = [];

  //List<VideoPlayerController> videoPlayerControllers = [];
  @override
  void initState() {
    // if (videos.isNotEmpty) {
    //   int n = 0;
    //   for (var video in videos) {
    //     VideoPlayerController  = setupVideo(video);
    //     videoPlayerControllers.add(videoPlayer);
    //   }
    // }

    super.initState();
  }

  // @override
  // void dispose() {
  //   if (videoPlayerControllers.isNotEmpty) {
  //     for (var element in videoPlayerControllers) {
  //       element.dispose();
  //     }
  //   }
  //   super.dispose();
  // }

  // VideoPlayerController setupVideo(String video) {
  //   VideoPlayerController videoController;
  //   videoController = VideoPlayerController.network(video)
  //     ..addListener(() => setState(() {}))
  //     ..setLooping(true)
  //     ..initialize().then((_) {
  //       videoController.setVolume(0.0);
  //       videoController.play();
  //     });
  //   return videoController;
  // }

  @override
  Widget build(BuildContext context) {
    BetModel bet = widget.bet;
    images =
        Provider.of<BetProvider>(context, listen: false).getImagesOfBet(bet);
    videos =
        Provider.of<BetProvider>(context, listen: false).getVideosOfBet(bet);
    Map<String, VideoPlayerController> videoPlayerControllers = {};
    var videoPlayers = <VideoPlayerWidget>[];
    for (var video in videos) {
      var videoPlayerController = VideoPlayerController.network(video);
      videoPlayerController.addListener(() => setState(() {}));
      videoPlayerController.setLooping(true);
      videoPlayerController.initialize().then((_) {
        videoPlayerController.setVolume(0.2);
        videoPlayerController.play();
        videoPlayerControllers.putIfAbsent(video, () => videoPlayerController);
        videoPlayers.add(VideoPlayerWidget(controller: videoPlayerController));
      });
    }
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
                // ? SizedBox(
                //     height: 300,
                //     width: 300,
                //     child: ListView.builder(
                //       itemCount: videos.length,
                //       itemBuilder: (context, index) {
                //         return SizedBox(
                //             height: 300,
                //             width: 300,
                //             child: VideoPlayerWidget(
                //                 controller: videoPlayerControllers[index]));
                //       },
                //     ),
                //   )
                ? SizedBox(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                        itemCount: videoPlayers.length,
                        itemBuilder: ((context, index) {
                          return videoPlayers[index];
                        })),
                  )
                : const Text("No Videos uploaded yet"),
          ],
        ),
      ),
      floatingActionButton: customSpeedDial(),
    );
  }

  Widget customSpeedDial() {
    return SpeedDial(
      direction: SpeedDialDirection.up,
      animatedIcon: AnimatedIcons.menu_arrow,
      backgroundColor: Provider.of<BetProvider>(context, listen: false)
              .didUploadProofToday(widget.bet)
          ? Colors.grey
          : Colors.blue,
      overlayColor: Colors.black,
      overlayOpacity: 0.7,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.image),
          backgroundColor: Colors.yellow,
          label: 'Image Gallery',
          onTap: () async {
            String path =
                await ImagePickerHelper().getImageFrom(ImageSource.gallery);
            // TODO upload doesn't rebuild widget to show newly uploaded image / video
            String result = await FirebaseHelper()
                .uploadFile(path, widget.bet.betID, 'images');
            setState(() {
              Provider.of<BetProvider>(context, listen: false)
                  .updateBetFile(widget.bet.betID, result);
              final snackBar = customSnackBar(result);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.camera),
          backgroundColor: Colors.green,
          label: 'Image Camera',
          onTap: () async {
            String path =
                await ImagePickerHelper().getImageFrom(ImageSource.camera);
            String result = await FirebaseHelper()
                .uploadFile(path, widget.bet.betID, 'images');

            setState(() {
              if (result != 'error') {
                Provider.of<BetProvider>(context, listen: false)
                    .updateBetFile(widget.bet.betID, result);
              }
              final snackBar = customSnackBar(result);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.video_collection),
          backgroundColor: Colors.orange,
          label: 'Video Gallery',
          onTap: () async {
            String path =
                await ImagePickerHelper().getVideoFrom(ImageSource.gallery);
            String result = await FirebaseHelper()
                .uploadFile(path, widget.bet.betID, 'videos');
            if (result != 'error') {
              Provider.of<BetProvider>(context, listen: false)
                  .updateBetFile(widget.bet.betID, result);
            }
            setState(() {
              final snackBar = customSnackBar(result);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          },
        ),
      ],
    );
  }

  Widget customSnackBar(String result) {
    return SnackBar(
      content: Text(result != 'error' ? "Success" : result),
      backgroundColor: result != 'error' ? Colors.green : Colors.red,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
}
