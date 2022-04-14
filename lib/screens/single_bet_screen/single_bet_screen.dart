import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
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

  var videoPlayers = <VideoPlayer>[];

  @override
  void initState() {
    BetModel bet = widget.bet;

    // videos =
    //     Provider.of<BetProvider>(context, listen: true).getVideosOfBet(bet);

    videos = [
      'https://firebasestorage.googleapis.com/v0/b/fitup-31ebf.appspot.com/o/videos%2F0ede8374-5fd2-4a3f-9779-9f817fafd2b5%2Fimage_picker7816311112605649560.mp4?alt=media&token=58e6361c-49c6-4a31-9494-4d54937f5c75',
      'https://firebasestorage.googleapis.com/v0/b/fitup-31ebf.appspot.com/o/videos%2F0ede8374-5fd2-4a3f-9779-9f817fafd2b5%2Fimage_picker7816311112605649560.mp4?alt=media&token=58e6361c-49c6-4a31-9494-4d54937f5c75',
      'https://firebasestorage.googleapis.com/v0/b/fitup-31ebf.appspot.com/o/videos%2F0ede8374-5fd2-4a3f-9779-9f817fafd2b5%2Fimage_picker7816311112605649560.mp4?alt=media&token=58e6361c-49c6-4a31-9494-4d54937f5c75'
    ];

    for (var video in videos) {
      var videoPlayerController = VideoPlayerController.network(
        video,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      VideoPlayer myVideo = VideoPlayer(videoPlayerController);
      myVideo.controller.initialize();
      myVideo.controller.addListener(() {
        setState(() {});
      });
      videoPlayers.add(myVideo);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var element in videoPlayers) {
      element.controller.dispose();
    }
    videoPlayers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Bet details", context: context),
      body: SizedBox(
        height: 1000,
        width: 400,
        child: Column(
          children: [
            videos != null && videos.isNotEmpty
                ? SizedBox(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                        itemCount: videoPlayers.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                              height: 200,
                              width: 200,
                              child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    videoPlayers[index],
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            videoPlayers[index]
                                                    .controller
                                                    .value
                                                    .isPlaying
                                                ? videoPlayers[index]
                                                    .controller
                                                    .pause()
                                                : videoPlayers[index]
                                                    .controller
                                                    .play();
                                          });
                                        },
                                        icon: Icon(
                                          videoPlayers[index]
                                                  .controller
                                                  .value
                                                  .isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ]));
                        }),
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
            NavigationHelper().goToSingleBetScreen(widget.bet, context);
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
