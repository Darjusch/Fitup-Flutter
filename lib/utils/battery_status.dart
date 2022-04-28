// Import package
import 'dart:io';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/foundation.dart';

class DeviceBatteryStatus {
  void getBatteryHealth() async {
    if (Platform.isAndroid) {
      // Access current battery health - Android
      debugPrint(
          "Battery Health: ${(await BatteryInfoPlugin().androidBatteryInfo).health}");
    } else if (Platform.isIOS) {
      // Access current battery level - IOS
      debugPrint(
          "Battery Level: ${(await BatteryInfoPlugin().iosBatteryInfo).batteryLevel}");
    }
  }
}
