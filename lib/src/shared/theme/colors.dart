import 'package:flutter/material.dart';

/// Ancient Egyptian Color Palette
/// Inspired by the colors of pharaonic Egypt:
/// – Gold & amber from the treasures of Tutankhamun
/// – Deep lapis lazuli from sacred amulets
/// – Warm papyrus and sandstone neutrals
/// – Rich obsidian for dark mode depth
/// – Turquoise from Sinai mines used in royal jewelry
class AppColors {
  AppColors._();

  // ─── Core Egyptian Palette ─────────────────────────────────────────────────

  /// Pharaoh's Gold — primary brand color
  static const Color pharaohGold = Color(0xFFD4A017);

  /// Deep Gold — slightly richer, for pressed/hover states
  static const Color deepGold = Color(0xFFB8860B);

  /// Ancient Amber — warm accent gold
  static const Color ancientAmber = Color(0xFFE8B84B);

  /// Polished Gold — light highlight gold
  static const Color polishedGold = Color(0xFFF5D060);

  /// Lapis Lazuli — sacred Egyptian blue, secondary accent
  static const Color lapisLazuli = Color(0xFF1A3A5C);

  /// Royal Blue — slightly lighter lapis
  static const Color royalBlue = Color(0xFF234E7A);

  /// Nile Blue — soft blue-teal for info states
  static const Color nileBlue = Color(0xFF2E6B8A);

  /// Sacred Turquoise — accent for highlights & icons
  static const Color sacredTurquoise = Color(0xFF3AAFA9);

  /// Light Turquoise — pale variant
  static const Color lightTurquoise = Color(0xFF5DC9C4);

  /// Osiris Green — success / nature
  static const Color osirisGreen = Color(0xFF2D6A4F);

  /// Desert Sand — warm neutral background
  static const Color desertSand = Color(0xFFF5EDD6);

  /// Papyrus — lightest background surface
  static const Color papyrus = Color(0xFFFBF6E9);

  /// Sandstone — mid-tone neutral card surface
  static const Color sandstone = Color(0xFFEDD9A3);

  /// Obsidian — deep dark background (dark mode)
  static const Color obsidian = Color(0xFF0F0E0A);

  /// Dark Tomb — dark surface (dark mode)
  static const Color darkTomb = Color(0xFF1C1A14);

  /// Dark Chamber — card surface (dark mode)
  static const Color darkChamber = Color(0xFF252219);

  /// Dark Scroll — elevated surface (dark mode)
  static const Color darkScroll = Color(0xFF2E2A1F);

  /// Mummy Linen — light divider
  static const Color mummyLinen = Color(0xFFDDD0B3);

  /// Dark Hieroglyph — dark mode divider
  static const Color darkHieroglyph = Color(0xFF3A3528);

  /// Kohl Black — dark text
  static const Color kohlBlack = Color(0xFF1A1712);

  /// Papyrus Text — secondary text on light
  static const Color papyrusText = Color(0xFF6B5C3E);

  /// Ghost Gold — muted text on dark
  static const Color ghostGold = Color(0xFFB09A6A);

  /// Moonstone — primary text on dark
  static const Color moonstone = Color(0xFFF0E8D0);

  /// Blood of Ra — error/danger
  static const Color bloodOfRa = Color(0xFFB33A3A);

  /// Pale Error — light error variant
  static const Color paleError = Color(0xFFFFEDED);

  // ─── Light Theme Semantic Tokens ───────────────────────────────────────────
  static const Color lightPrimary = pharaohGold;
  static const Color lightSecondary = sacredTurquoise;
  static const Color lightSurface = papyrus;
  static const Color lightBackground = desertSand;
  static const Color lightError = bloodOfRa;
  static const Color lightOnPrimary = kohlBlack;
  static const Color lightOnSecondary = Colors.white;
  static const Color lightOnSurface = kohlBlack;
  static const Color lightOnBackground = kohlBlack;
  static const Color lightOnError = Colors.white;

  static const Color cardLight = papyrus;
  static const Color dividerLight = mummyLinen;
  static const Color textPrimaryLight = kohlBlack;
  static const Color textSecondaryLight = papyrusText;

  // ─── Dark Theme Semantic Tokens ────────────────────────────────────────────
  static const Color darkPrimary = ancientAmber;
  static const Color darkSecondary = lightTurquoise;
  static const Color darkSurface = darkTomb;
  static const Color darkBackground = obsidian;
  static const Color darkError = Color(0xFFE05C5C);
  static const Color darkOnPrimary = obsidian;
  static const Color darkOnSecondary = obsidian;
  static const Color darkOnSurface = moonstone;
  static const Color darkOnBackground = moonstone;
  static const Color darkOnError = Colors.white;

  static const Color cardDark = darkChamber;
  static const Color dividerDark = darkHieroglyph;
  static const Color textPrimaryDark = moonstone;
  static const Color textSecondaryDark = ghostGold;

  // ─── Gradient Presets ──────────────────────────────────────────────────────

  static const LinearGradient pharaohGradient = LinearGradient(
    colors: [pharaohGold, ancientAmber, polishedGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tombGradient = LinearGradient(
    colors: [obsidian, darkTomb, Color(0xFF201D14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sunsetNileGradient = LinearGradient(
    colors: [Color(0xFFD4A017), Color(0xFFE8763A), Color(0xFFB33A3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lapislazuliGradient = LinearGradient(
    colors: [lapisLazuli, royalBlue, nileBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Overlay / Tint Helpers ────────────────────────────────────────────────

  static Color goldOverlay(double opacity) => pharaohGold.withOpacity(opacity);

  static Color turquoiseOverlay(double opacity) =>
      sacredTurquoise.withOpacity(opacity);
}
