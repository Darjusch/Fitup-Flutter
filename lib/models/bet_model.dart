import 'package:flutter/material.dart';

class BetModel {
  final String betID;
  final String action;
  final int duration;
  final bool isActive;
  final int notificationID;
  final DateTime startDate;
  final bool success;
  final TimeOfDay time;
  final String userID;
  final int value;
  final List<String> videos;
  final List<String> images;

  BetModel({
    @required this.betID,
    @required this.action,
    @required this.duration,
    this.isActive = true,
    @required this.notificationID,
    @required this.startDate,
    this.success,
    @required this.time,
    @required this.userID,
    @required this.value,
    @required this.videos,
    @required this.images,
  });
}
