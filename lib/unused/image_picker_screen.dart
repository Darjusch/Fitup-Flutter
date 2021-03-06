import 'dart:io';
import 'package:fitup/providers/bet_provider.dart';
import 'package:fitup/apis/firebase_api.dart';
import 'package:fitup/controller/image_picker_helper.dart';
import 'package:fitup/widgets/app_bar_widget.dart';
import 'package:fitup/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BetImagePicker extends StatefulWidget {
  final String betID;

  const BetImagePicker({Key key, @required this.betID}) : super(key: key);

  @override
  State<BetImagePicker> createState() => _BetImagePickerState();
}

class _BetImagePickerState extends State<BetImagePicker> {
  String filePath;
  String fileType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(title: "Image Picker Screen", context: context),
        body: SizedBox(
            height: 800,
            child: filePath == null || filePath == ''
                ? Column(
                    children: [
                      const Icon(Icons.photo, size: 120),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              key: const ValueKey('galleryKey'),
                              onPressed: () async {
                                String path = await ImagePickerHelper()
                                    .getImageFrom(ImageSource.gallery);
                                setState(() {
                                  fileType = 'images';
                                  filePath = path;
                                });
                              },
                              child: const Text("PICK IMAGE FROM GALLERY"),
                            ),
                            Container(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              key: const ValueKey('cameraKey'),
                              onPressed: () async {
                                String path = await ImagePickerHelper()
                                    .getImageFrom(ImageSource.camera);
                                setState(() {
                                  fileType = 'images';
                                  filePath = path;
                                });
                              },
                              child: const Text("PICK IMAGE FROM CAMERA"),
                            ),
                            Container(
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        Image.file(
                          File(filePath),
                          fit: BoxFit.scaleDown,
                          height: 300,
                          width: 300,
                        ),
                        ElevatedButton(
                            key: const ValueKey('uploadKey'),
                            onPressed: () async {
                              String result = await FirebaseApi()
                                  .uploadFile(filePath, widget.betID, fileType);
                              if (result != 'error') {
                                Provider.of<BetProvider>(context, listen: false)
                                    .updateBetFile(widget.betID, result);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarWidget(
                                      result != 'error' ? "Success" : result,
                                      result == 'error' ? true : false));
                            },
                            child: const Text("Upload Image"))
                      ],
                    ),
                  )));
  }
}
