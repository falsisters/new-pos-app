import 'package:shared_preferences/shared_preferences.dart';

class SecureCodeService {
  static const String _bypassKey = 'secure_code_bypass_until';

  /// Check if secure code bypass is currently active
  static Future<bool> isBypassActive() async {
    final prefs = await SharedPreferences.getInstance();
    final bypassUntilString = prefs.getString(_bypassKey);

    if (bypassUntilString == null) return false;

    final bypassUntil = DateTime.parse(bypassUntilString);
    final now = DateTime.now();

    if (now.isBefore(bypassUntil)) {
      return true;
    } else {
      // Bypass expired, remove it
      await clearBypass();
      return false;
    }
  }

  /// Set bypass for 6 hours from now
  static Future<void> setBypass() async {
    final prefs = await SharedPreferences.getInstance();
    final bypassUntil = DateTime.now().add(const Duration(hours: 6));
    await prefs.setString(_bypassKey, bypassUntil.toIso8601String());
  }

  /// Clear the bypass
  static Future<void> clearBypass() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bypassKey);
  }

  /// Get remaining bypass time in minutes
  static Future<int?> getRemainingBypassMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final bypassUntilString = prefs.getString(_bypassKey);

    if (bypassUntilString == null) return null;

    final bypassUntil = DateTime.parse(bypassUntilString);
    final now = DateTime.now();

    if (now.isBefore(bypassUntil)) {
      return bypassUntil.difference(now).inMinutes;
    }

    return null;
  }
}
