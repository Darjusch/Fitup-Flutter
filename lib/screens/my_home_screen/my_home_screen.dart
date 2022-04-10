import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  void initState() {
    super.initState();
    NotificationHelper.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationHelper.onNotifications.stream.listen((onClickedNotification));

  void onClickedNotification(String payload) {
    // TODO we cant click back button after this we are stuck on the same screen for 1 or 2 clicks. maybe delete old route or something
    debugPrint(payload);
    NavigationHelper().goToBetImagePickerScreen(payload, context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO what if we enter through pushnotifications?
    String userID = context.watch<User>().uid;
    Provider.of<BetProvider>(context, listen: false).loadInitalBets(userID);
    Provider.of<BetProvider>(context, listen: false).updateBetIsActive();
    return Scaffold(
      appBar: customAppBar(title: "Fit-up", context: context),
      body: SizedBox(
        height: double.infinity * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Hold yourself accountable by betting on your goals!",
                style: TextStyle(fontSize: 24)),
            const Divider(
              height: 200,
            ),
            OutlinedButton.icon(
              onPressed: () => {
                NavigationHelper().goToCreateBetScreen(context),
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Bet'),
            ),
          ],
        ),
      ),
    );
  }
}
