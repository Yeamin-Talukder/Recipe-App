import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

// ─── Light Theme ──────────────────────────────────────────────────────────────
ThemeData appTheme() {
  return _buildTheme(Brightness.light);
}

// ─── Dark Theme ───────────────────────────────────────────────────────────────
ThemeData darkTheme() {
  return _buildTheme(Brightness.dark);
}

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final Color background  = isDark ? const Color(0xFF0F1117) : kBackgroundColor;
  final Color surface     = isDark ? const Color(0xFF1C1F2E) : Colors.white;
  final Color card        = isDark ? const Color(0xFF252839) : Colors.white;
  final Color textPrimary = isDark ? const Color(0xFFF1F3F8) : kTextPrimary;
  final Color textSec     = isDark ? const Color(0xFF9AA5BB) : kTextSecondary;
  final Color textLight   = isDark ? const Color(0xFF6B7A96) : kTextLight;
  final Color divider     = isDark ? const Color(0xFF2E3348) : const Color(0xFFEEEEEE);

  final systemOverlay = isDark
      ? SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: const Color(0xFF0F1117),
          systemNavigationBarIconBrightness: Brightness.light,
        )
      : SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: background,
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: kPrimaryColor,
      onPrimary: Colors.white,
      secondary: kPrimaryLight,
      onSecondary: Colors.white,
      error: const Color(0xFFE53935),
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    ),
    cardColor: card,
    dividerColor: divider,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary),
      displayMedium: GoogleFonts.inter(
          fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary),
      titleLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
      titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      bodyLarge: GoogleFonts.inter(fontSize: 15, color: textPrimary),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: textSec),
      labelLarge: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
      labelSmall: GoogleFonts.inter(fontSize: 11, color: textLight),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      systemOverlayStyle: systemOverlay,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonRadius)),
        textStyle:
            GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kPrimaryColor;
        return isDark ? const Color(0xFF4A5070) : Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return kPrimaryColor.withValues(alpha: 0.4);
        }
        return isDark ? const Color(0xFF2E3348) : Colors.grey.shade300;
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
            const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? const Color(0xFF252839) : const Color(0xFF1A1A2E),
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
