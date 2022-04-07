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

class BetProvider extends ChangeNotifier {
  List<Bet> bets = [];

  List<Bet> get getAllBets {
    return bets;
  }

  int getNumberOfbets() {
    return bets.length;
  }

  void addBet(Bet bet) {
    debugPrint("BETS LENGTH: ${bets.length}");
    bets.add(bet);
    debugPrint("added BET");
    debugPrint("BETS LENGTH NOW: ${bets.length}");
    notifyListeners();
  }

  // Bet getBet() {} for this we need to add a ID into Bet

  // void updateBet() {} for this we need to add a ID into Bet

}
