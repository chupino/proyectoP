import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeHandler with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  ThemeData get theme => _themeData;

  void toggleTheme() {
    final isDark = _themeData == ThemeData.dark();
    if (isDark) {
      _themeData = ThemeData.light();
    } else {
      _themeData = ThemeData.dark();
    }
    notifyListeners();
  }
}
