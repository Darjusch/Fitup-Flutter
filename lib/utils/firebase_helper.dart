import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/bet_overview_screen/bet_overview_screen.dart';

class FirebaseHelper {
  void createBet(DateTime now, BuildContext context, String dropdownActionValue,
      TimeOfDay _time, int dropdownDurationValue, int _value) {
    try {
      print(
          " Action ${dropdownActionValue}\n Time ${_time.format(context)}\n Duration ${dropdownDurationValue}\n Value ${_value}€");
      FirebaseFirestore.instance.collection('bets').add(<String, dynamic>{
        "action": dropdownActionValue,
        "time": _time.format(context),
        "duration": dropdownDurationValue,
        "value": _value,
        "isActive": true,
        "startDate": now,
        "success": null,
      }).then((value) => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const BetHistoryScreen(),
              ),
            )
          });
    } catch (err) {
      print("Error: $err");
    }
  }

  Stream<QuerySnapshot> getBetsStream() {
    return FirebaseFirestore.instance
        .collection('bets')
        .snapshots(includeMetadataChanges: true);
  }

}
