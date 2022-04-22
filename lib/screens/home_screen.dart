import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    debugPrint(payload);
    NavigationHelper().goToSingleBetScreen(payload, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity.h,
      width: double.infinity.w,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/background.jpeg"))),
      child: Padding(
        padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w, top: 170.0.h),
        child: Text("Hold yourself accountable by betting on your goals!",
            style: TextStyle(fontSize: 34.sp, color: Colors.white)),
      ),
    );
  }
}
