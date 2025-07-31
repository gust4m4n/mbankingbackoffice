import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MbxThemeController extends GetxController {
  static const String _isDarkModeKey = 'isDarkMode';

  final RxBool _isDarkMode = false.obs;
  final RxString _currentThemeColor = ''.obs;

  bool get isDarkMode => _isDarkMode.value;
  RxBool get isDarkModeRx => _isDarkMode;
  String get currentThemeColor => _currentThemeColor.value;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool(_isDarkModeKey) ?? false;
    _isDarkMode.value = savedTheme;
    print('🎨 Theme loaded: ${_isDarkMode.value ? "Dark" : "Light"} mode');
  }

  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, _isDarkMode.value);

    // Update app theme
    Get.changeThemeMode(themeMode);

    print('🎨 Theme switched to: ${_isDarkMode.value ? "Dark" : "Light"} mode');
  }

  void setDarkMode(bool isDark) async {
    _isDarkMode.value = isDark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);

    // Update app theme
    Get.changeThemeMode(themeMode);

    print('🎨 Theme set to: ${isDark ? "Dark" : "Light"} mode');
  }

  // Method to trigger rebuild when theme color changes
  void notifyThemeColorChanged([String? hexColor]) {
    if (hexColor != null) {
      _currentThemeColor.value = hexColor;
    }
    print('🎨 Theme color changed to: ${hexColor ?? "unknown"}');
  }
}
