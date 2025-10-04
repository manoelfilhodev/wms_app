import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Nunito",
    scaffoldBackgroundColor: const Color(0xFFFAFBFE), // fundo Hyper
    primaryColor: const Color(0xFF727CF5), // indigo Hyper
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFBFE),
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCED4DA)),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF727CF5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF727CF5),
        side: const BorderSide(color: Color(0xFF727CF5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF343A40)),
      bodyMedium: TextStyle(color: Color(0xFF838C96)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Nunito",
    scaffoldBackgroundColor: const Color(0xFF343A40),
    primaryColor: const Color(0xFF727CF5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF343A40),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF404954),
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF727CF5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF727CF5),
        side: const BorderSide(color: Color(0xFF727CF5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE3EAEF)),
      bodyMedium: TextStyle(color: Color(0xFFAAB8C5)),
    ),
  );
}
