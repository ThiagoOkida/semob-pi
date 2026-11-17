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
  static const badBg = Color(0xFFFBE5E3);
  static const warn = Color(0xFF8A5A0A);
  static const warnBg = Color(0xFFFBF0DB);
  static const total = Color(0xFF1B2540);
  static const free = Color(0xFF3F6FCB);
  static const paid = Color(0xFF3A7D84);
  static const head = Color(0xFFEFF1F6);
  static const tvBg = Color(0xFF0D1836);
  static const tvCard = Color(0xFF16244A);
  static const tvLine = Color(0xFF2A3A6B);
}

/// Larguras de corte do layout responsivo.
class Bp {
  static const tablet = 700.0;
  static const desktop = 1100.0;
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