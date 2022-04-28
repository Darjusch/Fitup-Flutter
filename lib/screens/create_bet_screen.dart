import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitup/models/bet_model.dart';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/controller/notifications_helper.dart';
import 'package:fitup/utils/ui_state_restoration.dart';
import 'package:fitup/widgets/platform_aware/platform_datepicker.dart';
import 'package:fitup/widgets/platform_aware/platform_textField.dart';
import 'package:fitup/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

import '../controller/time_helper.dart';

class CreateBetScreen extends StatefulWidget {
  const CreateBetScreen({Key key}) : super(key: key);

  @override
  State<CreateBetScreen> createState() => _CreateBetScreenState();
}

class _CreateBetScreenState extends State<CreateBetScreen>
    with WidgetsBindingObserver {
  String dropdownActionValue;
  int dropdownDurationValue;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  int _value;
  var uuid = const Uuid();
  String userID;
  String email;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    dropdownActionValue = UiStateRestoration.getAction() ?? "Wake up";
    dropdownDurationValue = UiStateRestoration.getDuration() ?? 3;
    _value = UiStateRestoration.getValue() ?? 15;
    userID = Provider.of<User>(context, listen: false).uid;
    email = Provider.of<User>(context, listen: false).email;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      UiStateRestoration.setAction(dropdownActionValue);
      UiStateRestoration.setDuration(dropdownDurationValue);
      UiStateRestoration.setValue(_value);
    } else {
      debugPrint("FORGROUND!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            EdgeInsets.only(left: 50.w, right: 50.w, top: 20.h, bottom: 200.h),
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
                const Text("Bet Value"),
                valueInput(),
              ],
            ),
            SizedBox(
              height: 100.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Bet Time',
                  ),
                  SizedBox(
                      height: 100.h,
                      width: 200.h,
                      child: PlatformDatePicker(
                        onDateTimeChanged: (newTime) {
                          if (newTime != null) {
                            setState(() {
                              _time = TimeOfDay.fromDateTime(newTime);
                            });
                          }
                        },
                        onPressed: () async {
                          TimeOfDay newTime =
                              await TimeHelper().selectTime(context, _time);
                          setState(() {
                            if (newTime != null) {
                              _time = newTime;
                            }
                          });
                        },
                        selectedTime: _time,
                      ))
                ],
              ),
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

    String docID = await Provider.of<BetProvider>(context, listen: false)
        .addBet(bet, context);

    if (docID == "Error") {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
        "Something went wrong",
        true,
      ));
    } else {
      // Setting initial values again
      UiStateRestoration.setAction("Wake up");
      UiStateRestoration.setDuration(3);
      UiStateRestoration.setValue(15);
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
        child: PlatformTextField(
          textInputType: TextInputType.number,
          onSubmitted: (text) {
            try {
              // TODO How to disallow - , .

              _value = int.parse(text);
            } catch (err) {
              debugPrint(err.toString());
            }
          },
          text: "$_value €",
        ));
  }
}
