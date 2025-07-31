import 'package:shared_preferences/shared_preferences.dart';

class MbxThemeService {
  static const String _isDarkModeKey = 'isDarkMode';

  /// Get saved theme mode from storage
  Future<bool> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isDarkModeKey) ?? false; // Default to light mode
    } catch (e) {
      print('Error getting theme mode: $e');
      return false; // Default to light mode on error
    }
  }

  /// Save theme mode to storage
  Future<void> saveThemeMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, isDarkMode);
      print('Theme mode saved: ${isDarkMode ? "Dark" : "Light"}');
    } catch (e) {
      print('Error saving theme mode: $e');
      rethrow;
    }
  }

  /// Clear theme preferences
  Future<void> clearThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isDarkModeKey);
      print('Theme preferences cleared');
    } catch (e) {
      print('Error clearing theme preferences: $e');
      rethrow;
    }
  }
}
