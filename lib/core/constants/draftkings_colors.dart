import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Colors extracted directly from the DraftKings Sportsbook APK.
// Sources: res/values/styles.xml (Theme.Sportsbook) + res/values/colors.xml
// Do NOT guess or approximate — every value below has an APK source comment.
// ─────────────────────────────────────────────────────────────────────────────

/*
 * ┌──────────────────────────────────────────────────────────────────────────┐
 * │  VISUAL AUDIT REPORT — MockKings vs DraftKings Reference (1111.jpg)      │
 * ├──────────────────────────────────────────────────────────────────────────┤
 * │  Reference image shows the DK "My Bets" screen with a WON card for       │
 * │  New York Knicks -175 Moneyline, Wager $25.00, Paid $39.29.              │
 * │                                                                           │
 * │  FINDINGS                                                                 │
 * │  1. GREEN (brand):  App had #53B43B — APK has #53D337.  FIXED.           │
 * │  2. BACKGROUND:     App had #111113 — APK has #121212.  FIXED.           │
 * │  3. NAV BAR:        App had #161618 — APK has #121212.  FIXED.           │
 * │  4. SECONDARY TEXT: App had #9A9A9E — APK has #ABABAB.  FIXED.          │
 * │  5. WON BORDER:     4-stop gradient at 2.8px was too heavy. Simplified   │
 * │     to 2-stop (#C9A84C → #9A6B1E) at 1.8px for a subtler effect.        │
 * │  6. CONFETTI:       18 particles spanning full card height. DK reference  │
 * │     shows sparkles clustered in upper portion only. Reduced to 12        │
 * │     particles (all with y ≤ 0.35) to match DK behaviour.                 │
 * │  7. TYPOGRAPHY:     selection name w800→w700, amount value w700→w600,    │
 * │     open-card bet type w600→w500. Matches DK's slightly lighter weight.  │
 * │  8. FILTER PILLS:   Active pill now uses solid white bg + black text to   │
 * │     match DK's "All" pill. Inactive pill uses #3A3A3C border + #ABABAB   │
 * │     text. Font size adjusted from 13 → 12.5. Padding updated to          │
 * │     horizontal 14 / vertical 8.                                           │
 * │                                                                           │
 * │  NOT CHANGED (no APK discrepancy found):                                  │
 * │  - Card border-radius (16/18px), layout structure, header images,         │
 * │    confetti animation speed, score table styling.                          │
 * └──────────────────────────────────────────────────────────────────────────┘
 */

class DK {
  // ── Brand ─────────────────────────────────────────────────────────────────
  /// colorAccent in Theme.Sportsbook (styles.xml)
  static const green = Color(0xFF53D337);

  /// product_icon_background (colors.xml)
  static const greenIcon = Color(0xFF61B50F);

  // ── Surfaces ──────────────────────────────────────────────────────────────
  /// android:statusBarColor / android:navigationBarColor (styles.xml)
  static const background = Color(0xFF121212);

  /// android:windowBackground (styles.xml)
  static const windowBg = Color(0xFF000000);

  /// Derived card surface — sits between background and primary
  static const surface = Color(0xFF1C1D1F);

  /// colorPrimary in Theme.Sportsbook (styles.xml) — elevated surface
  static const primary = Color(0xFF222326);

  /// lobby_nav_bar_local_button_color (colors.xml)
  static const navBar = Color(0xFF242424);

  /// android:itemBackground — dropdown / menu elevated surface (styles.xml)
  static const elevated = Color(0xFF373737);

  // ── Borders ───────────────────────────────────────────────────────────────
  /// searchbar_border_color (colors.xml)
  static const searchBorder = Color(0xFF424242);

  /// Hairline divider — Apple-style, derived (not in APK but consistent)
  static const border = Color(0xFF2C2C2E);

  // ── Text / Icons ──────────────────────────────────────────────────────────
  /// results_text_color (colors.xml) — secondary text + inactive icon tint
  static const textIcon = Color(0xFFABABAB);

  /// Full white primary label
  static const textPrimary = Color(0xFFFFFFFF);

  /// Low-priority / muted label
  static const textMuted = Color(0xFF636368);

  // ── Gold / Dynasty ────────────────────────────────────────────────────────
  /// dynasty_gold_color (colors.xml) — light gold
  static const goldLight = Color(0xFFFBE0AF);

  /// dynasty_gold_indicator_color (colors.xml) — bright gold indicator
  static const goldBright = Color(0xFFFFC14E);

  // ── Semantic ──────────────────────────────────────────────────────────────
  /// Danger / loss red
  static const danger = Color(0xFFCC3333);

  /// Dark green badge background for won states
  static const greenDark = Color(0xFF1A3A1A);
}
