import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DraftKings Sportsbook — dark-surface layer system.
//
// Android paints surfaces in elevation layers (lower index = further back).
// Every value below is sourced directly from the decompiled APK.
// Layers are ordered from the deepest background to the most elevated surface.
// ─────────────────────────────────────────────────────────────────────────────

class DraftKingsSurfaces {
  // ── Layer 0: Window canvas ────────────────────────────────────────────────────
  /// `android:windowBackground` — Theme.Sportsbook, res/values/styles.xml.
  /// The raw window background (behind status bar cutout, behind everything).
  static const Color layer0Window = Color(0xFF000000);

  // ── Layer 1: App / page background ────────────────────────────────────────────
  /// `android:statusBarColor` / `android:navigationBarColor`
  /// Theme.Sportsbook, res/values/styles.xml.
  ///
  /// Also confirmed by `res/drawable/bg_shimmer_position_card.xml`:
  ///   outer card rounded-rect is drawn at #121212 — cards sit flush with the
  ///   page background; the card surface IS the page background.
  static const Color layer1Background = Color(0xFF121212);

  // ── Layer 2: Navigation / section-header surface ──────────────────────────────
  /// `lobby_nav_bar_local_button_color` — res/values/colors.xml.
  /// Confirmed by `res/drawable/bg_shimmer_loader_header.xml` fillColor.
  ///
  /// Used for: bottom navigation bar, section header bars, tab containers.
  static const Color layer2Nav = Color(0xFF242424);

  // ── Layer 3: Elevated overlays / dropdown menus ───────────────────────────────
  /// `android:itemBackground` — Theme.Sportsbook, res/values/styles.xml.
  /// Used for popup menus, overflow drop-downs, contextual overlays.
  static const Color layer3Elevated = Color(0xFF373737);

  // ── Card inner cell ────────────────────────────────────────────────────────────
  /// Inner darker cell drawn inside a bet-position card.
  /// Source: `res/drawable/bg_shimmer_position_card.xml` — second path at #000000.
  /// Applied to: odds-button cells, score-table cells within a card.
  static const Color cardInner = Color(0xFF000000); // same as layer0Window

  // ── Supplementary surface colours ─────────────────────────────────────────────

  /// `colorPrimary` — Theme.Sportsbook, res/values/styles.xml.
  /// MaterialComponents maps this to the ActionBar / AppBar background.
  static const Color toolbar = Color(0xFF222326);

  /// `colorPrimaryDark` — Theme.Sportsbook, res/values/styles.xml.
  static const Color toolbarDark = Color(0xFF000000); // same as layer0Window

  // ── Card border ────────────────────────────────────────────────────────────────
  /// Source: `res/drawable/bg_shimmer_position_card.xml`
  ///   strokeColor="#ffffff" + strokeAlpha="0.08"  (8 % opaque white).
  ///
  /// Render as: Border.all(color: DraftKingsSurfaces.cardBorder, width: 1.0)
  static const Color cardBorder = Color(0x14FFFFFF);

  // ── Shimmer highlight ──────────────────────────────────────────────────────────
  /// `res/drawable/_bg_shimmer_loader_item__0_res_0x7f08000a.xml`
  ///   android:color="#ff242424" (opaque end-stop of shimmer gradient).
  /// The loading-skeleton shimmer pulse colour on list items.
  static const Color shimmerHighlight = Color(0xFF242424); // same as layer2Nav

  // ─────────────────────────────────────────────────────────────────────────────
  // SURFACE TOKENS NOT FOUND IN APK
  //
  // The following tokens have NO explicit named value in the decompiled APK:
  //
  //   • betCard background  — bg_shimmer_position_card.xml shows cards sit at
  //     layer1Background (#121212), differentiated only by cardBorder.
  //     There is no separate "cardBackground" colour token.
  //
  //   • bottomSheet background — no explicit value found in values/ or drawable/
  //
  //   • dialog background — AppCompatDialogStyle does not override windowBackground
  //     with a literal hex; it inherits from the Material theme.
  // ─────────────────────────────────────────────────────────────────────────────
}
