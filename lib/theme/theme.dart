import 'package:flutter/material.dart';

class AppColors {
  // Light Theme
  static const Color lightBackground = Color(0xFFEDD4B2);
  static const Color lightCard = Color(0xFFFFF5E0);
  static const Color lightText = Color(0xFF3D2C1F);
  static const Color lightAccent = Color(0xFFFF6B35);
  static const Color lightAction = Color(0xFFFF6B35);

  // Dark Theme
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D232E);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkAccent = Color(0xFF00C9B1);
  static const Color darkAction = Color(0xFFFF6B35);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightAction,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.lightText)),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: AppColors.lightText),
    hintStyle: TextStyle(color: AppColors.lightText),
    errorStyle: TextStyle(color: Colors.redAccent),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightAction),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.lightAction,
    secondary: AppColors.lightAccent,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkAction,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.darkText)),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: AppColors.darkText),
    hintStyle: TextStyle(color: AppColors.darkText),
    errorStyle: TextStyle(color: Colors.redAccent),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkAccent),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkAction,
    secondary: AppColors.darkAccent,
  ),
);
