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
  bool overview = true;

  @override
  Widget build(BuildContext context) {
    final activeBets = Provider.of<BetProvider>(context).getActiveBets();
    final inactiveBets = Provider.of<BetProvider>(context).getInactiveBets();
    return Scaffold(
      appBar: customAppBar(title: "Bet overview", context: context),
      body: SizedBox(
        height: 1000,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
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
              height: 650,
              width: double.infinity,
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
                            overview
                                ? Text(
                                    "Day: ${(betItem.duration - TimeHelper().betHasXDaysLeft(betItem.duration, betItem.startDate)) + 1} of ${betItem.duration}")
                                : Text("Success: ${betItem.success}")
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
                NavigationHelper().goToCreateBetScreen(context),
              }),
    );
  }
}
