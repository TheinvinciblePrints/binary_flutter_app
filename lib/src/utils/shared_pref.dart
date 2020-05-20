import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  saveSelectedOption(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future readSelectedOption(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) != null) {
      return prefs.getString(key);
    } else {
      return 'none';
    }
  }
}
