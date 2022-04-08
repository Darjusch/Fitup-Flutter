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

  void updateBetImage(String betID, String imageUrl) {
    BetModel bet = _bets.firstWhere((element) => element.betID == betID);
    bet.images.add(imageUrl);
    notifyListeners();
  }

  void updateBetVideo(String betID, String videoUrl) {
    BetModel bet = _bets.firstWhere((element) => element.betID == betID);
    bet.videos.add(videoUrl);
    notifyListeners();
  }

  void loadInitalBets(String userID) {
    FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
          // TODO ERRRORRR IS HERE 
      for (var doc in querySnapshot.docs) {
        String betID = uuid.v4();

        // debugPrint(
        //     "${doc["action"]}, ${doc['duration']}, ${doc['isActive']} ${doc['notificationID']} ${doc['startDate'].toDate()} ${doc['success']} ${TimeOfDay(hour: int.parse(doc['time'].split(":")[0]), minute: int.parse(doc['time'].split(":")[1]))} ${doc['user_id']} ${doc['value']}");
        addBet(BetModel(
          betID: betID,
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
          images: doc['images'],
          videos: doc['videos'],
        ));
      }
    });
  }

  // Bet getBet() {} for this we need to add a ID into Bet

  // void updateBet() {} for this we need to add a ID into Bet

  // return active bets

  // return inactive bets
}
