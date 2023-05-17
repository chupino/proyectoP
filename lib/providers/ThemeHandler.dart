import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHandler with ChangeNotifier {
  final myThemeLight = ThemeData(
    
    inputDecorationTheme: InputDecorationTheme(
      iconColor: Colors.black,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 5),
    borderRadius: BorderRadius.all(Radius.circular(50))
    
  ),
  labelStyle: TextStyle(color: Colors.black),
  floatingLabelStyle: TextStyle(color: Colors.black,),
  hoverColor: Color(0xFFdd3333),
  focusColor: Color(0xFFdd3333),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 5),
  ),
  fillColor: Colors.white,
  filled: true,
),
    cardColor: Color(0xFF006414),
    cardTheme: CardTheme(),
    iconTheme: IconThemeData(color: Color(0xFF000000)),
    appBarTheme: AppBarTheme(
        color: Color(0xFF7ad03a),
        actionsIconTheme: IconThemeData(color: Color(0xFFdd3333))),
    primaryColor: Color(0xFF7ad03a),
    primaryColorDark: Color(0xFF7ad03a),
    accentColor: Color(0xFF003400),
    backgroundColor: Color(0xFF003400),
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    //iconTheme: IconThemeData(color: Color(0xFFdd3333)),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch:  MaterialColor(0xFFdd3333, {
        50: Color(0xFFf4d7d7),
        100: Color(0xFFe3a3a3),
        200: Color(0xFFd37070),
        300: Color(0xFFc03c3c),
        400: Color(0xFFb31a1a),
        500: Color(0xFFa60000),
        600: Color(0xFF9d0000),
        700: Color(0xFF930000),
        800: Color(0xFF8a0000),
        900: Color(0xFF790000),
      }), // este color se usa para los botones de navegación
    ),
    canvasColor: Color(0xFF98ff96),
    hoverColor: Color(0xFFdd3333),
    primaryColorLight: Colors.white,
    hintColor: Colors.black,
    drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white,
        //scrimColor: Colors.black,
        shadowColor: Color(0xFF7ad03a)),
  );
  final myThemeDark = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xFF009929),
        filled: true,
        iconColor: Colors.red,
        hintStyle: TextStyle(color: Colors.white)),
    iconTheme: IconThemeData(color: Color(0xFFdd3333)),
    dividerColor: Colors.white,
    cardColor: Color(0xFF006414),
    drawerTheme: DrawerThemeData(
        backgroundColor: Color(0xFF04040E),
        //scrimColor: Colors.white,
        shadowColor: Color(0xFF006414)),
    appBarTheme: AppBarTheme(
        color: Color(0xFF003400),
        actionsIconTheme: IconThemeData(color: Colors.green)),
    primaryColor: Color(0xFF003400),
    primaryColorDark: Color(0xFF006414),
    scaffoldBackgroundColor: Color(0xFF04040E),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(0xFFdd3333, {
        50: Color(0xFFf4d7d7),
        100: Color(0xFFe3a3a3),
        200: Color(0xFFd37070),
        300: Color(0xFFc03c3c),
        400: Color(0xFFb31a1a),
        500: Color(0xFFa60000),
        600: Color(0xFF9d0000),
        700: Color(0xFF930000),
        800: Color(0xFF8a0000),
        900: Color(0xFF790000),
      }),
      // este color se usa para los botones de navegación
    ),
    canvasColor: Color(0xFF08081B),
    hoverColor: Color(0xFFdd3333),
    primaryColorLight: Colors.white,
    hintColor: Colors.black,
    textTheme: TextTheme(
      // Cambia el color del texto del cuerpo a blanco
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
  );
  late ThemeData _themeData = myThemeDark;
  bool dark = false;

  ThemeData get theme => _themeData;

  ThemeHandler() {
    loadTheme();
  }
  void updateTheme(ThemeData newTheme) {
    _themeData = newTheme;
    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("darkMode") == true) {
      _themeData = myThemeDark;
      dark = true;
    } else {
      _themeData = myThemeLight;
      dark = false;
    }

    notifyListeners();
  }

  void toggleTheme() async {
    final isDark = _themeData == myThemeDark;
    print("++++++++++Oscuro: $isDark");
    if (isDark) {
      _themeData = myThemeLight;

      dark = false;
    } else {
      _themeData = myThemeDark;
      dark = true;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", dark);
    notifyListeners();
  }
}
