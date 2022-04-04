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

  bool betIsLongerThanADay(int duration, DateTime startDate) {
    return duration - (DateTime.now().difference(startDate).inDays) > 0;
  }

  bool betIsLongerThanAHour(int duration, DateTime startDate) {
    return (duration * 24) - (DateTime.now().difference(startDate).inHours) > 0;
  }
  int betHasXDaysLeft(int duration, DateTime startDate) {
    return duration - (DateTime.now().difference(startDate).inDays);
  }

  int betHasXHoursLeft(int duration, DateTime startDate) {
    return (duration * 24) - (DateTime.now().difference(startDate).inHours);
  }

  int betHasXMinutesLeft(int duration, DateTime startDate) {
    return ((duration * 24) * 60) - (DateTime.now().difference(startDate).inMinutes);
  }
}
