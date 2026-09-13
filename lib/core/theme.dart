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

  // Surfaces — warm charcoal for dark, warm ivory for light
  final Color background  = isDark ? kDarkBackground  : kBackgroundColor;
  final Color surface     = isDark ? kDarkSurface     : Colors.white;
  final Color card        = isDark ? kDarkCard        : Colors.white;
  final Color textPrimary = isDark ? kDarkTextPrimary : kTextPrimary;
  final Color textSec     = isDark ? kDarkTextSecondary : kTextSecondary;
  final Color textLight   = isDark ? kDarkTextLight   : kTextLight;
  final Color divider     = isDark ? kDarkDivider     : const Color(0xFFEDE8E3);

  final systemOverlay = isDark
      ? SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: kDarkBackground,
          systemNavigationBarIconBrightness: Brightness.light,
        )
      : SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: kBackgroundColor,
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
      tertiary: kGradientEnd,
      onTertiary: Colors.white,
      error: const Color(0xFFE53935),
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    ),
    cardColor: card,
    dividerColor: divider,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary,
          letterSpacing: -0.5),
      displayMedium: GoogleFonts.inter(
          fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary,
          letterSpacing: -0.3),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonRadius)),
        textStyle:
            GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kPrimaryColor;
        return isDark ? const Color(0xFF5A4E48) : Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return kPrimaryColor.withValues(alpha: 0.45);
        }
        return isDark ? const Color(0xFF3D3530) : Colors.grey.shade300;
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? kDarkSurface : const Color(0xFFF5F0EC),
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
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        color: isDark ? kDarkTextLight : kTextLight,
        fontSize: 14,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? kDarkCard : kTextPrimary,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    // Progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: kPrimaryColor,
    ),
    // Chip theme for any category chips
    chipTheme: ChipThemeData(
      backgroundColor: isDark ? kDarkCard : const Color(0xFFF5F0EC),
      selectedColor: kPrimaryColor,
      secondarySelectedColor: kPrimaryColor,
      labelStyle: GoogleFonts.inter(fontSize: 13, color: textSec),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
