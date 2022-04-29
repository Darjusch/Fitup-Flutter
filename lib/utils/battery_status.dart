// Import package
import 'dart:io';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:flutter/foundation.dart';

class DeviceBatteryStatus {
  Future<bool> isBatteryHealthOkay() async {
    if (Platform.isAndroid) {
      // Access current battery health - Android
      AndroidBatteryInfo androidBatteryInfo =
          await BatteryInfoPlugin().androidBatteryInfo;
      String health = androidBatteryInfo.health;
      debugPrint("Battery Health: $health");
      if (health == "health_okay" || health == "health_good") {
        return true;
      }
      return false;
    } else if (Platform.isIOS) {
      // Access current battery level - IOS
      debugPrint(
          "Battery Level: ${(await BatteryInfoPlugin().iosBatteryInfo).batteryLevel}");
      IosBatteryInfo iosBatteryInfo = await BatteryInfoPlugin().iosBatteryInfo;
      int health = iosBatteryInfo.batteryLevel;
      if (health > 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
