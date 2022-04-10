import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BetOverviewScreen extends StatefulWidget {
  const BetOverviewScreen({Key key}) : super(key: key);

  @override
  State<BetOverviewScreen> createState() => _BetOverviewScreenState();
}

class _BetOverviewScreenState extends State<BetOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final betsList = Provider.of<BetProvider>(context).bets;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bet overview"),
        ),
        body: ListView.builder(
            itemCount: betsList.length,
            itemBuilder: (context, index) {
              final betItem = betsList[index];
              return ListTile(
                onTap: () {
                  NavigationHelper().goToSingleBetScreen(betItem, context);
                },
                trailing: IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () => NavigationHelper()
                      .goToUploadFileScreen(betItem.betID, context),
                ),
                title: Text(betItem.action),
                subtitle: InkWell(
                  key: const ValueKey('betDetails'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time: ${betItem.time}"),
                      TimeHelper().betIsLongerThanADay(
                              betItem.duration, betItem.startDate)
                          ? Text(
                              "Time left: ${TimeHelper().betHasXDaysLeft(betItem.duration, betItem.startDate)} days")
                          : Text(
                              "Time left: ${TimeHelper().betHasXHoursLeft(betItem.duration, betItem.startDate)} hours"),
                    ],
                  ),
                ),
              );
            }));
  }
}
