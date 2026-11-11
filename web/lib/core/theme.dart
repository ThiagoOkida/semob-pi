import 'package:flutter/material.dart';

/// Cores estimadas dos prints. Ajustar com os hex do Inspect do Figma.
class AppColors {
  static const sidebar = Color(0xFF27468F);
  static const bg = Color(0xFFF5F6FA);
  static const ink = Color(0xFF151F3D);
  static const muted = Color(0xFF5B6478);
  static const line = Color(0xFFE2E5EC);
  static const ok = Color(0xFF1F6B4A);
  static const okBg = Color(0xFFE4F2EA);
  static const bad = Color(0xFFB3261E);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.sidebar, primary: AppColors.sidebar),
    scaffoldBackgroundColor: AppColors.bg,
  );
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: c, width: w),
      );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border(AppColors.line),
      enabledBorder: border(AppColors.line),
      focusedBorder: border(AppColors.sidebar, 1.5),
      errorBorder: border(AppColors.bad),
      focusedErrorBorder: border(AppColors.bad, 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.sidebar,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}