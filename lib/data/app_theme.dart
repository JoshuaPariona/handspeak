import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      scaffoldBackgroundColor: AppColor.background,
      colorScheme: const ColorScheme.light(
        primary: AppColor.primary,
        onPrimary: AppColor.onPrimary,
        secondary: AppColor.secondary,
        onSecondary: AppColor.onSecondary,
        background: AppColor.background,
        onBackground: AppColor.onBackground,
        surface: AppColor.surface,
        onSurface: AppColor.onSurface,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColor.text),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColor.text),
        bodyLarge: TextStyle(fontSize: 16, color: AppColor.text),
        bodyMedium: TextStyle(fontSize: 14, color: AppColor.text),
      ),
      iconTheme: const IconThemeData(color: AppColor.text),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.onPrimary,
        elevation: 0,
      ),
    );
  }
}
