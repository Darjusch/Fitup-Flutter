import 'dart:io';
import 'package:fitup/models/bet_model.dart';
import 'package:fitup/controller/notifications_helper.dart';
import 'package:fitup/controller/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FirebaseApi {
  Future<String> createBet({BetModel bet, BuildContext context}) async {
    try {
      DocumentReference docID = await FirebaseFirestore.instance
          .collection('bets')
          .add(<String, dynamic>{
        "betID": bet.betID,
        "notificationID": bet.notificationID,
        "action": bet.action,
        "time": bet.time.format(context),
        "duration": bet.duration,
        "value": bet.value,
        "isActive": true,
        "startDate": bet.startDate,
        "success": null,
        "user_id": bet.userID,
        'files': bet.files,
      });
      return docID.id;
    } catch (err) {
      debugPrint("Error: $err");
      return "Error";
    }
  }
  // Upload File to Firestorage

  Future<String> uploadFile(
      String filePath, String betID, String fileType) async {
    if (filePath == null) return "Error";
    final fileName = basename(filePath);
    final destination = '$fileType/$betID';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(File(filePath));
      String imageUrl = await ref.getDownloadURL();
      saveURL(imageUrl, betID, fileType);

      return imageUrl;
    } catch (e) {
      debugPrint('error occured $e');
      return "Error";
    }
  }

  Future<String> uploadProfilePicFile(String filePath, String userID) async {
    if (filePath == null) return "Error";
    final fileName = basename(filePath);
    final destination = "profileImage/$userID";

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(File(filePath));
      String imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      debugPrint('error occured $e');
      return "Error";
    }
  }

  void saveURL(String fileUrl, String betID, String fileType) async {
    debugPrint(betID);
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day).toString();

    FirebaseFirestore.instance
        .collection('bets')
        .where('betID', isEqualTo: betID)
        .get()
        .then((value) {
          FirebaseFirestore.instance
              .collection('bets')
              .doc(value.docs.first.id)
              .update({
            'files': {date: fileUrl}
          });
        })
        .then((value) => debugPrint("ImageUrl updated"))
        .catchError((error) => debugPrint("Failed up update ImageUrl: $error"));
  }

  Stream<QuerySnapshot> getAllBetsStream(userID) {
    return FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getActiveBetsStream(userID) {
    return FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .where('isActive', isEqualTo: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getInactiveBetsStream(userID) {
    return FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .where('is_active', isEqualTo: false)
        .snapshots(includeMetadataChanges: true);
  }

  void updateBetActivityStatusAndCancelNotification(String userID) {
    Stream<QuerySnapshot> snap = getAllBetsStream(userID);
    snap.forEach((element) {
      for (var doc in element.docs) {
        debugPrint(
            "${TimeHelper().betIsLongerThanAHour(doc['duration'], doc['startDate'].toDate()) == true}");
        if (TimeHelper().betIsLongerThanAMinute(
                doc['duration'], doc['startDate'].toDate()) ==
            false) {
          FirebaseFirestore.instance
              .collection('bets')
              .doc(doc.id)
              .update({"isActive": false});
          NotificationHelper.cancel(doc['notificationID']);
        }
      }
    });
    return;
  }

  void updateBetSuccessStatus(String userID) {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      Stream<QuerySnapshot> snap = getInactiveBetsStream(userID);
      snap.forEach((element) {
        for (var doc in element.docs) {
          if (doc['isActive'] == false && doc['success'] == null) {
            if (doc['duration'] == doc['files'].entries.length) {
              batch.update(doc.reference, {"success": true});
            } else {
              batch.update(doc.reference, {"success": false});
            }
          }
        }
      });
      batch.commit().whenComplete(() => debugPrint("SUCCESS"));
    } catch (err) {
      debugPrint(err);
    }
  }

  Future<QuerySnapshot> getInitialBets(String userID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bets')
          .where('user_id', isEqualTo: userID)
          .get();
      return querySnapshot;
    } catch (err) {
      debugPrint(err);
    }
  }
}
