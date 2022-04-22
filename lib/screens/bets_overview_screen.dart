import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool overview = true;

  @override
  Widget build(BuildContext context) {
    String userID = context.watch<User>().uid;

    Provider.of<BetProvider>(context, listen: false).loadInitalBets(userID);
    Provider.of<BetProvider>(context, listen: false).updateBetIsActive();
    Provider.of<BetProvider>(context, listen: false).updateBetIsSuccessful();
    final activeBets = Provider.of<BetProvider>(context).getActiveBets();
    final inactiveBets = Provider.of<BetProvider>(context).getInactiveBets();

    return SizedBox(
      height: 1000.h,
      width: double.infinity.w,
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
            width: double.infinity.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      overview = true;
                    });
                  },
                  child: const Text("Active Bets"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      overview = false;
                    });
                  },
                  child: const Text("Bet History"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 550.h,
            width: double.infinity.w,
            child: ListView.builder(
                itemCount: overview ? activeBets.length : inactiveBets.length,
                itemBuilder: (context, index) {
                  final betItem =
                      overview ? activeBets[index] : inactiveBets[index];
                  return ListTile(
                    tileColor: overview
                        ? null
                        : betItem.success
                            ? Colors.green
                            : Colors.red,
                    onTap: () {
                      NavigationHelper()
                          .goToSingleBetScreen(betItem.betID, context);
                    },
                    minLeadingWidth: 0,
                    leading: SizedBox(
                      height: 25.h,
                      width: 25.w,
                      child: ImageIcon(
                        AssetImage(actionToIcon[betItem.action]),
                      ),
                    ),
                    title: Text(betItem.action),
                    subtitle: InkWell(
                      key: const ValueKey('betDetails'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Time: ${betItem.time.format(context)}"),
                          overview
                              ? Text(
                                  "Day: ${(betItem.duration - TimeHelper().betHasXDaysLeft(betItem.duration, betItem.startDate)) + 1} of ${betItem.duration}")
                              : Text(betItem.success ? 'Success' : 'Failed')
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}