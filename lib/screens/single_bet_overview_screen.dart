import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/apis/firebase_api.dart';
import 'package:fitup/controller/image_picker_helper.dart';
import 'package:fitup/controller/time_helper.dart';
import 'package:fitup/utils/battery_status.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:fitup/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class SingleBetScreen extends StatefulWidget {
  final String betID;
  const SingleBetScreen({Key key, @required this.betID}) : super(key: key);

  @override
  State<SingleBetScreen> createState() => _SingleBetScreenState();
}

class _SingleBetScreenState extends State<SingleBetScreen> {
  String fileType;
  String filePath;
  BetModel bet;

  // TODO conditional according to challenge show Images / Video / Challenge
  // TODO progress indicator when uploading video

  List<String> videos = [];
  List<String> images = [];

  var videoPlayers = <VideoPlayer>[];

  @override
  void initState() {
    bet = Provider.of<BetProvider>(context, listen: false).getBet(widget.betID);
    DeviceBatteryStatus().getBatteryHealth();
    // Here we can now check if battery level is to low that we dont load videos or only 1 or something like that
    // Maybe also not allow to record or upload video 
    // Or only select image / video from gallery instead of camera 
    bet.files.forEach((key, value) {
      if (value.contains("mp4")) {
        videos.add(value);
      }
    });
    // videos = [
    //   'https://firebasestorage.googleapis.com/v0/b/fitup-31ebf.appspot.com/o/videos%2F0ede8374-5fd2-4a3f-9779-9f817fafd2b5%2Fimage_picker7816311112605649560.mp4?alt=media&token=58e6361c-49c6-4a31-9494-4d54937f5c75',
    //   'https://firebasestorage.googleapis.com/v0/b/fitup-31ebf.appspot.com/o/videos%2F0ede8374-5fd2-4a3f-9779-9f817fafd2b5%2Fimage_picker7816311112605649560.mp4?alt=media&token=58e6361c-49c6-4a31-9494-4d54937f5c75',
    //   'https://firebasestorage.googleapis.com/v0/b/fitup-31ebf.appspot.com/o/videos%2F0ede8374-5fd2-4a3f-9779-9f817fafd2b5%2Fimage_picker7816311112605649560.mp4?alt=media&token=58e6361c-49c6-4a31-9494-4d54937f5c75'
    // ];

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
    videos =
        Provider.of<BetProvider>(context, listen: true).getVideosOfBet(bet);
    return Scaffold(
      appBar: customAppBar(title: "Bet details", context: context),
      body: SizedBox(
        height: 1000.h,
        width: double.infinity.w,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 18.0.h, left: 18.0.w, right: 18.0.w),
              child: infoCard(bet, context),
            ),
            videos != null && videos.isNotEmpty
                ? SizedBox(
                    height: 315.h,
                    width: double.infinity.w,
                    child: ListView.builder(
                        itemCount: videoPlayers.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return customVideoPlayer(index);
                        }),
                  )
                : Padding(
                    padding: EdgeInsets.all(18.0.h),
                    child: Text(
                      "No Videos uploaded yet",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: customSpeedDial(),
    );
  }

  Widget customVideoPlayer(int index) {
    return SizedBox(
      height: 320.h,
      width: 250.w,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 8.0.h, left: 8.0.w, right: 8.0.w, bottom: 8.0.h),
            child: Text(
              "Day ${index + 1}",
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(
            height: 270.h,
            width: 240.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0.h),
                  color: Colors.black),
              child: Stack(alignment: AlignmentDirectional.center, children: [
                SizedBox(
                    height: 270.h, width: 200.w, child: videoPlayers[index]),
                SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        videoPlayers[index].controller.value.isPlaying
                            ? videoPlayers[index].controller.pause()
                            : videoPlayers[index].controller.play();
                      });
                    },
                    icon: Icon(
                      videoPlayers[index].controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 75.h,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: 5.h,
            width: 200.w,
            child: VideoProgressIndicator(
              videoPlayers[index].controller,
              allowScrubbing: true,
              padding: const EdgeInsets.only(top: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget customSpeedDial() {
    return SpeedDial(
      direction: SpeedDialDirection.up,
      animatedIcon: AnimatedIcons.menu_arrow,
      backgroundColor: Provider.of<BetProvider>(context, listen: false)
              .didUploadProofToday(bet)
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
            String result =
                await FirebaseApi().uploadFile(path, bet.betID, 'videos');
            if (result != 'error') {
              Provider.of<BetProvider>(context, listen: false)
                  .updateBetFile(bet.betID, result);
            }
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  result == 'error'
                      ? 'There was a problem uploading the video!'
                      : "Successfully uploaded the video!",
                  result == 'error' ? true : false));
            });
            Navigator.of(context).pop();

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SingleBetScreen(
                betID: bet.betID,
              ),
            ));
          },
        ),
      ],
    );
  }
}

Widget infoCard(BetModel bet, BuildContext context) {
  var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');

  return Container(
    padding: EdgeInsets.all(25.0.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            offset: const Offset(0, 10),
            blurRadius: 0,
            spreadRadius: 0,
          )
        ],
        gradient: const RadialGradient(
          colors: [Colors.blueAccent, Colors.blue],
          focal: Alignment.topCenter,
          radius: .85,
        )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bet.action,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold),
            ),
            RichText(
                text: TextSpan(
              text:
                  "Day: ${(bet.duration - TimeHelper().betHasXDaysLeft(bet.duration, bet.startDate)) + 1} of ${bet.duration}",
              style: TextStyle(
                  color: Colors.white.withOpacity(.75), fontSize: 14.sp),
            )),
          ],
        ),
        RichText(
            text: TextSpan(
          text: "Startdate: ${dateFormat.format(bet.startDate)}",
          style:
              TextStyle(color: Colors.white.withOpacity(.75), fontSize: 14.sp),
        )),
        SizedBox(height: 10.h),
        RichText(
            text: TextSpan(
          text:
              "Status: ${bet.isActive ? "Ongoing" : bet.success ? "Success" : "Failed"}",
          style:
              TextStyle(color: Colors.white.withOpacity(.75), fontSize: 14.sp),
        )),
        SizedBox(height: 10.h),
        RichText(
            text: TextSpan(
          text:
              "Uploaded Today: ${Provider.of<BetProvider>(context, listen: false).didUploadProofToday(bet) ? "Yes" : "No"}",
          style:
              TextStyle(color: Colors.white.withOpacity(.75), fontSize: 14.sp),
        )),
        SizedBox(height: 10.h),
        RichText(
            text: TextSpan(
          text: "Value ${bet.value.toString()}\$",
          style:
              TextStyle(color: Colors.white.withOpacity(.75), fontSize: 14.sp),
        )),
      ],
    ),
  );
}
