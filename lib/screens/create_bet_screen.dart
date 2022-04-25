import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/apis/firebase_api.dart';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:fitup/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

import '../utils/time_helper.dart';

class CreateBetScreen extends StatefulWidget {
  const CreateBetScreen({Key key}) : super(key: key);

  @override
  State<CreateBetScreen> createState() => _CreateBetScreenState();
}

class _CreateBetScreenState extends State<CreateBetScreen> {
  String dropdownActionValue = "Wake up";
  int dropdownDurationValue = 3;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  int _value = 15;
  var uuid = const Uuid();
  String userID;
  String email;

  @override
  void initState() {
    userID = Provider.of<User>(context, listen: false).uid;
    email = Provider.of<User>(context, listen: false).email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            EdgeInsets.only(left: 50.w, right: 50.w, top: 20.h, bottom: 320.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Bet Action"),
                actionValueDropdown(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Bet Duration"),
                durationDropdown(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Bet Time',
                ),
                timePicker(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Bet Value"),
                valueInput(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createBetAndScheduleNotification();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void createBetAndScheduleNotification() async {
    var rng = Random();
    int randomID = rng.nextInt(1000000);
    String betID = uuid.v4();
    debugPrint("BET TIME ${_time.hour} - ${_time.minute}");
    BetModel bet = BetModel(
      betID: betID,
      notificationID: randomID,
      startDate: DateTime.now(),
      action: dropdownActionValue,
      time: _time,
      duration: dropdownDurationValue,
      value: _value,
      userID: userID,
      files: {"initialized": "till we found a better approach"},
    );
    String docID = await FirebaseApi().createBet(
      bet: bet,
      context: context,
    );
    Provider.of<BetProvider>(context, listen: false).addBet(bet);

    if (docID == "Error") {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
        "Something went wrong",
        true,
      ));
    } else {
      NotificationHelper.showScheduledNotification(
          id: randomID,
          title: email.split('@').first,
          body: 'It\'s time for your scheduled $dropdownActionValue!',
          payload: betID,
          scheduledTime: Time(_time.hour, _time.minute));

      ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
        "Bet created successfully",
        false,
      ));
    }
  }

  Widget actionValueDropdown() {
    return DropdownButton(
      value: dropdownActionValue,
      icon: const Icon(Icons.arrow_downward),
      items: Provider.of<BetProvider>(context)
          .actions
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          dropdownActionValue = newValue;
        });
      },
    );
  }

  Widget timePicker() {
    return TextButton(
      onPressed: () async {
        TimeOfDay newTime = await TimeHelper().selectTime(context, _time);
        setState(() {
          if (newTime != null) {
            _time = newTime;
          }
        });
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Row(
        children: [
          Text(_time.format(context),
              style: TextStyle(
                  fontSize: 17.sp,
                  decoration: TextDecoration.underline,
                  color: (Colors.grey[700]),
                  decorationThickness: 0.5,
                  decorationColor: (Colors.grey[500]))),
          Icon(
            Icons.arrow_downward,
            color: (Colors.grey[700]),
          )
        ],
      ),
    );
  }

  Widget durationDropdown() {
    return DropdownButton<int>(
      value: dropdownDurationValue,
      icon: const Icon(Icons.arrow_downward),
      items: Provider.of<BetProvider>(context)
          .duration
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text("$value days"),
        );
      }).toList(),
      onChanged: (int newValue) {
        setState(() {
          dropdownDurationValue = newValue;
        });
      },
    );
  }

  Widget valueInput() {
    return SizedBox(
      height: 40.0.h,
      width: 90.0.w,
      child: TextField(
        key: const ValueKey('betValueField'),
        onSubmitted: (text) {
          try {
            // TODO How to disallow - , .
            // TODO this doesn't work yet 
            // Check this maybe https://stackoverflow.com/questions/49577781/how-to-create-number-input-field-in-flutter
            final numeric = RegExp(r'^[0-9]+$');
            if (numeric.hasMatch(text)) {
              debugPrint("MATCH");
              _value = int.parse(text);
            } else {
              debugPrint("NO MATCH");
            }
          } catch (err) {
            debugPrint(err);
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          border: const OutlineInputBorder(),
          hintText: "$_value €",
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
