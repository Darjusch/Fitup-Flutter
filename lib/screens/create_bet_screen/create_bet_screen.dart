import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/navigation_helper.dart';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

import '../../utils/time_helper.dart';

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
      appBar: customAppBar(title: "Create Bet", context: context),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 320),
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
                TextButton(
                  onPressed: () async {
                    TimeOfDay newTime =
                        await TimeHelper().selectTime(context, _time);
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
                              fontSize: 17,
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
                ),
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
        onPressed: () async {
          var rng = Random();
          // TODO find a better way for creating the ID than random int

          int randomID = rng.nextInt(1000000);
          String betID = uuid.v4();
          debugPrint("BET TIME ${_time.hour} - ${_time.minute}");
          String docID = await FirebaseHelper().createBet(
            betID: betID,
            notificationID: randomID,
            now: DateTime.now(),
            context: context,
            dropdownActionValue: dropdownActionValue,
            time: _time,
            dropdownDurationValue: dropdownDurationValue,
            value: _value,
            userID: userID,
            files: {"initialized": "till we found a better approach"},
          );
          Provider.of<BetProvider>(context, listen: false).addBet(BetModel(
            betID: betID,
            notificationID: randomID,
            startDate: DateTime.now(),
            action: dropdownActionValue,
            time: _time,
            duration: dropdownDurationValue,
            value: _value,
            userID: userID,
            files: {},
          ));

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
                id: randomID,
                title: email.split('@').first,
                body: 'It\'s time for your scheduled $dropdownActionValue!',
                payload: betID,
                scheduledTime: Time(_time.hour, _time.minute));
          }
        },
        child: const Icon(Icons.add),
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
      height: 40.0,
      width: 90.0,
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
            contentPadding: const EdgeInsets.all(0.0),
            border: const OutlineInputBorder(),
            hintText: "$_value €"),
        textAlign: TextAlign.center,
      ),
    );
  }
}
