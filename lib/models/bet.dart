import 'package:flutter/material.dart';

class Bet {
  final int notificationID;
  final DateTime now;
  final BuildContext context;
  final String dropdownActionValue;
  final TimeOfDay time;
  final int dropdownDurationValue;
  final int value;
  final String userID;

  Bet({
    @required this.notificationID,
    @required this.now,
    @required this.context,
    @required this.dropdownActionValue,
    @required this.time,
    @required this.dropdownDurationValue,
    @required this.value,
    @required this.userID,
  });

  
}
