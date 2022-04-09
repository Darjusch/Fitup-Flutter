import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitup/models/bet_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BetProvider extends ChangeNotifier {
  var uuid = const Uuid();

  final List<BetModel> _bets = [];

  UnmodifiableListView<BetModel> get bets => UnmodifiableListView(_bets);

  List<BetModel> getBetsOfCurrentUser(String userID) {
    return _bets.where((element) => element.userID == userID).toList();
  }

  void addBet(BetModel bet) {
    _bets.add(bet);
    notifyListeners();
  }
  // BetModel getBet(String betID) {}
  // void updateBetIsActive() {} // OR WE LOOP THROUGH ALL BETS MAYBE BETTER
  // void updateBetIsSuccessful() {} // OR WE LOOP THROUGH ALL BETS MAYBE BETTER
  // return active bets
  // return inactive bets

  void updateBetImage(String betID, String imageUrl) {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day).toString();
    BetModel bet = _bets.firstWhere((element) => element.betID == betID);
    bet.files[date] = imageUrl;
    notifyListeners();
  }

  // TODO can be replaced with function above and made generic
  void updateBetVideo(String betID, String videoUrl) {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day).toString();
    BetModel bet = _bets.firstWhere((element) => element.betID == betID);
    bet.files[date] = videoUrl;
    notifyListeners();
  }

  // List<String> getVideosOfBet(String betID) {
  //   List<String> videos = [];
  //   BetModel bet = _bets.where((element) => element.betID == betID).first;
  //   bet.files.forEach((key, value) {
  //     if (value.contains("mp4")) {
  //       videos.add(value);
  //     }
  //   });
  //   return videos;
  // }

  // List<String> getImagesOfBet(String betID) {
  //   List<String> images = [];
  //   BetModel bet = _bets.where((element) => element.betID == betID).first;
  //   bet.files.forEach((key, value) {
  //     if (value.contains("jpg") ||
  //         value.contains("png") ||
  //         value.contains("jpeg")) {
  //       images.add(value);
  //     }
  //   });
  //   return images;
  // }

  void loadInitalBets(String userID) {
    FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // TODO ERRRORRR IS HERE since docImages and docVideos are empty when bet is created and we cant access the values
      for (var doc in querySnapshot.docs) {
        debugPrint(
            "BetID: ${doc['betID']}, Action: ${doc["action"]}, Duration: ${doc['duration']}, isActive: ${doc['isActive']}, notificationID: ${doc['notificationID']}, startDate: ${doc['startDate'].toDate()}, success: ${doc['success']}, time: ${TimeOfDay(hour: int.parse(doc['time'].split(":")[0]), minute: int.parse(doc['time'].split(":")[1]))}, user_id: ${doc['user_id']}, value: ${doc['value']}");
        for (var entry in doc['files'].entries) {
          debugPrint(entry.key);
          debugPrint(entry.value);
        }
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
          // images: doc['images'],
          // videos: doc['videos'],
        ));
      }
    });
  }
}
