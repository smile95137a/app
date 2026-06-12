import 'package:flutter/material.dart';

class AppColors {
  // ── Surfaces ────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF121212);  // APK: android:statusBarColor (Theme.Sportsbook)
  static const Color cardBg    = Color(0xFF242424);  // DK card surface
  static const Color innerCard = Color(0xFF252527);  // nested / cell backgrounds
  static const Color navBar    = Color(0xFF121212);  // APK: android:navigationBarColor (Theme.Sportsbook)

  // ── Brand ───────────────────────────────────────────────────────────────────
  static const Color green          = Color(0xFF53D337);  // APK: colorAccent (Theme.Sportsbook)
  static const Color greenDarkBadge = Color(0xFF193314);
  static const Color goldBorder     = Color(0xFFB8913B);

  // ── Text ────────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFABABAB);  // APK: results_text_color (colors.xml)
  static const Color textMuted     = Color(0xFF636368);  // low-priority label

  // ── Semantic ────────────────────────────────────────────────────────────────
  static const Color danger     = Color(0xFFE9344A);  // APK: ic_bet_status_red_x.xml strokeColor
  static const Color dangerDark = Color(0xFF3A1A1A);
  static const Color warning    = Color(0xFFF7D002);  // APK: ic_bet_status_yellow_circle.xml strokeColor
  static const Color warningDark = Color(0xFF3A3214);

  // ── Structural ──────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFF2C2C2E);  // Apple-style hairline
}
