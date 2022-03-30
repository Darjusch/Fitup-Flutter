
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

  bool betIsLongerThanADay(Map<String, dynamic> data) {
    return data['duration'] - (DateTime.now().difference(data['startDate'].toDate()).inDays) > 0;
  }
  int betHasXDaysLeft(Map<String, dynamic> data) {
    return data['duration'] - (DateTime.now().difference(data['startDate'].toDate()).inDays);
  }
  int betHasXHoursLeft(Map<String, dynamic> data) {
    return data['duration'] - (DateTime.now().difference(data['startDate'].toDate()).inHours);
  }
}