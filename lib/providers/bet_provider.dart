import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitup/models/bet_model.dart';
import 'package:fitup/controller/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BetProvider extends ChangeNotifier {
  var uuid = const Uuid();

  Map<String, String> actionToIcon = {
    "Push-ups": "assets/icons/push-up.jpeg",
    "Make bed": "assets/icons/make-bed.png",
    "Wake up": "assets/icons/wake-up.png",
    "Shower": "assets/icons/shower.jpeg",
  };

  List<String> actions = ["Push-ups", "Make bed", "Wake up", "Shower"];
  List<int> duration = [1, 2, 3, 4, 5, 6, 7];

  String getIconOfAction(String action) {
    if (actionToIcon.containsKey(action)) {
      return actionToIcon[action];
    }
    return "No Icon";
  }

  void addActionToIcon(String action, String icon) {
    actionToIcon[action] = icon;
  }

  final List<BetModel> _bets = [];

  UnmodifiableListView<BetModel> get bets => UnmodifiableListView(_bets);

  void addBet(BetModel bet) {
    _bets.add(bet);
    notifyListeners();
  }

  BetModel getBet(String betID) {
    BetModel bet = _bets.firstWhere((element) => element.betID == betID);
    return bet;
  }

  void removeAllBets() {
    _bets.clear();
  }

  void updateBetIsActive() {
    for (var bet in _bets) {
      if (TimeHelper().betIsLongerThanAMinute(bet.duration, bet.startDate) ==
          false) {
        bet.isActive = false;
      }
    }
  }

  // Current success check is to compare the amount of uploaded images/videos
  // to the duration of the bet if equal then success
  void updateBetIsSuccessful() {
    for (var bet in _bets) {
      if (bet.isActive == false && bet.success == null) {
        if (bet.duration == bet.files.entries.length) {
          bet.success = true;
        } else {
          bet.success = false;
        }
      }
    }
  }

  List<BetModel> getActiveBets() {
    List<BetModel> activeBets = [];
    for (var bet in _bets) {
      if (bet.isActive == true) {
        activeBets.add(bet);
      }
    }

    return activeBets;
  }

  List<BetModel> getInactiveBets() {
    List<BetModel> inactiveBets = [];
    for (var bet in _bets) {
      if (bet.isActive == false) {
        inactiveBets.add(bet);
      }
    }
    return inactiveBets;
  }

  bool didUploadProofToday(BetModel bet) {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day).toString();
    if (bet.files.keys.contains(date)) {
      return true;
    } else {
      return false;
    }
  }

  void updateBetFile(String betID, String fileUrl) {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day).toString();
    BetModel bet = _bets.firstWhere((element) => element.betID == betID);
    bet.files[date] = fileUrl;
    notifyListeners();
  }

  List<String> getVideosOfBet(BetModel bet) {
    List<String> videos = [];
    bet.files.forEach((key, value) {
      if (value.contains("mp4")) {
        videos.add(value);
      }
    });
    return videos;
  }

  List<String> getImagesOfBet(BetModel bet) {
    List<String> images = [];
    bet.files.forEach((key, value) {
      if (value.contains("jpg") ||
          value.contains("png") ||
          value.contains("jpeg")) {
        images.add(value);
      }
    });
    return images;
  }

  void loadInitalBets(String userID) {
    if (_bets.isNotEmpty) {
      return;
    }
    FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, String> files = Map<String, String>.from(doc['files']);
        _bets.add(BetModel(
          betID: doc['betID'],
          action: doc['action'],
          duration: doc['duration'],
          isActive: doc['isActive'],
          notificationID: doc['notificationID'],
          startDate: doc['startDate'].toDate(),
          success: doc['success'],
          time: TimeOfDay(
              hour: int.parse(doc['time'].split(":")[0]),
              minute: int.parse(doc['time'].split(":")[1])),
          userID: doc['user_id'],
          value: doc['value'],
          files: files,
        ));
      }
    });
  }
}
