import 'dart:io';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class BetImagePicker extends StatefulWidget {
  final String docId;

  const BetImagePicker({Key key, @required this.docId}) : super(key: key);

  @override
  State<BetImagePicker> createState() => _BetImagePickerState();
}

class _BetImagePickerState extends State<BetImagePicker> {
  /// Variables
  String filePath;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Container(
            child: filePath == null
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
                              filePath = path;
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
                              filePath = path;
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
                          File(filePath),
                          fit: BoxFit.cover,
                        ),
                        ElevatedButton(
                            onPressed: () => {
                              FirebaseHelper().uploadFile(filePath, widget.docId)
                            }, child: Text("Upload Image"))
                      ],
                    ),
                  )));
  }


}
