import 'package:flutter/material.dart';

class Themes {
  static ThemeData normalTheme = ThemeData(
    primaryColor: const Color(0xFF6665DD),
    colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8EF1D9),
        secondary: Color(0xFF9B9ECE),
        tertiary: Color(0xFFACADBC),
        inversePrimary: Color(0xFFE0E0E0)),
    scaffoldBackgroundColor: const Color(0xFF211E29),
    iconTheme: const IconThemeData(
      color: Color(0xFFE0E0E0),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Color(0xFFE0E0E0),
        ),
        labelSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: Color(0xFFE0E0E0),
        )),
  );

  static ThemeData adminTheme = ThemeData(
    primaryColor: const Color(0xFF6665DD),
    colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFE5D9F),
        secondary: Color(0xFF9B9B93),
        tertiary: Color(0xFF63B0CD),
        inversePrimary: Color(0xFFE0E0E0)),
    scaffoldBackgroundColor: const Color.fromARGB(255, 70, 62, 89),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE0E0E0),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Color(0xFFE0E0E0),
        ),
        labelSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: Color(0xFFE0E0E0),
        )),
  );
}
