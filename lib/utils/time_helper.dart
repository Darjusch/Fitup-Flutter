
import 'package:flutter/material.dart';

class TimeHelper {
  Future<TimeOfDay> selectTime(BuildContext context, TimeOfDay _time) async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    return newTime;
  }
}