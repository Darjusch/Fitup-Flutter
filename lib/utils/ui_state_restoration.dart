import 'package:shared_preferences/shared_preferences.dart';

class UiStateRestoration {
  static SharedPreferences _preferences;

  static const _currentRouteIndex = 'route';
  static const _betActionKey = 'action';
  static const _betDurationKey = 'duration';
  static const _betValueKey = 'value';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setRouteIndex(int index) async =>
      await _preferences.setInt(_currentRouteIndex, index);
  static int getRouteIndex() => _preferences.getInt(_currentRouteIndex);

  static Future setAction(String action) async =>
      await _preferences.setString(_betActionKey, action);
  static String getAction() => _preferences.getString(_betActionKey);

  static Future setDuration(int duration) async =>
      await _preferences.setInt(_betDurationKey, duration);
  static int getDuration() => _preferences.getInt(_betDurationKey);

  static Future setValue(int value) async =>
      await _preferences.setInt(_betValueKey, value);
  static int getValue() => _preferences.getInt(_betValueKey);
}
