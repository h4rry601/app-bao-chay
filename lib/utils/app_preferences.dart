import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyTermsAccepted = 'terms_accepted';

  static Future<bool> getTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTermsAccepted) ?? false;
  }

  static Future<void> setTermsAccepted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTermsAccepted, value);
  }
}
