import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/time_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class BetOverviewScreen extends StatefulWidget {
  const BetOverviewScreen({Key key}) : super(key: key);

  @override
  State<BetOverviewScreen> createState() => _BetOverviewScreenState();
}

class _BetOverviewScreenState extends State<BetOverviewScreen> {
  Map<String, String> actionToIcon = {
    "Push-ups": "assets/icons/push-up.jpeg",
    "Make bed": "assets/icons/make-bed.png",
    "Wake up": "assets/icons/wake-up.png",
    "Shower": "assets/icons/shower.jpeg",
  };

  @override
  Widget build(BuildContext context) {
    // TODO only active bets
    final betsList = Provider.of<BetProvider>(context).bets;
    return Scaffold(
      appBar: customAppBar(title: "Bet overview", context: context),
      body: ListView.builder(
          itemCount: betsList.length,
          itemBuilder: (context, index) {
            final betItem = betsList[index];
            return ListTile(
              onTap: () {
                NavigationHelper().goToSingleBetScreen(betItem, context);
              },
              minLeadingWidth: 0,
              leading: SizedBox(
                height: 25,
                width: 25,
                child: ImageIcon(
                  AssetImage(actionToIcon[betItem.action]),
                ),
              ),
              // trailing: IconButton(
              //   iconSize: 40,
              //   icon: Icon(
              //     Icons.cloud_upload,
              //     color: Provider.of<BetProvider>(context, listen: false)
              //             .didUploadProofToday(betItem)
              //         ? Colors.grey
              //         : Colors.blue,
              //   ),
              //   onPressed: () =>
              //       Provider.of<BetProvider>(context, listen: false)
              //               .didUploadProofToday(betItem)
              //           ? {}
              //           : NavigationHelper()
              //               .goToUploadFileScreen(betItem.betID, context),
              // ),
              trailing: SpeedDial(
                buttonSize: const Size(40, 40),
                elevation: 0,
                direction: SpeedDialDirection.down,
                animatedIcon: AnimatedIcons.menu_arrow,
                backgroundColor: Colors.blue,
                overlayColor: Colors.black,
                overlayOpacity: 0.7,
                visible: Provider.of<BetProvider>(context, listen: false)
                        .didUploadProofToday(betItem)
                    ? false
                    : true,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.image),
                    backgroundColor: Colors.yellow,
                    label: 'Image Gallery',
                    onTap: () => {},
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.camera),
                    backgroundColor: Colors.green,
                    label: 'Image Camera',
                    onTap: () => {},
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.video_collection),
                    backgroundColor: Colors.orange,
                    label: 'Video Gallery',
                    onTap: () => {},
                  ),
                ],
              ),
              title: Text(betItem.action),
              subtitle: InkWell(
                key: const ValueKey('betDetails'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time: ${betItem.time.format(context)}"),
                    Text(
                        "Day: ${(betItem.duration - TimeHelper().betHasXDaysLeft(betItem.duration, betItem.startDate)) + 1} of ${betItem.duration}")
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
                NavigationHelper().goToCreateBetScreen(context),
              }),
    );
  }
}
