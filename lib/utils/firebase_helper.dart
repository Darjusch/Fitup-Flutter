import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FirebaseHelper {
  Future<String> createBet(
      DateTime now,
      BuildContext context,
      String dropdownActionValue,
      TimeOfDay _time,
      int dropdownDurationValue,
      int _value,
      String userID) async {
    try {
      DocumentReference docID = await FirebaseFirestore.instance
          .collection('bets')
          .add(<String, dynamic>{
        "action": dropdownActionValue,
        "time": _time.format(context),
        "duration": dropdownDurationValue,
        "value": _value,
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

  Stream<QuerySnapshot> getBetsStream(BuildContext context, userID) {
    return FirebaseFirestore.instance
        .collection('bets')
        .where('user_id', isEqualTo: userID)
        .snapshots(includeMetadataChanges: true);
  }
}
