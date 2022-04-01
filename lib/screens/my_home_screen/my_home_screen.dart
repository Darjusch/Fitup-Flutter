import 'package:fitup/providers/AuthenticationService.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  void onClickedNotification(String payload) =>
      NavigationHelper().goToBetHistoryScreen(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fit-up"),
        actions: <Widget>[
          IconButton(
              onPressed: () => {
                    NavigationHelper().goToBetHistoryScreen(context),
                  },
              icon: const Icon(Icons.history)),
          IconButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
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
          ElevatedButton(
            onPressed: () => NotificationHelper.showNotification(
              title: 'Darjusch Schrand',
              body: 'It\'s time for your workout!',
              payload: 'Darjusch Schrand',
            ),
            child: const Text("Notification"),
          ),
          ElevatedButton(
            onPressed: () => NotificationHelper.showScheduledNotification(
                title: 'Darjusch Schrand',
                body: 'It\'s time for your scheduled 8 am workout!',
                payload: 'Darjusch Schrand',
                scheduledTime: const Time(11, 30)),
            child: const Text("Schedule 8 am Notification"),
          )
        ],
      ),
    );
  }
}
