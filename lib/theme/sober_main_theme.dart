import 'package:flutter/material.dart';

// Define your custom theme in this file
  ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFa3c7e8),
      secondary: const Color(0xFFa8e6cf),
      tertiary: const Color(0xFFffd166),
    ),
    primaryColor: const Color(0xFFa3c7e8),
    primaryColorLight: const Color(0xFFa8e6cf),
    hintColor: const Color(0xFFffd166),
    scaffoldBackgroundColor: const Color(0xFFf2f2f2),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFa3c7e8),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
    ),
  );
}