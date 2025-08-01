import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../preferences/mbx_preferences_vm_users.dart';

class MbxLanguageController extends GetxController {
  final _currentLanguage = 'id'.obs;
  final _currentLocale = const Locale('id').obs;

  String get currentLanguage => _currentLanguage.value;
  Locale get currentLocale => _currentLocale.value;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  // Load saved language from preferences
  Future<void> loadSavedLanguage() async {
    final savedLanguage = await MbxUserPreferencesVM.getLanguage();
    _currentLanguage.value = savedLanguage;
    _currentLocale.value = Locale(savedLanguage);

    // Update GetX locale
    Get.updateLocale(Locale(savedLanguage));
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != _currentLanguage.value) {
      _currentLanguage.value = languageCode;
      _currentLocale.value = Locale(languageCode);

      // Save to preferences
      await MbxUserPreferencesVM.setLanguage(languageCode);

      // Update GetX locale
      Get.updateLocale(Locale(languageCode));

      // Dismiss the language selection screen
      Get.back();
    }
  }

  // Get current language name
  String getCurrentLanguageName() {
    return MbxUserPreferencesVM.getLanguageName(_currentLanguage.value);
  }

  // Get current language flag
  String getCurrentLanguageFlag() {
    return MbxUserPreferencesVM.getLanguageFlag(_currentLanguage.value);
  }

  // Check if language is selected
  bool isLanguageSelected(String languageCode) {
    return _currentLanguage.value == languageCode;
  }
}
