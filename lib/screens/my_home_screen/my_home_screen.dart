import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/notifications_helper.dart';
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
    NavigationHelper().goToSingleBetScreen(payload, context);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/background.jpeg"))),
      child: const Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 170.0),
        child: Text("Hold yourself accountable by betting on your goals!",
            style: TextStyle(fontSize: 34, color: Colors.white)),
      ),
    );
  }
}
