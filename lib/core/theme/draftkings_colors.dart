import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DraftKings Sportsbook color system — extracted directly from APK resources.
//
// Every constant below carries a source comment pointing to the exact APK file
// and attribute.  If a token could NOT be confirmed in the APK it is marked
// [NOT FOUND IN APK] — do NOT substitute a guess; decide deliberately.
// ─────────────────────────────────────────────────────────────────────────────

class DraftKingsColors {
  // ── Brand Green ─────────────────────────────────────────────────────────────

  /// `colorAccent` — Theme.Sportsbook, res/values/styles.xml
  static const Color dkGreen = Color(0xFF53D337);

  /// `bet_slip_count_circle.xml` + `bet_slip_count_check.xml`
  /// Solid dark-green used for the bet-slip count badge background.
  static const Color dkGreenDark = Color(0xFF2A751A);

  /// `product_icon_background` — res/values/colors.xml
  /// The lime-green circle behind product icons in the app icon / launcher.
  static const Color dkGreenLight = Color(0xFF61B50F);

  // ── Surfaces ─────────────────────────────────────────────────────────────────

  /// `android:statusBarColor` / `android:navigationBarColor`
  /// Theme.Sportsbook, res/values/styles.xml.
  /// Also the card outer fill colour in res/drawable/bg_shimmer_position_card.xml.
  static const Color background = Color(0xFF121212);

  /// `android:windowBackground` — Theme.Sportsbook, res/values/styles.xml.
  /// The layer beneath everything (window canvas, under-status-bar area).
  static const Color windowBg = Color(0xFF000000);

  /// `colorPrimary` — Theme.Sportsbook, res/values/styles.xml.
  /// Used as the primary toolbar / action-bar surface in MaterialComponents.
  static const Color surface = Color(0xFF222326);

  /// `lobby_nav_bar_local_button_color` — res/values/colors.xml.
  /// Also confirmed by `res/drawable/bg_shimmer_loader_header.xml` fillColor.
  /// Navigation bar background / section-header surface.
  static const Color surfaceNav = Color(0xFF242424);

  /// `android:itemBackground` — Theme.Sportsbook, res/values/styles.xml.
  /// Pop-up menus, overflow dropdowns, elevated overlay surfaces.
  static const Color surfaceElevated = Color(0xFF373737);

  /// Inner cell background on bet position cards.
  /// Source: `res/drawable/bg_shimmer_position_card.xml` — second rounded rect
  /// layer drawn at #000000 inside the card (odds button cells).
  static const Color cellInner = Color(0xFF000000);

  // ── Borders ───────────────────────────────────────────────────────────────────

  /// `searchbar_border_color` — res/values/colors.xml.
  /// Input field / search bar border.
  static const Color border = Color(0xFF424242);

  /// Card hairline border.
  /// Source: `res/drawable/bg_shimmer_position_card.xml`
  ///   `android:strokeColor="#ffffff"` + `android:strokeAlpha="0.08"`.
  /// 8 % opaque white → 0x14 alpha channel.
  static const Color borderSubtle = Color(0x14FFFFFF);

  // ── Text / Icons ──────────────────────────────────────────────────────────────

  /// Full-white primary label.
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// `results_text_color` — res/values/colors.xml.
  /// Secondary text and inactive bottom-nav icon tint.
  static const Color textSecondary = Color(0xFFABABAB);

  /// `android:tint` — res/values-night/styles.xml.
  /// Low-priority / ghost-label text.
  static const Color textMuted = Color(0xFF777777);

  // ── Semantic states ───────────────────────────────────────────────────────────

  /// `res/drawable/ic_bet_status_green_check.xml` — strokeColor.
  /// WON / settled-win status indicator.
  static const Color success = Color(0xFF53D337); // same as dkGreen

  /// `res/drawable/ic_bet_status_yellow_circle.xml` — strokeColor.
  /// Also primary fill in `res/drawable/bg_won_assert_rva.xml` (confetti).
  /// LIVE / in-progress / open status indicator.
  static const Color warning = Color(0xFFF7D002);

  /// `res/drawable/ic_bet_status_red_x.xml` — strokeColor.
  /// LOST / error status indicator.
  /// NOTE: the APK value is #E9344A — not #CC3333 which was previously used.
  static const Color danger = Color(0xFFE9344A);

  // ── Odds colours ─────────────────────────────────────────────────────────────

  // oddsPositive — NOT FOUND IN APK.
  //   No explicit named token exists in res/values/colors.xml or drawables.
  //   DraftKings likely reuses `dkGreen` (#53D337) for positive-odds display.
  //   Declare it here only when confirmed by a layout/style reference.

  // oddsNegative — NOT FOUND IN APK.
  //   No explicit named token exists.  DraftKings likely reuses `danger`
  //   (#E9344A) for negative-odds display.

  // ── Gold / Dynasty tiers ──────────────────────────────────────────────────────

  /// `dynasty_gold_color` — res/values/colors.xml.
  /// Light warm-gold used for Dynasty Rewards Gold tier text / badge fill.
  static const Color promoGold = Color(0xFFFBE0AF);

  /// `dynasty_gold_indicator_color` — res/values/colors.xml.
  /// Bright-gold accent for Dynasty Rewards Gold indicator dots / rings.
  static const Color promoGoldDark = Color(0xFFFFC14E);

  // ── WON animation gold palette ────────────────────────────────────────────────
  // Source: res/drawable/bg_won_asset.xml (multi-stop trophy/confetti graphic)

  /// Primary confetti / sparkle colour in WON animations.
  static const Color wonGold = Color(0xFFF7D002);

  /// Mid-tone gold — bg_won_asset.xml gradient stop.
  static const Color wonGoldMid = Color(0xFFD6A10A);

  // ── Additional brand colours ──────────────────────────────────────────────────

  /// `app_logo.xml` — fillColor of the dark-green circle in the DK app icon.
  static const Color appIconGreen = Color(0xFF225843);

  /// `reels_icon_background` — res/values/colors.xml.
  static const Color reelsBg = Color(0xFF242424); // same as surfaceNav
}
