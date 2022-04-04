import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../../utils/time_helper.dart';

class CreateBetScreen extends StatefulWidget {
  const CreateBetScreen({Key key}) : super(key: key);

  @override
  State<CreateBetScreen> createState() => _CreateBetScreenState();
}

class _CreateBetScreenState extends State<CreateBetScreen> {
  String dropdownActionValue = "Push-ups";
  int dropdownDurationValue = 1;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  int _value = 0;

// TODO Remove notification when the bet is over

  @override
  Widget build(BuildContext context) {
    String userID = context.watch<User>().uid;
    String email = context.watch<User>().email;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Bet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay newTime =
                        await TimeHelper().selectTime(context, _time);
                    setState(() {
                      if (newTime != null) {
                        _time = newTime;
                      }
                    });
                  },
                  child: const Text('SELECT TIME'),
                ),
                const SizedBox(height: 8),
                // TODO when pressing cancle this thing breaks
                Text(
                  'Selected time: ${_time.format(context)}',
                ),
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
                const Text("Bet Value"),
                valueInput(),
              ],
            ),
            Text("Current user ${context.watch<User>().uid}"),
            FloatingActionButton(
              onPressed: () async {
                debugPrint("BET TIME ${_time.hour} - ${_time.minute}");
                String docID = await FirebaseHelper().createBet(
                  DateTime.now(),
                  context,
                  dropdownActionValue,
                  _time,
                  dropdownDurationValue,
                  _value,
                  userID,
                );
                if (docID == "Error") {
                  final snackBar = SnackBar(
                    content: const Text("Error"),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  NavigationHelper().goToBetHistoryScreen(context);
                  NotificationHelper.showScheduledNotification(
                      title: email.split('@').first,
                      body:
                          'It\'s time for your scheduled $dropdownActionValue!',
                      payload: docID,
                      scheduledTime: Time(_time.hour, _time.minute));
                }
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  Widget actionValueDropdown() {
    return DropdownButton(
      value: dropdownActionValue,
      icon: const Icon(Icons.arrow_downward),
      items: <String>["Push-ups", "Make bed", "Wake up", "Shower"]
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

  Widget durationDropdown() {
    return DropdownButton<int>(
      value: dropdownDurationValue,
      icon: const Icon(Icons.arrow_downward),
      items: <int>[1, 2, 3, 4, 5, 6, 7].map<DropdownMenuItem<int>>((int value) {
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
      height: 50.0,
      width: 100.0,
      child: TextField(
        key: const ValueKey('betValueField'),
        onSubmitted: (text) => {
          // TODO How to disallow - , .
          _value = int.parse(text),
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            border: const OutlineInputBorder(), hintText: "$_value €"),
      ),
    );
  }
}
