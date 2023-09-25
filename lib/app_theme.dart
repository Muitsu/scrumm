import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      chipTheme: ChipThemeData(
          backgroundColor: Colors.blue, disabledColor: Colors.grey.shade400),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black45),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue, foregroundColor: Colors.white));

  static final darkTheme = ThemeData(
      primarySwatch: Colors.red,
      primaryColor: Colors.black,
      // indicatorColor: const Color(0xff0E1D36),
      scaffoldBackgroundColor: const Color(0xff282b30),
      hintColor: const Color(0xff280C0B),
      // highlightColor: const Color(0xff372901),
      hoverColor: const Color(0xff3A3A3B),
      focusColor: const Color(0xff0B2512),
      disabledColor: Colors.grey,
      cardColor: const Color(0xFF151515),
      canvasColor: Colors.black,
      textTheme: Typography().white,
      brightness: Brightness.dark,
      drawerTheme: const DrawerThemeData()
          .copyWith(backgroundColor: const Color(0xFF1e2124)),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1e2124)),
      chipTheme: ChipThemeData(
          backgroundColor: Colors.blue, disabledColor: Colors.grey.shade400),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue, foregroundColor: Colors.white));
}

//-----------------------------------------------------------------------
class AppThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode {
    return themeMode == ThemeMode.dark;
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
