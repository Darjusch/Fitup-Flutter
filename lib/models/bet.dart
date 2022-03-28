import 'package:flutter/material.dart';

class Bet {
  final String action;
  final TimeOfDay time;
  final String duration;
  final int value;

  Bet({
    required this.action,
    required this.time,
    required this.duration,
    required this.value,
  });
}
