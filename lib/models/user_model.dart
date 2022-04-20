import 'package:flutter/material.dart';

class UserModel {
  final String userID;
  String profilePic;
  String email;

  UserModel({
    @required this.userID,
    this.profilePic,
    this.email,
  });
}
