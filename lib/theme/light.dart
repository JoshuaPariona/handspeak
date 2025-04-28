import 'package:flutter/material.dart';
import 'package:handspeak/data/colors_dimensions.dart';

final ThemeData handspeakLightTheme= ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColor.primary,
    onPrimary: AppColor.onPrimary,
    secondary: AppColor.secondary,
    onSecondary: AppColor.onSecondary,
    surface: AppColor.surface,
    onSurface: AppColor.onSurface,
    error: AppColor.accent,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColor.background,
  cardColor: AppColor.surface,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: AppDimensions.text.extraSmall,
      fontWeight: FontWeight.bold,
      color: AppColor.text,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColor.text),
    bodyMedium: TextStyle(fontSize: 14, color: AppColor.text),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColor.text,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.primary,
    foregroundColor: AppColor.onPrimary,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  ),
  cardTheme: CardTheme(
    color: AppColor.surface,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.all(8),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColor.surface,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColor.text,
    ),
    contentTextStyle: const TextStyle(fontSize: 16, color: AppColor.text),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);
