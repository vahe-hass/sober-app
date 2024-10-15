import 'package:flutter/material.dart';

// Define your custom theme in this file
ThemeData appTheme() {
  return ThemeData(
    primaryColor: Color(0xFFa3c7e8),
    hintColor: Color(0xFFa8e6cf),
    scaffoldBackgroundColor: Color(0xFFf2f2f2),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFf2f2f2)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFa3c7e8)), // Focus color matching primary color
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFa3c7e8),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
    ),
  );
}


