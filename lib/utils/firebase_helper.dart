import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/bet_overview_screen/bet_overview_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FirebaseHelper {
  void createBet(DateTime now, BuildContext context, String dropdownActionValue,
      TimeOfDay _time, int dropdownDurationValue, int _value) {
    try {
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
      debugPrint("Error: $err");
    }
  }
  // Upload Image to Firestorage

  Future uploadFile(String filePath, String docId) async {
    if (filePath == null) return;
    final fileName = basename(filePath);
    final destination = 'images/$docId';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(File(filePath));
      String imageUrl = await ref.getDownloadURL();
      saveImageURL(imageUrl, docId);
    } catch (e) {
      debugPrint('error occured $e');
    }
  }

  // Save imageUrl in Firestore
  void saveImageURL(String imageUrl, String docId) async {
    FirebaseFirestore.instance
        .collection('bets')
        .doc(docId)
        .update({
          "images": FieldValue.arrayUnion([imageUrl])
        })
        .then((value) => debugPrint("ImageUrl updated"))
        .catchError((error) => debugPrint("Failed up update ImageUrl: $error"));
  }

  Stream<QuerySnapshot> getBetsStream() {
    return FirebaseFirestore.instance
        .collection('bets')
        .snapshots(includeMetadataChanges: true);
  }
}
