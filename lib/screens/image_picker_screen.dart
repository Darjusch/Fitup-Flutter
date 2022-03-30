import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: Text("PICK FROM GALLERY"),
                        ),
                        Container(
                          height: 40.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _getFromCamera();
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
        .update({"images": FieldValue.arrayUnion([imageUrl])})
        .then((value) => print("ImageUrl updated"))
        .catchError((error) => print("Failed up update ImageUrl: $error"));
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (xfile != null) {
      setState(() {
        file = File(xfile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile xfile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (xfile != null) {
      setState(() {
        file = File(xfile.path);
      });
    }
  }
}
