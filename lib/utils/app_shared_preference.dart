import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(bool value) async {
    await _preferences?.setBool('isLoggedIn', value);
  }

  static bool getLoggedIn() {
    return _preferences?.getBool('isLoggedIn') ?? false;
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
