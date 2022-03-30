import 'dart:io';
import 'package:fitup/utils/firebase_helper.dart';
import 'package:fitup/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
          title: const Text("Image Picker"),
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
                                await ImagePickerHelper().getImageFrom(ImageSource.gallery);
                            setState(() {
                              filePath = path;
                            });
                          },
                          child: const Text("PICK FROM GALLERY"),
                        ),
                        Container(
                          height: 40.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String path =
                                await ImagePickerHelper().getImageFrom(ImageSource.camera);
                            setState(() {
                              filePath = path;
                            });
                          },
                          child: const Text("PICK FROM CAMERA"),
                        )
                      ],
                    ),
                  )
                : SizedBox(
                    height: 300,
                    width: 300,
                    child: Column(
                      children: [
                        Image.file(
                          File(filePath),
                          fit: BoxFit.cover,
                        ),
                        ElevatedButton(
                            onPressed: () => {
                                  FirebaseHelper()
                                      .uploadFile(filePath, widget.docId)
                                },
                            child: const Text("Upload Image"))
                      ],
                    ),
                  )));
  }
}
