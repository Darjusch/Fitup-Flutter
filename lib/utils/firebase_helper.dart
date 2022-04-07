import 'dart:io';
import 'package:fitup/utils/notifications_helper.dart';
import 'package:fitup/utils/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FirebaseHelper {
  Future<String> createBet(
      {int notificationID,
      DateTime now,
      BuildContext context,
      String dropdownActionValue,
      TimeOfDay time,
      int dropdownDurationValue,
      int value,
      String userID}) async {
    try {
      DocumentReference docID = await FirebaseFirestore.instance
          .collection('bets')
          .add(<String, dynamic>{
        "notificationID": notificationID,
        "action": dropdownActionValue,
        "time": time.format(context),
        "duration": dropdownDurationValue,
        "value": value,
        "isActive": true,
        "startDate": now,
        "success": null,
        "user_id": userID,
      });
      return docID.id;
    } catch (err) {
      debugPrint("Error: $err");
      return "Error";
    }
  }
  // Upload Image to Firestorage

  Future<String> uploadFile(
      String filePath, String docId, String fileType) async {
    if (filePath == null) return "Error";
    final fileName = basename(filePath);
    final destination = '$fileType/$docId';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(File(filePath));
      String imageUrl = await ref.getDownloadURL();
      saveURL(imageUrl, docId, fileType);

      return "Success";
    } catch (e) {
      debugPrint('error occured $e');
      return "Error";
    }
  }

  // Save Url in Firestore
  void saveURL(String imageUrl, String docId, String fileType) async {
    FirebaseFirestore.instance
        .collection('bets')
        .doc(docId)
        .update({
          fileType: FieldValue.arrayUnion([imageUrl])
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

  void updateBetActivityStatus(String userID) {
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
}
