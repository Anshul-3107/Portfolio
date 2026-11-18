import 'package:flutter/material.dart';
import 'witcher_colors.dart';

class WitcherTypography {
  static const String fontDecorative = 'Cinzel Decorative';
  static const String fontCinzel = 'Cinzel';
  static const String fontBody = 'Plus Jakarta Sans';
  static const String fontLore = 'Marcellus';

  static const List<String> fallbackSerif = ['Cinzel', 'Georgia', 'serif'];
  static const List<String> fallbackSans = ['Plus Jakarta Sans', 'Segoe UI', 'sans-serif'];

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: fontDecorative,
        fontFamilyFallback: fallbackSerif,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 3.5,
        color: WitcherColors.goldBright,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: fontCinzel,
        fontFamilyFallback: fallbackSerif,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.5,
        color: WitcherColors.gold,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontFamily: fontCinzel,
        fontFamilyFallback: fallbackSerif,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.8,
        color: WitcherColors.textParchmentLight,
      );

  static TextStyle get subtitle => const TextStyle(
        fontFamily: fontCinzel,
        fontFamilyFallback: fallbackSerif,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: WitcherColors.textMuted,
      );

  static TextStyle get navTab => const TextStyle(
        fontFamily: fontCinzel,
        fontFamilyFallback: fallbackSerif,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: fontBody,
        fontFamilyFallback: fallbackSans,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: WitcherColors.textParchment,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: fontBody,
        fontFamilyFallback: fallbackSans,
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: WitcherColors.textParchment,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: fontBody,
        fontFamilyFallback: fallbackSans,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: WitcherColors.textMuted,
      );

  static TextStyle get metricValue => const TextStyle(
        fontFamily: fontCinzel,
        fontFamilyFallback: fallbackSerif,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: WitcherColors.goldBright,
      );

  static TextStyle get metricLabel => const TextStyle(
        fontFamily: fontCinzel,
        fontFamilyFallback: fallbackSerif,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: WitcherColors.textMuted,
      );

  static TextStyle get tagText => const TextStyle(
        fontFamily: fontBody,
        fontFamilyFallback: fallbackSans,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get quoteText => const TextStyle(
        fontFamily: fontLore,
        fontFamilyFallback: fallbackSerif,
        fontSize: 14,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.0,
        color: WitcherColors.goldMuted,
      );
}
