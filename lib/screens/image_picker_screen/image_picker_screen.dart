import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class BetImagePicker extends StatefulWidget {
  final String docId;

  const BetImagePicker({Key key, @required this.docId}) : super(key: key);

  @override
  State<BetImagePicker> createState() => _BetImagePickerState();
}

class _BetImagePickerState extends State<BetImagePicker> {
  /// Variables
  File file;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Container(
            child: file == null
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            String path =
                                await ImagePickerHelper().getFromGallery();
                            setState(() {
                              file = File(path);
                            });
                          },
                          child: Text("PICK FROM GALLERY"),
                        ),
                        Container(
                          height: 40.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String path =
                                await ImagePickerHelper().getFromCamera();
                            setState(() {
                              file = File(path);
                            });
                          },
                          child: Text("PICK FROM CAMERA"),
                        )
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      children: [
                        Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                        ElevatedButton(
                            onPressed: uploadFile, child: Text("Upload Image"))
                      ],
                    ),
                  )));
  }

  // Upload Image to Firestorage

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file.path);
    final destination = 'images/${widget.docId}';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(file);
      String imageUrl = await ref.getDownloadURL();
      saveImageURL(imageUrl);
    } catch (e) {
      print('error occured $e');
    }
  }

  // Save imageUrl in Firestore
  void saveImageURL(imageUrl) async {
    print(widget.docId);
    FirebaseFirestore.instance
        .collection('bets')
        .doc(widget.docId)
        .update({
          "images": FieldValue.arrayUnion([imageUrl])
        })
        .then((value) => print("ImageUrl updated"))
        .catchError((error) => print("Failed up update ImageUrl: $error"));
  }
}
