import 'package:flutter/material.dart';

class UserModel {
  final String user_ID;
  String profile_pic;
  String email;

  UserModel({
    @required this.user_ID,
    this.profile_pic,
    this.email,
  });
}
