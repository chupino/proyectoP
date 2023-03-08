import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHandler with ChangeNotifier {
  late ThemeData _themeData = ThemeData.light();
  bool dark = false;

  ThemeData get theme => _themeData;

  ThemeHandler() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("darkMode") == true) {
      _themeData = ThemeData.dark();
      dark = true;
    } else {
      _themeData = ThemeData.light();
      dark = false;
    }

    notifyListeners();
  }

  void toggleTheme() async {
    final isDark = _themeData == ThemeData.dark();
    if (isDark) {
      _themeData = ThemeData.light();
      dark = false;
    } else {
      _themeData = ThemeData.dark();
      dark = true;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", dark);
  }
}
