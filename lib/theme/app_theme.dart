import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0A0A0F); // casi negro
  static const surface = Color(0xFF16121F); // tarjetas
  static const purple = Color(0xFF7B2CBF);
  static const blood = Color(0xFFB1121F);
  static const text = Color(0xFFEDE7F6);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        secondary: AppColors.blood,
        surface: AppColors.surface,
        onSurface: AppColors.text,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }
}
