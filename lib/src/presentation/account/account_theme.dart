import 'package:flutter/material.dart';

/// Shared palette for dark account / auth screens.
abstract final class AccountThemeColors {
  static const Color background = Color(0xFF101438);
  static const Color muted = Color(0xFFA9AEC1);
  static const Color inputBackground = Color(0xFF1A2049);
  static const Color accent = Color(0xFFFF9E0F);
  static const Color gradientStart = Color(0xFFFFBB5C);
  static const String logoUrl =
      'https://lucidengine.ai/wp-content/uploads/2024/02/le-powered-logo.png';
}

InputDecoration accountInputDecoration({
  required String hint,
  String? errorText,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AccountThemeColors.muted),
    errorText: errorText,
    filled: true,
    fillColor: AccountThemeColors.inputBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AccountThemeColors.accent, width: 1.2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
  );
}

ThemeData accountScreenTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AccountThemeColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AccountThemeColors.accent,
      surface: AccountThemeColors.background,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AccountThemeColors.accent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: AccountThemeColors.accent, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
