import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/firebase_helper.dart';
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
  bool overview = true;
  String userID;
  List<BetModel> activeBets = [];
  List<BetModel> inactiveBets = [];

  @override
  void initState() {
    userID = Provider.of<User>(context, listen: false).uid;

    FirebaseHelper().updateBetActivityStatusAndCancelNotification(userID);
    FirebaseHelper().updateBetSuccessStatus(userID);
    Provider.of<BetProvider>(context, listen: false).loadInitalBets(userID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO Bug bets are not shown with out clicking on overview or history
    // Probably the Provider doesnt have the bets at the point of time when the widget is build

    activeBets =
        Provider.of<BetProvider>(context, listen: false).getActiveBets();
    inactiveBets =
        Provider.of<BetProvider>(context, listen: false).getInactiveBets();
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
                betSelectOverviewButton(true, "Active Bets"),
                betSelectOverviewButton(false, "Bet History"),
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
                  return betInfoListTile(betItem);
                }),
          ),
        ],
      ),
    );
  }

  Widget betSelectOverviewButton(bool isOverview, String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          overview = isOverview;
        });
      },
      child: Text(title),
    );
  }

  Widget betInfoListTile(BetModel betItem) {
    return ListTile(
      tileColor: overview
          ? null
          : betItem.success
              ? Colors.green
              : Colors.red,
      onTap: () {
        NavigationHelper().goToSingleBetScreen(betItem.betID, context);
      },
      minLeadingWidth: 0,
      leading: SizedBox(
        height: 25.h,
        width: 25.w,
        child: ImageIcon(
          AssetImage(Provider.of<BetProvider>(context)
              .getIconOfAction(betItem.action)),
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
  }
}
