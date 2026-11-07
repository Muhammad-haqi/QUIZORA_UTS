import 'package:flutter/material.dart';

/// Tema Light dan Dark untuk QUIZORA. Seluruh halaman memakai ThemeData ini,
/// sehingga warna otomatis berubah ketika mode tema diganti.
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Poppins';

  // Warna latar belakang halaman.
  static const Color _lightBackground = Color(0xFFF5F3FF);
  static const Color _darkBackground = Color(0xFF12142B);

  static const ColorScheme _lightScheme = ColorScheme.light(
    primary: Color(0xFF6D4AFF),
    onPrimary: Colors.white,
    secondary: Color(0xFFFFC53D),
    onSecondary: Color(0xFF2B2150),
    surface: Colors.white,
    onSurface: Color(0xFF1F1B3A),
    error: Color(0xFFE5484D),
    onError: Colors.white,
  );

  static const ColorScheme _darkScheme = ColorScheme.dark(
    primary: Color(0xFF9A7BFF),
    onPrimary: Color(0xFF140E33),
    secondary: Color(0xFFFFC53D),
    onSecondary: Color(0xFF2B2150),
    surface: Color(0xFF1F2349),
    onSurface: Colors.white,
    error: Color(0xFFFF6B70),
    onError: Color(0xFF2B0A0C),
  );

  static ThemeData get lightTheme => _build(_lightScheme, _lightBackground);

  static ThemeData get darkTheme => _build(_darkScheme, _darkBackground);

  static ThemeData _build(ColorScheme scheme, Color background) {
    OutlineInputBorder border(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.onSurface.withAlpha(14),
        border: border(Colors.transparent, 0),
        enabledBorder: border(scheme.onSurface.withAlpha(30), 1),
        focusedBorder: border(scheme.primary, 2),
        errorBorder: border(scheme.error, 1.5),
        focusedErrorBorder: border(scheme.error, 2),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
