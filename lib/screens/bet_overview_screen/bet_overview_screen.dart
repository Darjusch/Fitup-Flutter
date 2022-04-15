import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/time_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
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
    final betsList = Provider.of<BetProvider>(context).getActiveBets();
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
